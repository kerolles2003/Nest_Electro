import { PageHeader, ErrorState } from '@/components/ui/admin';
import { notFound } from 'next/navigation';
import Link from 'next/link';
import { ArrowLeft, } from 'lucide-react';
import { tryApi } from '@/lib/api/client';
import * as api from '@/lib/api/endpoints';
import { readIdentity, requireAdmin } from '@/lib/api/identity';
import OrderDetail from '@/components/orders/OrderDetail';

/**
 * One order, as staff see it.
 *
 * Reads `GET /admin/orders/{id}`, which returns the canonical order plus the
 * two things only an operator needs: `allowedTransitions` and `statusHistory`.
 *
 * **No `adminId` is passed down.** The old page handed `admin.user.id` to
 * `OrderDetail` so it could send it back up with every mutation. The API
 * derives the operator from the token and records it itself, so there is
 * nothing to pass and nothing for a client to forge.
 *
 * The viewer's EMAIL is passed, for display only: it drives the
 * segregation-of-duties hint on the payment panel ("you placed this
 * order — another administrator must decide"). It is never sent back to
 * the API and grants nothing; the API enforces the rule by account id.
 */

export const dynamic = 'force-dynamic';

export default async function OrderDetailPage(props: { params: Promise<{ id: string }> }) {
  await requireAdmin();
  const identity = await readIdentity();
  const viewerEmail = identity.status === 'ok' ? identity.identity.email : undefined;

  const { id } = await props.params;
  const result = await tryApi(() => api.getOrder(id));

  if (!result.ok) {
    // A missing order is a 404 page. Anything else is a failure to READ, which
    // must not be rendered as an absence — "this order does not exist" and "I
    // could not ask" are different facts and only one of them is about the
    // order.
    if (result.error.kind === 'not-found') notFound();

    return (
      <div className="space-y-5">
        <BackLink />
        <ErrorState title="This order could not be loaded" description={<>{result.error.message}</>} />
      </div>
    );
  }

  const order = result.data.data;

  return (
    <div className="space-y-5">
      <PageHeader context={<BackLink />} title={<span data-testid="order-number">{order.orderNumber}</span>} description="Order details, fulfilment and customer information." />

      <OrderDetail order={order} viewerEmail={viewerEmail} />
    </div>
  );
}

function BackLink() {
  return (
    <Link
      href="/orders"
      className="inline-flex items-center gap-1.5 rounded-lg border border-border bg-card px-3 py-2 text-xs font-semibold text-muted-foreground hover:bg-muted hover:text-foreground transition-all"
    >
      <ArrowLeft className="h-3.5 w-3.5" />
      Back to Orders
    </Link>
  );
}
