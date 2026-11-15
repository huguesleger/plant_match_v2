import {FieldValue} from "firebase-admin/firestore";
import {REFERRAL_FIRST_TRANSACTION_BONUS} from "./rewards";

type Db = FirebaseFirestore.Firestore;
type Tx = FirebaseFirestore.Transaction;
type Ref = FirebaseFirestore.DocumentReference;

export interface SponsorReward {
  sponsorRef: Ref;
  flagRef: Ref;
}

// Lectures à faire avant toute écriture de la transaction.
// Le parrain n'est récompensé qu'au premier don ou échange de son
// filleul, et jamais si ce premier partenaire est le parrain lui-même.
export const findSponsorReward = async (
  tx: Tx,
  db: Db,
  uid: string,
  partnerId: string,
): Promise<SponsorReward | null> => {
  const userRef = db.collection("users").doc(uid);
  const flagRef = userRef.collection("private").doc("sponsorship");
  const [user, flag] = await Promise.all([tx.get(userRef), tx.get(flagRef)]);
  const code: unknown = user.data()?.referredBy;
  if (typeof code !== "string" || flag.data()?.rewarded === true) {
    return null;
  }
  const codeDoc = await tx.get(db.collection("referralCodes").doc(code));
  const sponsorId: unknown = codeDoc.data()?.uid;
  if (typeof sponsorId !== "string" || sponsorId === partnerId) return null;
  return {sponsorRef: db.collection("users").doc(sponsorId), flagRef};
};

export const applySponsorReward = (tx: Tx, reward: SponsorReward) => {
  tx.set(reward.sponsorRef, {
    leaves: FieldValue.increment(REFERRAL_FIRST_TRANSACTION_BONUS),
  }, {merge: true});
  tx.set(reward.flagRef, {
    rewarded: true,
    rewardedAt: FieldValue.serverTimestamp(),
  }, {merge: true});
};
