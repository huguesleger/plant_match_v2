import * as admin from "firebase-admin";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {REGION} from "./config";

const STORAGE_HOST = "firebasestorage.googleapis.com";

const storagePathOf = (url: unknown): string[] => {
  if (typeof url !== "string") return [];
  try {
    const parsed = new URL(url);
    const match = parsed.pathname.match(/\/o\/(.+)$/);
    return parsed.hostname === STORAGE_HOST && match ?
      [decodeURIComponent(match[1])] :
      [];
  } catch {
    return [];
  }
};

const deleteFile = (path: string) =>
  admin.storage().bucket().file(path).delete({ignoreNotFound: true});

export const deleteAccount = onCall({region: REGION}, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Connexion requise");
  }
  const db = admin.firestore();
  const catalogs = await db.collection("catalogs")
    .where("userId", "==", uid)
    .get();

  const catalogImages = catalogs.docs
    .flatMap((doc) => (doc.get("images") ?? []) as unknown[])
    .flatMap(storagePathOf);

  await Promise.all([
    ...catalogImages,
    `profile_images/${uid}`,
    `profile_images/avatar/${uid}`,
  ].map(deleteFile));

  const writer = db.bulkWriter();
  catalogs.docs.forEach((doc) => writer.delete(doc.ref));
  await writer.close();

  await Promise.all([
    db.recursiveDelete(db.collection("users").doc(uid)),
    db.collection("userPoints").doc(uid).delete(),
    db.collection("user_recommendations").doc(uid).delete(),
  ]);

  await admin.auth().deleteUser(uid);
  return {deleted: true};
});
