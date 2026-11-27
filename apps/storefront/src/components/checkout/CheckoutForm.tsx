'use client';

import { useRouter } from 'next/navigation';
import { useActionState, useState } from 'react';
import { Banknote, Lock, MapPin, ShieldCheck, Wallet } from 'lucide-react';
import { placeOrderAction } from '@/actions/api-shop.actions';
import { emptyActionState } from '@/lib/api/action-state';
import type { ManualPaymentInstructions } from '@/lib/api/endpoints';
import type { Address, CheckoutQuote } from '@/lib/api/types';

type PaymentChoice = 'COD' | 'WALLET' | 'INSTAPAY';

/**
 * The checkout screen.
 *
 * ## It adds nothing up
 *
 * Every amount rendered is the server's own `formatted` string. `grandTotal` is
 * what the customer pays and it arrives computed — including the D-8 delivery
 * fee, which is a function of the SELECTED address's governorate and is
 * therefore re-quoted whenever the choice changes.
 *
 * The three-step wizard this replaces did the opposite. It collected an
 * address into React state, summed line prices held in a browser store,
 * added a shipping fee from a hardcoded client-side rule, and posted the total
 * to a server action. Every one of those numbers was the client's.
 *
 * ## `canPlaceOrder` is the server's decision
 *
 * An empty cart and a delisted line are different reasons for the same disabled
 * button, and the server owns both rules. This component does not try to work
 * out which; it renders the verdict and says what to do about it.
 *
 * ## Changing the address is a NAVIGATION
 *
 * Selecting a different address replaces the URL, which re-runs the page's
 * server component and re-quotes. That is the point: the fee cannot be
 * recomputed client-side, because the client does not have the rate table and
 * must never be trusted with it.
 */
