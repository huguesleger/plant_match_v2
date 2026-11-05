import * as admin from "firebase-admin";
import {FieldValue} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {REGION} from "./config";
import {CONTACT_COST, hasUnlimitedContacts, REFERRAL_BONUS} from "./rewards";

const requireAuth = (uid: string | undefined): string => {
  if (uid) return uid;
  throw new HttpsError("unauthenticated", "Connexion requise");
};

export const payFirstContact = onCall({region: REGION}, async (request) => {
  const uid = requireAuth(request.auth?.uid);
  const chatId = request.data?.chatId;
  if (typeof chatId !== "string" || chatId.length === 0) {
    throw new HttpsError("invalid-argument", "Paramètre manquant : chatId");
  }
  const db = admin.firestore();
  const chatRef = db.collection("plant_chats").doc(chatId);
  const userRef = db.collection("users").doc(uid);
  const pointsRef = db.collection("userPoints").doc(uid);

  return db.runTransaction(async (tx) => {
    const [chat, user, points, existingMessages] = await Promise.all([
      tx.get(chatRef),
      tx.get(userRef),
      tx.get(pointsRef),
      tx.get(chatRef.collection("messages").limit(1)),
    ]);
    const chatData = chat.data();
    if (!chatData) {
      throw new HttpsError("not-found", "Conversation introuvable");
    }
    const participants: string[] = chatData.participants ?? [];
    if (!participants.includes(uid)) {
      throw new HttpsError("permission-denied", "Conversation inaccessible");
    }
    // lastMessage est modifiable par le client : on ne s'y fie pas.
    // Un message existant suffit (conversations antérieures à contactPaid),
    // car les règles n'autorisent un message que si le contact est payé
    // ou envoyé par le propriétaire de la plante.
    const alreadyPaid = chatData.plantOwnerId === uid ||
      chatData.contactPaid === true ||
      !existingMessages.empty;
    const unlimited = hasUnlimitedContacts(points.data()?.level ?? 1);
    const cost = alreadyPaid || unlimited ? 0 : CONTACT_COST;
    if ((user.data()?.leaves ?? 0) < cost) {
      throw new HttpsError(
        "failed-precondition",
        "Plus de feuilles disponibles pour contacter ce donneur",
      );
    }
    if (chatData.contactPaid !== true && chatData.plantOwnerId !== uid) {
      tx.update(chatRef, {contactPaid: true});
    }
    if (cost > 0) {
      tx.set(userRef, {leaves: FieldValue.increment(-cost)}, {merge: true});
    }
    return {cost};
  });
});

const REFERRAL_WINDOW_MS = 7 * 24 * 60 * 60 * 1000;
const MAX_SPONSOR_REWARDS = 20;

export const applyReferral = onCall({region: REGION}, async (request) => {
  const uid = requireAuth(request.auth?.uid);
  const raw = request.data?.code;
  const code = typeof raw === "string" ? raw.trim().toUpperCase() : "";
  if (code.length === 0) return {bonus: 0};

  const authUser = await admin.auth().getUser(uid);
  const createdAt = Date.parse(authUser.metadata.creationTime);
  if (Date.now() - createdAt > REFERRAL_WINDOW_MS) return {bonus: 0};

  const db = admin.firestore();
  const users = db.collection("users");
  const codeRef = db.collection("referralCodes").doc(code);
  const userRef = users.doc(uid);

  return db.runTransaction(async (tx) => {
    const codeDoc = await tx.get(codeRef);
    const sponsorId: unknown = codeDoc.data()?.uid;
    if (typeof sponsorId !== "string" || sponsorId === uid) {
      return {bonus: 0};
    }
    const sponsorRef = users.doc(sponsorId);
    const statsRef = sponsorRef.collection("private").doc("referral");
    const [user, sponsor, stats] = await Promise.all([
      tx.get(userRef),
      tx.get(sponsorRef),
      tx.get(statsRef),
    ]);
    const data = user.data();
    const crossReferral = data?.referralCode != null &&
      sponsor.data()?.referredBy === data.referralCode;
    if (!data || data.referredBy != null || crossReferral) {
      return {bonus: 0};
    }
    const sponsorRewarded = (stats.data()?.count ?? 0) < MAX_SPONSOR_REWARDS;
    tx.set(userRef, {
      referredBy: code,
      leaves: FieldValue.increment(REFERRAL_BONUS),
    }, {merge: true});
    if (sponsorRewarded) {
      tx.set(sponsorRef, {
        leaves: FieldValue.increment(REFERRAL_BONUS),
      }, {merge: true});
      tx.set(statsRef, {count: FieldValue.increment(1)}, {merge: true});
    }
    return {bonus: REFERRAL_BONUS};
  });
});
