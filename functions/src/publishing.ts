import * as admin from "firebase-admin";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {REGION} from "./config";

export const MAX_IDENTICAL_PLANTS = 5;
export const IDENTICAL_PLANTS_WINDOW_MS = 48 * 60 * 60 * 1000;

const normalizeName = (name: unknown): string =>
  typeof name === "string" ?
    name.trim().toLowerCase().replace(/\s+/g, " ") :
    "";

// Garde-fou serveur : l'app bloque déjà la publication au-delà de la
// limite, ce trigger supprime une plante créée en contournant l'app.
export const enforcePublishQuota = onDocumentCreated(
  {document: "catalogs/{catalogId}", region: REGION},
  async (event) => {
    const snapshot = event.data;
    const data = snapshot?.data();
    if (!snapshot || !data || typeof data.userId !== "string") return;

    const name = normalizeName(data.name);
    const since = Date.now() - IDENTICAL_PLANTS_WINDOW_MS;
    const owned = await admin.firestore()
      .collection("catalogs")
      .where("userId", "==", data.userId)
      .get();
    const identical = owned.docs.filter((doc) =>
      normalizeName(doc.data().name) === name &&
      doc.createTime.toMillis() >= since,
    );
    if (identical.length > MAX_IDENTICAL_PLANTS) {
      console.log(
        `Quota dépassé pour ${data.userId} (${name}), suppression.`,
      );
      await snapshot.ref.delete();
    }
  },
);
