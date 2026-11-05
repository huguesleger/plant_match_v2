import * as admin from "firebase-admin";
import {Filter} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {REGION} from "./config";

const completedCount = async (collection: string, uid: string) => {
  const snapshot = await admin
    .firestore()
    .collection(collection)
    .where("status", "==", "completed")
    .where(
      Filter.or(
        Filter.where("ownerId", "==", uid),
        Filter.where("requestedBy", "==", uid),
      ),
    )
    .count()
    .get();
  return snapshot.data().count;
};

/**
 * Nombre d'échanges et de dons terminés d'un utilisateur.
 * Ces documents ne sont lisibles que par leurs participants,
 * on agrège donc côté serveur pour l'afficher sur n'importe quel profil.
 */
export const getCompletedExchangeCount = onCall(
  {region: REGION},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Connexion requise");
    }
    const uid = request.data?.uid;
    if (typeof uid !== "string" || uid.length === 0) {
      throw new HttpsError("invalid-argument", "Paramètre manquant : uid");
    }

    const [exchanges, donations] = await Promise.all([
      completedCount("plant_exchanges", uid),
      completedCount("plant_donations", uid),
    ]);

    return {count: exchanges + donations};
  },
);