export function CheckoutForm({
  addresses,
  selectedId,
  quote,
  idempotencyKey,
  basePath,
  paymentMethods,
}: {
  addresses: Address[];
  selectedId: string;
  quote: CheckoutQuote;
  /** One key per rendered attempt. The API is the duplicate-submit guard. */
  idempotencyKey: string;
  /** The route this form lives on, so the address radio can re-quote on it. */
  basePath: string;
  /** Which payment methods the owner currently offers (D01). */
  paymentMethods: ManualPaymentInstructions;
}) {
  const router = useRouter();
  const [state, formAction, pending] = useActionState(placeOrderAction, emptyActionState);
  const [paymentChoice, setPaymentChoice] = useState<PaymentChoice>('COD');
  const [transferSender, setTransferSender] = useState('');

  const isManual = paymentChoice !== 'COD';
  const destination =
    paymentChoice === 'WALLET'
      ? paymentMethods.walletNumber
      : paymentChoice === 'INSTAPAY'
        ? paymentMethods.instapayAddress
        : null;
  const senderMissing = isManual && transferSender.trim() === '';

  return (
    <div className="grid gap-8 lg:grid-cols-[1fr_380px]">
      <section className="space-y-6">
        <div>
          <h2 className="flex items-center gap-2 text-[11px] font-black uppercase tracking-[0.2em] text-foreground-muted">
            <MapPin className="h-4 w-4" />
            Deliver to
          </h2>

          <div className="mt-3 space-y-3">
            {addresses.map((address) => (
              <label
                key={address.id}
                className={`flex cursor-pointer items-start gap-3 rounded-sm border p-4 text-sm transition-all ${
                  address.id === selectedId
                    ? 'border-primary bg-primary/5'
                    : 'border-[var(--color-border)] hover:border-primary/40'
                }`}
              >
                <input
                  type="radio"
                  name="addressChoice"
                  className="mt-1"
                  checked={address.id === selectedId}
                  onChange={() => {
                    router.replace(`${basePath}?address=${address.id}`);
                  }}
                />
                <span>
                  <span className="font-black uppercase tracking-wide text-foreground">
                    {address.label}
                  </span>
                  {address.isDefault && (
                    <span className="ml-2 text-[11px] font-bold uppercase tracking-widest text-primary">
                      Default
                    </span>
                  )}
                  <span className="mt-1 block text-foreground-muted">
                    {address.fullName} · {address.phone}
                  </span>
                  <span className="block text-foreground-muted">
                    {address.street}, {address.city}, {address.governorate}
                  </span>
                </span>
              </label>
            ))}
          </div>
        </div>

        <div>
          <h2 className="text-[11px] font-black uppercase tracking-[0.2em] text-foreground-muted">
            Your items
          </h2>
          <ul className="mt-3 divide-y divide-[var(--color-border)] text-sm">
            {quote.items.map((line) => (
              <li key={line.productId} className="flex justify-between gap-4 py-3">
                <span>
                  <span className="font-bold text-foreground">{line.name}</span>
                  <span className="text-foreground-muted"> × {line.effectiveQuantity}</span>
                </span>
                <span className="font-bold">{line.lineTotal.formatted}</span>
              </li>
            ))}
          </ul>
        </div>
      </section>

      <aside className="h-fit rounded-sm border border-[var(--color-border)] bg-white p-6 shadow-sm lg:sticky lg:top-32">
        <h2 className="text-[11px] font-black uppercase tracking-[0.2em] text-foreground-muted">
          Order summary
        </h2>

        <dl className="mt-4 space-y-2 text-sm">
          <Row label="Subtotal" value={quote.pricing.itemsSubtotal.formatted} />
          <Row label="Discount" value={quote.pricing.discountTotal.formatted} />
          {/*
            Reads the server's `shippingPriced` flag, never the amount.

            `shippingFee.amount === 0` is not the same question. A delivery made
            free by the free-shipping threshold is priced AND zero; a delivery
            that has not been worked out yet is also zero. Testing the amount
            tells the second story about the first customer.
          */}
          <Row
            label="Delivery"
            value={
              quote.pricing.shippingPriced
                ? quote.pricing.shippingFee.amount === 0
                  ? 'Free'
                  : quote.pricing.shippingFee.formatted
                : 'Not yet calculated'
            }
            testId="checkout-delivery"
          />
          <div className="flex justify-between border-t border-[var(--color-border)] pt-3 text-base font-black">
            <dt>Total to pay</dt>
            <dd data-testid="checkout-total">{quote.pricing.grandTotal.formatted}</dd>
          </div>
        </dl>

        <form action={formAction} className="mt-6 space-y-4">
          <input type="hidden" name="addressId" value={selectedId} />
          <input type="hidden" name="idempotencyKey" value={idempotencyKey} />
          <input type="hidden" name="paymentMethod" value={paymentChoice} />
          <input type="hidden" name="transferSender" value={transferSender} />

          <fieldset>
            <legend className="mb-1.5 text-[12px] font-bold uppercase tracking-wider text-foreground-muted">
              Payment
            </legend>
            <div className="space-y-2">
              <label className="flex cursor-pointer items-start gap-3 rounded-sm border border-[var(--color-border)] p-3 text-sm">
                <input
                  type="radio"
                  name="paymentChoice"
                  className="mt-1"
                  checked={paymentChoice === 'COD'}
                  onChange={() => setPaymentChoice('COD')}
                />
                <span>
                  <span className="flex items-center gap-1.5 font-bold text-foreground">
                    <Banknote className="h-4 w-4" /> Cash on delivery
                  </span>
                  <span className="block text-foreground-muted">Pay the courier when your order arrives.</span>
                </span>
              </label>

              {paymentMethods.availableMethods.includes('WALLET') && (
                <label className="flex cursor-pointer items-start gap-3 rounded-sm border border-[var(--color-border)] p-3 text-sm">
                  <input
                    type="radio"
                    name="paymentChoice"
                    className="mt-1"
                    checked={paymentChoice === 'WALLET'}
                    onChange={() => setPaymentChoice('WALLET')}
                  />
                  <span>
                    <span className="flex items-center gap-1.5 font-bold text-foreground">
                      <Wallet className="h-4 w-4" /> Mobile wallet transfer
                    </span>
                    <span className="block text-foreground-muted">
                      Transfer the total to {paymentMethods.walletNumber}, then send the screenshot on WhatsApp.
                    </span>
                  </span>
                </label>
              )}

              {paymentMethods.availableMethods.includes('INSTAPAY') && (
                <label className="flex cursor-pointer items-start gap-3 rounded-sm border border-[var(--color-border)] p-3 text-sm">
                  <input
                    type="radio"
                    name="paymentChoice"
                    className="mt-1"
                    checked={paymentChoice === 'INSTAPAY'}
                    onChange={() => setPaymentChoice('INSTAPAY')}
                  />
                  <span>
                    <span className="flex items-center gap-1.5 font-bold text-foreground">
                      <Wallet className="h-4 w-4" /> InstaPay transfer
                    </span>
                    <span className="block text-foreground-muted">
                      Transfer the total to {paymentMethods.instapayAddress}, then send the screenshot on WhatsApp.
                    </span>
                  </span>
                </label>
              )}
            </div>

            {isManual && (
              <div className="mt-3 space-y-3">
                <label className="block text-sm">
                  <span className="mb-1.5 block text-[12px] font-bold uppercase tracking-wider text-foreground-muted">
                    The number / account you will transfer FROM
                  </span>
                  <input
                    value={transferSender}
                    onChange={(event) => setTransferSender(event.target.value)}
                    maxLength={64}
                    className="w-full rounded-xl border border-border bg-surface px-3 py-2.5 text-[15px] focus:border-primary focus:outline-none focus:ring-4 focus:ring-primary/5"
                    placeholder="e.g. 01012345678"
                  />
                </label>
                <p className="text-sm text-foreground-muted">
                  Transfer <strong>{quote.pricing.grandTotal.formatted}</strong> to{' '}
                  <strong>{destination}</strong>. After placing the order, send your order number and
                  the transfer screenshot on WhatsApp
                  {paymentMethods.whatsappNumber !== null && <> ({paymentMethods.whatsappNumber})</>}.
                  Your order is confirmed as paid only after our team verifies the transfer — sending
                  the screenshot alone does not pay the order.
                </p>
              </div>
            )}
          </fieldset>

          <label className="block text-sm">
            <span className="mb-1.5 block text-[12px] font-bold uppercase tracking-wider text-foreground-muted">
              Note for the courier (optional)
            </span>
            <textarea
              name="customerNote"
              rows={2}
              maxLength={500}
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
            disabled={pending || !quote.canPlaceOrder || senderMissing}
            className="flex w-full items-center justify-center gap-2 rounded-xl bg-primary py-4 text-[13px] font-bold uppercase tracking-widest text-white shadow-lg shadow-primary/20 transition-all hover:bg-primary-hover disabled:opacity-50"
          >
            <Lock className="h-4 w-4" />
            {pending ? 'Placing your order…' : 'Place order'}
          </button>

          {!quote.canPlaceOrder && (
            <p className="text-sm font-medium text-amber-700">
              Some items in your cart cannot be ordered. Review your cart first.
            </p>
          )}

          <p className="flex items-center justify-center gap-1.5 text-xs text-foreground-muted">
            <ShieldCheck className="h-3.5 w-3.5" />
            {isManual
              ? 'Manual transfer — verified by our team before it counts as paid.'
              : 'Cash on delivery — nothing is charged now.'}
          </p>
        </form>
      </aside>
    </div>
  );
}

function Row({ label, value, testId }: { label: string; value: string; testId?: string }) {
  return (
    <div className="flex justify-between text-foreground-muted">
      <dt>{label}</dt>
      <dd data-testid={testId}>{value}</dd>
    </div>
  );
}
