import { useEffect, useState } from 'react';
import { useParams, Link } from 'wouter';
import { ArrowLeft, Package } from 'lucide-react';
import { getSupabaseClient } from '@/lib/supabase';
import { ROUTES } from '@/lib/constants';

const statusLabels: Record<string, string> = {
  pending_payment: 'Pending Payment', paid: 'Paid', processing: 'Processing',
  shipped: 'Shipped', delivered: 'Delivered', cancelled: 'Cancelled', failed: 'Failed',
};
const statusColors: Record<string, string> = {
  pending_payment: 'bg-amber-50 text-amber-700', paid: 'bg-blue-50 text-blue-700',
  processing: 'bg-blue-50 text-blue-700', shipped: 'bg-sky-50 text-sky-700',
  delivered: 'bg-green-50 text-green-700', cancelled: 'bg-red-50 text-red-600', failed: 'bg-red-50 text-red-600',
};
const timelineDotColors: Record<string, string> = {
  pending_payment: 'bg-amber-400', paid: 'bg-blue-400', processing: 'bg-blue-400',
  shipped: 'bg-sky-400', delivered: 'bg-green-500', cancelled: 'bg-red-400', failed: 'bg-red-400',
};

export default function OrderDetailPage() {
  const { id } = useParams<{ id: string }>();
  const [order, setOrder] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [notFound, setNotFound] = useState(false);

  useEffect(() => {
    if (!id) return;
    const load = async () => {
      const supabase = getSupabaseClient();
      const { data: { session } } = await supabase.auth.getSession();
      if (!session?.user) { setNotFound(true); setLoading(false); return; }
      const { data } = await supabase
        .from('orders')
        .select('*, items:order_items(*), status_history:order_status_history(*)')
        .eq('id', id)
        .eq('user_id', session.user.id)
        .single();
      if (!data) { setNotFound(true); } else { setOrder(data); }
      setLoading(false);
    };
    load();
  }, [id]);

  if (loading) return (
    <div className="space-y-4 animate-pulse">
      <div className="h-4 bg-slate-100 rounded w-32" />
      <div className="h-8 bg-slate-100 rounded w-48" />
      <div className="h-32 bg-slate-100 rounded-md" />
      <div className="h-32 bg-slate-100 rounded-md" />
    </div>
  );

  if (notFound || !order) return (
    <div className="text-center py-16 bg-white border border-slate-200 rounded-md">
      <Package className="w-12 h-12 mx-auto text-slate-300 mb-4" />
      <h2 className="text-lg font-medium text-slate-900">Order not found</h2>
      <Link href={ROUTES.account.orders} className="mt-4 inline-block text-sm text-blue-600 hover:underline">Back to Orders</Link>
    </div>
  );

  const statusHistory = Array.isArray(order.status_history)
    ? [...order.status_history].sort((a: any, b: any) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
    : [];

  const statusLabel = statusLabels[order.order_status] ?? order.order_status;
  const statusClass = statusColors[order.order_status] ?? 'bg-slate-50 text-slate-700';

  return (
    <div className="space-y-6">
      <Link href={ROUTES.account.orders}>
        <a className="inline-flex items-center gap-1.5 text-sm text-slate-400 hover:text-blue-600 transition-colors">
          <ArrowLeft className="w-4 h-4" /> Back to Orders
        </a>
      </Link>

      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
        <div>
          <h2 className="text-2xl font-bold text-slate-900">Order #{order.order_number}</h2>
          <p className="text-sm text-slate-400 mt-1">
            Placed on {new Date(order.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}
          </p>
        </div>
        <span className={`inline-flex items-center text-sm font-medium px-3 py-1 rounded-full self-start sm:self-center ${statusClass}`}>{statusLabel}</span>
      </div>

      {statusHistory.length > 0 && (
        <div className="bg-white border border-slate-200 rounded-md p-6">
          <h3 className="font-semibold text-slate-900 mb-4">Status Timeline</h3>
          <div className="space-y-4">
            {statusHistory.map((entry: any, index: number) => (
              <div key={entry.id} className="flex gap-3">
                <div className="flex flex-col items-center">
                  <div className={`w-2.5 h-2.5 rounded-full mt-1.5 ${timelineDotColors[entry.to_value] ?? 'bg-slate-300'}`} />
                  {index < statusHistory.length - 1 && <div className="w-0.5 flex-1 bg-slate-200 mt-1" />}
                </div>
                <div>
                  <p className="text-sm font-medium text-slate-700 capitalize">{entry.to_value.replace(/_/g, ' ')}</p>
                  <p className="text-xs text-slate-400 mt-0.5">
                    {new Date(entry.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })} at {new Date(entry.created_at).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}
                  </p>
                  {entry.notes && <p className="text-xs text-slate-400 mt-0.5">{entry.notes}</p>}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="bg-white border border-slate-200 rounded-md p-6">
        <h3 className="font-semibold text-slate-900 mb-4">Items</h3>
        <div className="space-y-3">
          {Array.isArray(order.items) && order.items.map((item: any) => (
            <div key={item.id} className="flex items-center justify-between py-3 border-b border-slate-100 last:border-0">
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-slate-900 truncate">{item.name}</p>
                <p className="text-xs text-slate-400 mt-0.5">{item.sku} &middot; Qty: {item.quantity}</p>
              </div>
              <div className="text-right ml-4">
                <p className="text-sm font-semibold text-slate-900">EGP {item.total.toFixed(2)}</p>
                <p className="text-xs text-slate-400">EGP {item.price.toFixed(2)} each</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-white border border-slate-200 rounded-md p-6">
          <h3 className="font-semibold text-slate-900 mb-3">Shipping Address</h3>
          {order.shipping_address ? (
            <div className="text-sm space-y-1">
              <p className="font-medium text-slate-900">{order.shipping_address.full_name}</p>
              <p className="text-slate-500">{order.shipping_address.phone}</p>
              <p className="text-slate-500">{order.shipping_address.street}</p>
              <p className="text-slate-500">{order.shipping_address.city}, {order.shipping_address.governorate}</p>
              {order.shipping_address.postal_code && <p className="text-slate-500">{order.shipping_address.postal_code}</p>}
            </div>
          ) : (
            <p className="text-sm text-slate-400">No shipping address available.</p>
          )}
        </div>

        <div className="bg-white border border-slate-200 rounded-md p-6">
          <h3 className="font-semibold text-slate-900 mb-3">Order Summary</h3>
          <div className="space-y-2 text-sm">
            <div className="flex justify-between"><span className="text-slate-500">Subtotal</span><span>EGP {order.subtotal?.toFixed(2)}</span></div>
            {order.discount > 0 && <div className="flex justify-between"><span className="text-slate-500">Discount</span><span className="text-green-600">-EGP {order.discount.toFixed(2)}</span></div>}
            <div className="flex justify-between"><span className="text-slate-500">Shipping</span><span>EGP {order.shipping_fee?.toFixed(2)}</span></div>
            {order.tax > 0 && <div className="flex justify-between"><span className="text-slate-500">Tax</span><span>EGP {order.tax.toFixed(2)}</span></div>}
            <div className="flex justify-between border-t border-slate-200 pt-3 font-semibold text-base text-slate-900">
              <span>Total</span>
              <span>EGP {order.total?.toFixed(2)}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
