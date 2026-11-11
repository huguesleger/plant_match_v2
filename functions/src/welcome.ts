import {defineString} from "firebase-functions/params";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";
import {FieldValue} from "firebase-admin/firestore";
import {BREVO_API_KEY, fullNameOf, sendTemplateEmail} from "./brevo";
import {REGION} from "./config";

const BREVO_WELCOME_TEMPLATE_ID = defineString("BREVO_WELCOME_TEMPLATE_ID");

/**
 * Email de bienvenue envoyé à la création du profil.
 * La clé Brevo reste côté serveur (Secret Manager) au lieu d'être
 * embarquée dans l'app.
 */
export const sendWelcomeEmail = onDocumentCreated(
  {
    document: "users/{uid}",
    region: REGION,
    secrets: [BREVO_API_KEY],
  },
  async (event) => {
    const uid = event.params.uid;
    const data = event.data?.data();
    const authUser = await admin.auth().getUser(uid).catch(() => null);
    const email = authUser?.email;
    const verified = authUser != null && (
      authUser.emailVerified ||
      authUser.providerData.some((p) => p.providerId !== "password")
    );
    if (!email || !verified) {
      console.log(`Email absent ou non vérifié pour ${uid}, envoi ignoré.`);
      return;
    }
    const alreadySent = await admin.firestore()
      .doc(`users/${uid}/private/welcome`)
      .create({sentAt: FieldValue.serverTimestamp()})
      .then(() => false, () => true);
    if (alreadySent) return;
    const fullName = fullNameOf(data);
    await sendTemplateEmail({
      email,
      name: fullName || email,
      templateId: Number(BREVO_WELCOME_TEMPLATE_ID.value()),
      params: {fullName},
    });
  },
);
