
import { initializeApp } from "firebase-admin/app";
import {
  FieldValue,
  getFirestore,
} from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import * as logger from "firebase-functions/logger";
import { setGlobalOptions } from "firebase-functions";
import { onSchedule } from "firebase-functions/v2/scheduler";

initializeApp();

setGlobalOptions({ maxInstances: 10 });

const db = getFirestore();
const TIME_ZONE = "Europe/Istanbul";

const DAILY_MESSAGES = [
  "Bugün kendine biraz daha inan. Küçük adımlar da seni ileri taşır. ✨",
  "Her şeyi bugün çözmek zorunda değilsin. Kendine zaman tanı. 🌙",
  "Güzel şeyler bazen beklemediğin anda karşına çıkar. 💜",
  "Bugün kendi yoluna odaklan ve ilerlemeye devam et. 🔮",
  "Kendine gösterdiğin anlayış da bir başarıdır. ✨",
  "Yeni bir gün, yeni bir ihtimal demek. ☀️",
  "Küçük bir ilerleme bile ilerlemedir. Kendini takdir et. 💜",
  "Bugün sana iyi gelen şeylere biraz daha yer aç. 🌷",
  "Her cevap hemen gelmek zorunda değil. Yolculuğa güven. 🌙",
  "Kendin için attığın küçük bir adımın değerini küçümseme. ✨",
  "Bugün her şeyi mükemmel yapmak yerine elinden geleni yap. 💫",
  "Bazen durup nefes almak da ilerlemenin bir parçasıdır. 🌿",
  "İçindeki merakı takip et; yeni şeyler keşfetmeye devam et. 🔮",
  "Kendine karşı nazik olmayı bugün de unutma. 💜",
  "Her yeni gün, farklı bir başlangıç yapma fırsatıdır. ☀️",
];

function getDateKey(date: Date): string {
  const parts = new Intl.DateTimeFormat("en-CA", {
    timeZone: TIME_ZONE,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(date);

  const part = (type: string) =>
    parts.find((item) => item.type === type)?.value ?? "";

  return `${part("year")}-${part("month")}-${part("day")}`;
}

function getDailyMessage(dateKey: string): string {
  const dayNumber = Math.floor(
    Date.parse(`${dateKey}T00:00:00Z`) / 86_400_000,
  );

  return DAILY_MESSAGES[dayNumber % DAILY_MESSAGES.length];
}

export const sendDailyCosmicaMessage = onSchedule(
  {
    schedule: "0 9 * * *",
    timeZone: TIME_ZONE,
    region: "europe-west1",
    timeoutSeconds: 540,
  },
  async () => {
    const dateKey = getDateKey(new Date());
    const runRef = db.collection("system_daily_messages").doc(dateKey);

    const previousRun = await runRef.get();

    if (previousRun.data()?.status === "complete") {
      logger.info(`Günlük mesaj zaten tamamlanmış: ${dateKey}`);
      return;
    }

    const previousMessage = previousRun.data()?.message;
    const message =
      typeof previousMessage === "string"
        ? previousMessage
        : getDailyMessage(dateKey);

    const title = "✨ Cosmica | Günün Mesajı";

    await runRef.set(
      {
        dateKey,
        message,
        status: "processing",
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    const users = await db.collection("users").get();

    let successfulPushes = 0;
    let failedUsers = 0;

    for (const userDoc of users.docs) {
      const userRef = userDoc.ref;

      try {
        await userRef.collection("daily_messages").doc(dateKey).set(
          {
            message,
            dateKey,
            updatedAt: FieldValue.serverTimestamp(),
          },
          { merge: true },
        );

        const notificationRef = userRef
          .collection("notifications")
          .doc(`daily_message_${dateKey}`);

        const existing = await notificationRef.get();

        const notificationData: Record<string, unknown> = {
          title,
          body: message,
          type: "daily_message",
          dateKey,
          updatedAt: FieldValue.serverTimestamp(),
        };

        if (!existing.exists) {
          notificationData.isRead = false;
          notificationData.createdAt = FieldValue.serverTimestamp();
        }

        await notificationRef.set(notificationData, { merge: true });

        const rawTokens: unknown = userDoc.data().fcmTokens;
        const tokens = Array.isArray(rawTokens)
          ? [...new Set(
              rawTokens.filter(
                (token): token is string =>
                  typeof token === "string" && token.length > 0,
              ),
            )]
          : [];

        for (let i = 0; i < tokens.length; i += 500) {
          const batch = tokens.slice(i, i + 500);

          const result = await getMessaging().sendEachForMulticast({
            tokens: batch,
            notification: { title, body: message },
            data: { type: "daily_message", dateKey },
            android: { priority: "high" },
            apns: {
              payload: { aps: { sound: "default" } },
            },
          });

          successfulPushes += result.successCount;

          const invalidTokens: string[] = [];

          result.responses.forEach((response, index) => {
            const code = response.error?.code;

            if (
              code === "messaging/registration-token-not-registered" ||
              code === "messaging/invalid-registration-token"
            ) {
              invalidTokens.push(batch[index]);
            }
          });

          if (invalidTokens.length > 0) {
            await userRef.update({
              fcmTokens: FieldValue.arrayRemove(...invalidTokens),
            });
          }

          if (result.failureCount > 0) {
            logger.warn(`Bazı bildirimler gönderilemedi: ${userDoc.id}`);
          }
        }
      } catch (error) {
        failedUsers++;
        logger.error(`Kullanıcı işlenemedi: ${userDoc.id}`, error);
      }
    }

    await runRef.set(
      {
        status: failedUsers === 0 ? "complete" : "completed_with_errors",
        usersProcessed: users.size,
        successfulPushes,
        failedUsers,
        completedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    logger.info(
      `Cosmica günlük mesajı: ${dateKey}; başarılı bildirim: ${successfulPushes}; hatalı kullanıcı: ${failedUsers}`,
    );

    if (failedUsers > 0) {
      throw new Error(`${failedUsers} kullanıcı işlenemedi.`);
    }
  },
);
