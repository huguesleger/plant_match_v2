import {randomInt} from "crypto";
import * as admin from "firebase-admin";
import {FieldValue} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {REGION} from "./config";
import {computeUpdate, PLANT_GIVEN_LEAVES, PointsUpdate} from "./rewards";

type Kind = "donation" | "exchange";

const collectionFor = (kind: Kind) =>
  kind === "donation" ? "plant_donations" : "plant_exchanges";

const parseKind = (value: unknown): Kind => {
  if (value === "donation" || value === "exchange") return value;
  throw new HttpsError("invalid-argument", "Type de transaction invalide");
};

const requireString = (value: unknown, name: string): string => {
  if (typeof value === "string" && value.length > 0) return value;
  throw new HttpsError("invalid-argument", `Paramètre manquant : ${name}`);
};

const requireAuth = (uid: string | undefined): string => {
  if (uid) return uid;
  throw new HttpsError("unauthenticated", "Connexion requise");
};

const ensure = (condition: boolean, message: string) => {
  if (!condition) throw new HttpsError("failed-precondition", message);
};

const MAX_ATTEMPTS = 5;
const PAIR_REWARD_COOLDOWN_MS = 7 * 24 * 60 * 60 * 1000;

const completedFlagFor = (kind: Kind) =>
  kind === "donation" ? "isDonationCompleted" : "isExchangeCompleted";

const pairKey = (a: string, b: string) => [a, b].sort().join("_");

type Doc = FirebaseFirestore.DocumentData;

// Vérifie que la transaction n'a pas été forgée par le client :
// deux parties distinctes, toutes deux dans la conversation,
// et chaque plante appartient bien à la bonne partie.
const ensureIntegrity = (
  kind: Kind,
  data: Doc,
  chat: Doc | undefined,
  plantIds: string[],
  plants: (Doc | undefined)[],
) => {
  const ownerId: string = data.ownerId;
  const requesterId: string = data.requestedBy;
  ensure(
    typeof ownerId === "string" &&
      typeof requesterId === "string" &&
      ownerId !== requesterId,
    "Transaction invalide",
  );
  const participants: string[] = chat?.participants ?? [];
  ensure(
    participants.includes(ownerId) && participants.includes(requesterId),
    "Transaction invalide",
  );
  ensure(chat?.plantId === plantIds[0], "Transaction invalide");
  ensure(
    chat?.[completedFlagFor(kind)] !== true,
    "Cette conversation a déjà abouti",
  );
  const expectedOwners = kind === "donation" ?
    [ownerId] :
    [ownerId, requesterId];
  ensure(
    plants.length === expectedOwners.length &&
      plants.every((p, i) => p?.userId === expectedOwners[i]),
    "Transaction invalide",
  );
};

const plantIdsOf = (kind: Kind, data: Doc): string[] => {
  const ids: unknown[] = kind === "donation" ?
    [data.plantId] :
    [data.targetPlantId, data.offeredPlantId];
  ensure(
    ids.every((id) => typeof id === "string" && id.length > 0),
    "Transaction invalide",
  );
  return ids as string[];
};

export const generateHandoverCode = onCall(
  {region: REGION},
  async (request) => {
    const uid = requireAuth(request.auth?.uid);
    const kind = parseKind(request.data?.kind);
    const id = requireString(request.data?.id, "id");
    const db = admin.firestore();
    const ref = db.collection(collectionFor(kind)).doc(id);

    await db.runTransaction(async (tx) => {
      const doc = await tx.get(ref);
      const data = doc.data();
      if (!data) throw new HttpsError("not-found", "Transaction introuvable");
      ensure(data.ownerId === uid, "Seul le propriétaire peut générer le code");
      ensure(typeof data.chatId === "string", "Transaction invalide");
      const plantRefs = plantIdsOf(kind, data)
        .map((p) => db.collection("catalogs").doc(p));
      const [chat, ...plants] = await Promise.all([
        tx.get(db.collection("plant_chats").doc(data.chatId)),
        ...plantRefs.map((r) => tx.get(r)),
      ]);
      ensureIntegrity(
        kind,
        data,
        chat.data(),
        plantIdsOf(kind, data),
        plants.map((p) => p.data()),
      );
      ensure(
        plants.every((p) => p.data()?.status === "published"),
        "Cette plante n'est plus disponible",
      );
      ensure(
        data.status === "accepted" || data.status === "waitingValidation",
        "La demande doit être acceptée avant de générer un code",
      );
      tx.set(ref.collection("private").doc("validation"), {
        code: randomInt(100000, 1000000).toString(),
        ownerId: uid,
        attempts: 0,
        createdAt: FieldValue.serverTimestamp(),
      });
      tx.update(ref, {status: "waitingValidation", seenByRequester: false});
    });

    return {ok: true};
  });

