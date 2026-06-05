import {onDocumentCreated} from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendChatNotification = onDocumentCreated(
  "plant_chats/{chatId}/messages/{messageId}",
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

    if (receiverId === senderId) {
      console.log("Sender and receiver are identical. Skipping.");
      return;
    }

    try {
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

      const receiverDoc = await admin
        .firestore()
        .collection("users")
        .doc(receiverId)
        .get();
      const receiverData = receiverDoc.data();
      const fcmTokens: string[] = receiverData?.fcmTokens || [];

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
          await admin
            .firestore()
            .collection("users")
            .doc(receiverId)
            .update({
              fcmTokens: admin.firestore.FieldValue.arrayRemove(
                ...tokensToRemove
              ),
            });
          console.log(`Cleaned ${tokensToRemove.length} tokens.`);
        }
      }
    } catch (error) {
      console.error("Erreur lors de l'envoi :", error);
    }
  }
);
