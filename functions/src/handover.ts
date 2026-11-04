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
      ensure(
        data.status === "accepted" || data.status === "waitingValidation",
        "La demande doit être acceptée avant de générer un code",
      );
      tx.set(ref.collection("private").doc("validation"), {
        code: randomInt(100000, 1000000).toString(),
        ownerId: uid,
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

  return db.runTransaction(async (tx) => {
    const doc = await tx.get(ref);
    const data = doc.data();
    if (!data) throw new HttpsError("not-found", "Transaction introuvable");
    const secret = await tx.get(ref.collection("private").doc("validation"));

    const ownerId: string = data.ownerId;
    const requesterId: string = data.requestedBy;
    const plantIds: string[] = kind === "donation" ?
      [data.plantId] :
      [data.targetPlantId, data.offeredPlantId];
    const plantRefs = plantIds.map((p) => db.collection("catalogs").doc(p));
    const plants = await Promise.all(plantRefs.map((r) => tx.get(r)));
    const ownerPointsRef = db.collection("userPoints").doc(ownerId);
    const requesterPointsRef = db.collection("userPoints").doc(requesterId);
    const [ownerPoints, requesterPoints] = await Promise.all([
      tx.get(ownerPointsRef),
      tx.get(requesterPointsRef),
    ]);

    ensure(data.status === "waitingValidation", "Ce code a déjà été utilisé");
    ensure(requesterId === uid, "Seul le demandeur peut valider");
    ensure(secret.data()?.code === code, "Code incorrect");
    ensure(
      plants.every((p) => p.data()?.status === "published"),
      "Cette plante n'est plus disponible",
    );

    const ownerUpdate = computeUpdate(
      ownerId, ownerPoints.data(), 1, PLANT_GIVEN_LEAVES,
    );
    const requesterUpdate = computeUpdate(
      requesterId,
      requesterPoints.data(),
      1,
      kind === "exchange" ? PLANT_GIVEN_LEAVES : 0,
    );

    tx.update(ref, {
      status: "completed",
      completedAt: FieldValue.serverTimestamp(),
      completedBy: uid,
    });
    tx.delete(ref.collection("private").doc("validation"));
    tx.update(db.collection("plant_chats").doc(data.chatId), {
      [kind === "donation" ? "isDonationCompleted" : "isExchangeCompleted"]:
        true,
    });
    plantRefs.forEach((r) => tx.update(r, {status: "archived"}));
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
        tx.update(db.collection("users").doc(update.uid), {
          leaves: FieldValue.increment(leaves),
        });
      }
    });

    const result: PointsUpdate = requesterUpdate;
    return result;
  });
});
