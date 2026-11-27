import { registerAs } from '@nestjs/config';
import type { ConfigType } from '@nestjs/config';
import { env } from './env.schema';

/**
 * Manual payment configuration (owner decisions D01, D03, D16).
 *
 * COD needs no configuration. Wallet and InstaPay are offered only when the
 * owner has supplied the corresponding receiving detail; the WhatsApp
 * destination is where customers send transfer evidence. All values come
 * from the environment because they are business inputs owned by the
 * operator, not catalogue data — and none is ever defaulted or invented.
 */
export const paymentsConfig = registerAs('payments', () => {
  const e = env();

  return {
    walletNumber: e.MANUAL_PAYMENT_WALLET_NUMBER ?? null,
    instapayAddress: e.MANUAL_PAYMENT_INSTAPAY_ADDRESS ?? null,
    whatsappNumber: e.MANUAL_PAYMENT_WHATSAPP_NUMBER ?? null,
  } as const;
});

export type PaymentsConfig = ConfigType<typeof paymentsConfig>;
