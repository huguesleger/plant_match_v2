import * as admin from "firebase-admin";
import {defineString} from "firebase-functions/params";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {BREVO_API_KEY, fullNameOf, sendTemplateEmail} from "./brevo";
import {REGION} from "./config";

const BREVO_PASSWORD_CHANGED_TEMPLATE_ID =
  defineString("BREVO_PASSWORD_CHANGED_TEMPLATE_ID");

const RECENT_CHANGE_MS = 5 * 60 * 1000;

const formatParisDate = (date: Date): string =>
  date.toLocaleString("fr-FR", {
    timeZone: "Europe/Paris",
    dateStyle: "long",
    timeStyle: "short",
  });

export const notifyPasswordChanged = onCall(
  {region: REGION, secrets: [BREVO_API_KEY]},
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
      throw new HttpsError("unauthenticated", "Connexion requise");
    }
    const user = await admin.auth().getUser(uid);
    const changedAt = new Date(user.tokensValidAfterTime ?? 0);
    const isRecent = Date.now() - changedAt.getTime() < RECENT_CHANGE_MS;
    if (!user.email || !isRecent) {
      return {sent: false};
    }

    const db = admin.firestore();
    const userRef = db.collection("users").doc(uid);
    const noticeRef = userRef.collection("private").doc("passwordNotice");
    const firstNotice = await db.runTransaction(async (tx) => {
      const notice = await tx.get(noticeRef);
      if (notice.get("tokensValidAfterTime") === user.tokensValidAfterTime) {
        return false;
      }
      tx.set(noticeRef, {tokensValidAfterTime: user.tokensValidAfterTime});
      return true;
    });
    if (!firstNotice) {
      return {sent: false};
    }

    const fullName = fullNameOf((await userRef.get()).data());
    const sent = await sendTemplateEmail({
      email: user.email,
      name: fullName || user.email,
      templateId: Number(BREVO_PASSWORD_CHANGED_TEMPLATE_ID.value()),
      params: {
        fullName,
        changedAt: formatParisDate(changedAt),
        resetLink: await admin.auth().generatePasswordResetLink(user.email),
      },
    });
    return {sent};
  },
);
