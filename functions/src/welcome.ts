import {defineSecret, defineString} from "firebase-functions/params";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";
import {FieldValue} from "firebase-admin/firestore";
import {REGION} from "./config";

const BREVO_API_KEY = defineSecret("BREVO_API_KEY");
const BREVO_SENDER_EMAIL = defineString("BREVO_SENDER_EMAIL");
const BREVO_SENDER_NAME = defineString("BREVO_SENDER_NAME");
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
    const fullName = [data?.firstName, data?.lastName]
      .filter((s) => typeof s === "string" && s.trim().length > 0)
      .join(" ");
    const senderName = BREVO_SENDER_NAME.value();

    const response = await fetch("https://api.brevo.com/v3/smtp/email", {
      method: "POST",
      headers: {
        "accept": "application/json",
        "api-key": BREVO_API_KEY.value(),
        "content-type": "application/json",
      },
      body: JSON.stringify({
        sender: {name: senderName, email: BREVO_SENDER_EMAIL.value()},
        to: [{email, name: fullName || email}],
        templateId: Number(BREVO_WELCOME_TEMPLATE_ID.value()),
        params: {
          fullName,
          senderName,
          year: new Date().getFullYear().toString(),
        },
      }),
      signal: AbortSignal.timeout(10_000),
    });

    if (response.status !== 201) {
      console.error(
        `Échec email de bienvenue (${response.status}) : ` +
          await response.text(),
      );
    }
  },
);
