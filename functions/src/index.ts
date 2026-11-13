import {onDocumentCreated} from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";
import {FieldValue} from "firebase-admin/firestore";
import {REGION} from "./config";

admin.initializeApp();

export {generateHandoverCode, validateHandover} from "./handover";
export {deleteAccount} from "./account";
export {notifyPasswordChanged} from "./password";
export {applyReferral, payFirstContact} from "./leaves";
export {getCompletedExchangeCount} from "./stats";
export {sendWelcomeEmail} from "./welcome";
export {assignReferralCode} from "./referral";

export const sendChatNotification = onDocumentCreated(
  {document: "plant_chats/{chatId}/messages/{messageId}", region: REGION},
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      console.log("Aucune donnée associée à l'événement");
      return;
    }

    const messageData = snapshot.data();
    const receiverId = messageData.receiverId;
    const senderId = messageData.senderId;
    const text = messageData.text || "Nouveau message";

    if (!receiverId || !senderId || receiverId === senderId) {
      console.log("Invalid sender/receiver. Skipping.");
      return;
    }

    try {
      const db = admin.firestore();
      const chatDoc = await db
        .collection("plant_chats")
        .doc(event.params.chatId)
        .get();
      const participants: string[] = chatDoc.data()?.participants ?? [];
      if (
        !participants.includes(senderId) ||
        !participants.includes(receiverId)
      ) {
        console.log("Sender or receiver not in chat. Skipping.");
        return;
      }

      const blocked = await db
        .collection("users")
        .doc(receiverId)
        .collection("blocked_users")
        .doc(senderId)
        .get();
      if (blocked.exists) {
        console.log("Receiver blocked sender. Skipping.");
        return;
      }

      const senderDoc = await admin
        .firestore()
        .collection("users")
        .doc(senderId)
        .get();
      const senderData = senderDoc.data();
      const senderName =
        senderData?.userName ||
        senderData?.firstName ||
        "Un utilisateur";

      const messagingRef = db
        .collection("users")
        .doc(receiverId)
        .collection("private")
        .doc("messaging");
      const messagingDoc = await messagingRef.get();
      if (messagingDoc.data()?.notificationsEnabled === false) {
        console.log(`Notifications disabled for: ${receiverId}`);
        return;
      }
      const fcmTokens: string[] = messagingDoc.data()?.fcmTokens || [];

      if (fcmTokens.length === 0) {
        console.log(`No tokens for: ${receiverId}`);
        return;
      }

      const payload: admin.messaging.MulticastMessage = {
        tokens: fcmTokens,
        notification: {
          title: senderName,
          body: text,
        },
        data: {
          chatId: event.params.chatId,
        },
        android: {
          notification: {
            channelId: "high_importance_channel",
            priority: "high",
          },
        },
        apns: {
          payload: {
            aps: {
              sound: "default",
              badge: 1,
            },
          },
        },
      };

      const response = await admin
        .messaging()
        .sendEachForMulticast(payload);
      console.log(`${response.successCount} notification(s) sent.`);

      if (response.failureCount > 0) {
        const tokensToRemove: string[] = [];
        response.responses.forEach((res, index) => {
          if (!res.success && res.error) {
            const code = res.error.code;
            if (
              code === "messaging/invalid-registration-token" ||
              code === "messaging/registration-token-not-registered"
            ) {
              tokensToRemove.push(fcmTokens[index]);
            }
          }
        });

        if (tokensToRemove.length > 0) {
          await messagingRef.set({
            fcmTokens: FieldValue.arrayRemove(...tokensToRemove),
          }, {merge: true});
          console.log(`Cleaned ${tokensToRemove.length} tokens.`);
        }
      }
    } catch (error) {
      console.error("Erreur lors de l'envoi :", error);
    }
  }
);
