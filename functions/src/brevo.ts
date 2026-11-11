import {defineSecret, defineString} from "firebase-functions/params";

export const BREVO_API_KEY = defineSecret("BREVO_API_KEY");
const BREVO_SENDER_EMAIL = defineString("BREVO_SENDER_EMAIL");
const BREVO_SENDER_NAME = defineString("BREVO_SENDER_NAME");

export interface TemplateEmail {
  email: string;
  name: string;
  templateId: number;
  params: Record<string, string>;
}

export const senderName = (): string => BREVO_SENDER_NAME.value();

export const sendTemplateEmail = async (
  mail: TemplateEmail,
): Promise<boolean> => {
  const response = await fetch("https://api.brevo.com/v3/smtp/email", {
    method: "POST",
    headers: {
      "accept": "application/json",
      "api-key": BREVO_API_KEY.value(),
      "content-type": "application/json",
    },
    body: JSON.stringify({
      sender: {name: senderName(), email: BREVO_SENDER_EMAIL.value()},
      to: [{email: mail.email, name: mail.name}],
      templateId: mail.templateId,
      params: {
        ...mail.params,
        senderName: senderName(),
        year: new Date().getFullYear().toString(),
      },
    }),
    signal: AbortSignal.timeout(10_000),
  });
  if (response.status !== 201) {
    console.error(
      `Échec email Brevo ${mail.templateId} (${response.status}) : ` +
        await response.text(),
    );
  }
  return response.status === 201;
};

export const fullNameOf = (data: Record<string, unknown> | undefined) =>
  [data?.firstName, data?.lastName]
    .filter((s): s is string => typeof s === "string" && s.trim().length > 0)
    .join(" ");