export const validateHandover = onCall({region: REGION}, async (request) => {
  const uid = requireAuth(request.auth?.uid);
  const kind = parseKind(request.data?.kind);
  const id = requireString(request.data?.id, "id");
  const code = requireString(request.data?.code, "code");
  const db = admin.firestore();
  const ref = db.collection(collectionFor(kind)).doc(id);

  const outcome = await db.runTransaction(async (tx) => {
    const doc = await tx.get(ref);
    const data = doc.data();
    if (!data) throw new HttpsError("not-found", "Transaction introuvable");
    const secretRef = ref.collection("private").doc("validation");
    const secret = await tx.get(secretRef);

    const ownerId: string = data.ownerId;
    const requesterId: string = data.requestedBy;
    ensure(typeof data.chatId === "string", "Transaction invalide");
    const chatRef = db.collection("plant_chats").doc(data.chatId);
    const chat = await tx.get(chatRef);
    const plantIds = plantIdsOf(kind, data);
    const plantRefs = plantIds.map((p) => db.collection("catalogs").doc(p));
    const plants = await Promise.all(plantRefs.map((r) => tx.get(r)));
    const ownerPointsRef = db.collection("userPoints").doc(ownerId);
    const requesterPointsRef = db.collection("userPoints").doc(requesterId);
    const rewardRef = db.collection("rewardLog")
      .doc(pairKey(ownerId, requesterId));
    const [ownerPoints, requesterPoints, rewardLog] = await Promise.all([
      tx.get(ownerPointsRef),
      tx.get(requesterPointsRef),
      tx.get(rewardRef),
    ]);

    ensure(data.status === "waitingValidation", "Ce code a déjà été utilisé");
    ensure(requesterId === uid, "Seul le demandeur peut valider");
    ensureIntegrity(
      kind, data, chat.data(), plantIds, plants.map((p) => p.data()),
    );
    const secretData = secret.data();
    ensure(secretData != null, "Aucun code actif, demandez-en un nouveau");
    const attempts: number = secretData?.attempts ?? 0;
    ensure(
      attempts < MAX_ATTEMPTS,
      "Trop d'essais, demandez un nouveau code au propriétaire",
    );
    if (secretData?.code !== code) {
      tx.update(secretRef, {attempts: FieldValue.increment(1)});
      return {wrongCode: true} as const;
    }
    ensure(
      plants.every((p) => p.data()?.status === "published"),
      "Cette plante n'est plus disponible",
    );

    const lastRewardAt: number =
      rewardLog.data()?.lastAt?.toMillis?.() ?? 0;
    const rewarded = Date.now() - lastRewardAt >= PAIR_REWARD_COOLDOWN_MS;
    const points = rewarded ? 1 : 0;
    const gift = rewarded ? PLANT_GIVEN_LEAVES : 0;

    const ownerUpdate = computeUpdate(
      ownerId, ownerPoints.data(), points, gift,
    );
    const requesterUpdate = computeUpdate(
      requesterId,
      requesterPoints.data(),
      points,
      kind === "exchange" ? gift : 0,
    );

    tx.update(ref, {
      status: "completed",
      completedAt: FieldValue.serverTimestamp(),
      completedBy: uid,
    });
    tx.delete(secretRef);
    tx.update(chatRef, {
      [kind === "donation" ? "isDonationCompleted" : "isExchangeCompleted"]:
        true,
    });
    plantRefs.forEach((r) => tx.update(r, {status: "archived"}));
    if (rewarded) {
      tx.set(rewardRef, {
        lastAt: FieldValue.serverTimestamp(),
        count: FieldValue.increment(1),
      }, {merge: true});
    }
    [
      [ownerPointsRef, ownerUpdate] as const,
      [requesterPointsRef, requesterUpdate] as const,
    ].forEach(([pointsRef, update]) => {
      tx.set(
        pointsRef,
        {currentPoints: update.currentPoints, level: update.level},
        {merge: true},
      );
      const leaves = update.bonusLeaves + update.giftedLeaves;
      if (leaves > 0) {
        tx.set(db.collection("users").doc(update.uid), {
          leaves: FieldValue.increment(leaves),
        }, {merge: true});
      }
    });

    const result: PointsUpdate = requesterUpdate;
    return result;
  });

  if ("wrongCode" in outcome) {
    throw new HttpsError("failed-precondition", "Code incorrect");
  }
  return outcome;
});
