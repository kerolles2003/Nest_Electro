'use client';

import { useActionState, useState } from 'react';
import { MessageCircle } from 'lucide-react';
import { resubmitPaymentAction } from '@/actions/api-account.actions';
import { emptyActionState } from '@/lib/api/action-state';
import type { Order } from '@/lib/api/types';

/**
 * The customer's side of manual payment verification (D01/D03/D16).
 *
 * Shows where the transfer stands, where to send evidence, and — after a
 * rejection — the reason and a resubmission form. It can never mark the
 * order paid: approval is an authorized admin decision on the API, and
 * this panel only ever displays the state the API reports.
 */
export function ManualPaymentPanel({
  order,
  destination,
  whatsappNumber,
}: {
  order: Order;
  destination: string | null;
  whatsappNumber: string | null;
}) {
  const [state, formAction, pending] = useActionState(resubmitPaymentAction, emptyActionState);
  const [sender, setSender] = useState('');
  const payment = order.payment;

  if (payment.method === 'COD') return null;

  const whatsappText = encodeURIComponent(
    `Hello, I transferred ${order.pricing.grandTotal.formatted} for order ${order.orderNumber}. My transfer screenshot is attached.`,
  );
  const whatsappHref =
    whatsappNumber !== null ? `https://wa.me/${whatsappNumber.replace(/\D/g, '')}?text=${whatsappText}` : null;

  return (
    <section className="rounded-sm border border-[var(--color-border)] bg-surface/40 p-5">
      <h3 className="text-[11px] font-black uppercase tracking-[0.2em] text-foreground-muted">
        Transfer verification
      </h3>

      {payment.status === 'PENDING_VERIFICATION' && (
        <div className="mt-2 space-y-2 text-sm text-foreground-muted">
          <p>
            We are waiting to verify your transfer of{' '}
            <strong className="text-foreground">{order.pricing.grandTotal.formatted}</strong>
            {destination !== null && (
              <>
                {' '}to <strong className="text-foreground">{destination}</strong>
              </>
            )}
            {payment.verification?.transferSender != null && (
              <> from {payment.verification.transferSender}</>
            )}
            . Your order counts as paid only after our team confirms the transfer.
          </p>
          {whatsappHref !== null && (
            <a
              href={whatsappHref}
              target="_blank"
              rel="noreferrer"
              className="inline-flex items-center gap-2 font-bold text-primary hover:underline"
            >
              <MessageCircle className="h-4 w-4" />
              Send the transfer screenshot on WhatsApp
            </a>
          )}
        </div>
      )}

      {payment.status === 'VERIFICATION_REJECTED' && (
        <div className="mt-2 space-y-3 text-sm text-foreground-muted">
          <p role="alert" className="font-medium text-danger">
            Your transfer could not be verified
            {payment.verification?.decisionNote != null && <>: {payment.verification.decisionNote}</>}
          </p>
          <p>
            If you transferred again (or from a different account), tell us the new sender below and
            send the new screenshot on WhatsApp. Your order will be reviewed again.
          </p>
          <form action={formAction} className="space-y-3">
            <input type="hidden" name="orderId" value={order.id} />
            <label className="block">
              <span className="mb-1.5 block text-[12px] font-bold uppercase tracking-wider text-foreground-muted">
                The number / account you transferred FROM
              </span>
              <input
                name="transferSender"
                value={sender}
                onChange={(event) => setSender(event.target.value)}
                maxLength={64}
                className="w-full rounded-xl border border-border bg-surface px-3 py-2.5 text-[15px] focus:border-primary focus:outline-none focus:ring-4 focus:ring-primary/5"
              />
            </label>
            {state.error !== null && (
              <p role="alert" className="text-sm font-medium text-danger">
                {state.error}
              </p>
            )}
            <button
              type="submit"
              disabled={pending || sender.trim() === ''}
              className="rounded-xl bg-primary px-5 py-3 text-[13px] font-bold uppercase tracking-widest text-white transition-all hover:bg-primary-hover disabled:opacity-50"
            >
              {pending ? 'Sending…' : 'Resubmit for verification'}
            </button>
          </form>
        </div>
      )}

      {payment.status === 'PAID' && (
        <p className="mt-2 text-sm text-foreground-muted">
          Your transfer was verified and this order is paid. Thank you.
        </p>
      )}
    </section>
  );
}
