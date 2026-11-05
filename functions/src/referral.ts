import {randomInt} from "crypto";
import * as admin from "firebase-admin";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {REGION} from "./config";

const ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
const CODE_LENGTH = 8;
const MAX_TRIES = 5;

const randomCode = () =>
  "PM-" + Array.from(
    {length: CODE_LENGTH},
    () => ALPHABET[randomInt(ALPHABET.length)],
  ).join("");

const tryAssign = (uid: string, code: string): Promise<boolean> => {
  const db = admin.firestore();
  const codeRef = db.collection("referralCodes").doc(code);
  const userRef = db.collection("users").doc(uid);
  return db.runTransaction(async (tx) => {
    const [codeDoc, userDoc] = await Promise.all([
      tx.get(codeRef),
      tx.get(userRef),
    ]);
    if (userDoc.data()?.referralCode) return true;
    if (codeDoc.exists) return false;
    tx.set(codeRef, {uid});
    tx.set(userRef, {referralCode: code}, {merge: true});
    return true;
  });
};

export const assignReferralCode = onDocumentCreated(
  {document: "users/{uid}", region: REGION},
  async (event) => {
    const uid = event.params.uid;
    for (let attempt = 0; attempt < MAX_TRIES; attempt++) {
      if (await tryAssign(uid, randomCode())) return;
    }
    console.error(`Impossible d'attribuer un code de parrainage à ${uid}`);
  },
);
