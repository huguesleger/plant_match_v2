import * as admin from "firebase-admin";
import {Filter} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {REGION} from "./config";

/**
 * Nombre d'échanges terminés d'un utilisateur.
 * Les documents plant_exchanges ne sont lisibles que par leurs participants,
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

    const snapshot = await admin
      .firestore()
      .collection("plant_exchanges")
      .where("status", "==", "completed")
      .where(
        Filter.or(
          Filter.where("ownerId", "==", uid),
          Filter.where("requestedBy", "==", uid),
        ),
      )
      .count()
      .get();

    return {count: snapshot.data().count};
  },
);
