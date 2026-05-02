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
  pending_payment: 'bg-amber-50 text-amber-700',
  paid:            'bg-[#fde8ea] text-[#E14A5C]',
  processing:      'bg-[#fde8ea] text-[#E14A5C]',
  shipped:         'bg-sky-50 text-sky-700',
  delivered:       'bg-green-50 text-green-700',
  cancelled:       'bg-red-50 text-red-600',
  failed:          'bg-red-50 text-red-600',
};
const timelineDotColors: Record<string, string> = {
  pending_payment: 'bg-amber-400', paid: 'bg-[#E14A5C]', processing: 'bg-[#E14A5C]',
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
      <div className="h-4 bg-[#f2f2f2] rounded w-32" />
      <div className="h-8 bg-[#f2f2f2] rounded w-48" />
      <div className="h-32 bg-[#f2f2f2] rounded-md" />
      <div className="h-32 bg-[#f2f2f2] rounded-md" />
    </div>
  );

  if (notFound || !order) return (
    <div className="text-center py-16 bg-white border border-[#e8e8e8] rounded-lg">
      <div className="w-16 h-16 rounded-full bg-[#fde8ea] flex items-center justify-center mx-auto mb-4">
        <Package className="w-8 h-8 text-[#E14A5C]/40" />
      </div>
      <h2 className="font-heading font-semibold text-lg text-[#0D0625]">Order not found</h2>
      <Link href={ROUTES.account.orders} className="mt-4 inline-block text-sm font-semibold text-[#E14A5C] hover:underline">Back to Orders</Link>
    </div>
  );

  const statusHistory = Array.isArray(order.status_history)
    ? [...order.status_history].sort((a: any, b: any) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
    : [];

  const statusLabel = statusLabels[order.order_status] ?? order.order_status;
  const statusClass = statusColors[order.order_status] ?? 'bg-[#f8f8f8] text-[#555]';

  return (
    <div className="space-y-5">
      <Link href={ROUTES.account.orders}>
        <a className="inline-flex items-center gap-1.5 text-sm text-[#999] hover:text-[#E14A5C] transition-colors">
          <ArrowLeft className="w-4 h-4" /> Back to Orders
        </a>
      </Link>

      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
        <div>
          <h2 className="font-heading font-bold text-xl text-[#0D0625]">Order #{order.order_number}</h2>
          <p className="text-sm text-[#aaa] mt-1">
            Placed on {new Date(order.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}
          </p>
        </div>
        <span className={`inline-flex items-center text-sm font-semibold px-3 py-1 rounded-full self-start sm:self-center ${statusClass}`}>
          {statusLabel}
        </span>
      </div>

      {statusHistory.length > 0 && (
        <div className="bg-white border border-[#e8e8e8] rounded-lg p-6">
          <h3 className="font-semibold text-[#0D0625] mb-4">Status Timeline</h3>
          <div className="space-y-4">
            {statusHistory.map((entry: any, index: number) => (
              <div key={entry.id} className="flex gap-3">
                <div className="flex flex-col items-center">
                  <div className={`w-2.5 h-2.5 rounded-full mt-1.5 ${timelineDotColors[entry.to_value] ?? 'bg-[#ccc]'}`} />
                  {index < statusHistory.length - 1 && <div className="w-0.5 flex-1 bg-[#f0f0f0] mt-1" />}
                </div>
                <div>
                  <p className="text-sm font-medium text-[#0D0625] capitalize">{entry.to_value.replace(/_/g, ' ')}</p>
                  <p className="text-xs text-[#aaa] mt-0.5">
                    {new Date(entry.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })} at {new Date(entry.created_at).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}
                  </p>
                  {entry.notes && <p className="text-xs text-[#999] mt-0.5">{entry.notes}</p>}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="bg-white border border-[#e8e8e8] rounded-lg p-6">
        <h3 className="font-semibold text-[#0D0625] mb-4">Items</h3>
        <div className="space-y-0 divide-y divide-[#f5f5f5]">
          {Array.isArray(order.items) && order.items.map((item: any) => (
            <div key={item.id} className="flex items-center justify-between py-3">
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-[#0D0625] truncate">{item.name}</p>
                <p className="text-xs text-[#aaa] mt-0.5">{item.sku} · Qty: {item.quantity}</p>
              </div>
              <div className="text-right ml-4">
                <p className="text-sm font-bold text-[#0D0625]">EGP {item.total.toFixed(2)}</p>
                <p className="text-xs text-[#aaa]">EGP {item.price.toFixed(2)} each</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        <div className="bg-white border border-[#e8e8e8] rounded-lg p-6">
          <h3 className="font-semibold text-[#0D0625] mb-3">Shipping Address</h3>
          {order.shipping_address ? (
            <div className="text-sm space-y-1">
              <p className="font-medium text-[#0D0625]">{order.shipping_address.full_name}</p>
              <p className="text-[#777]">{order.shipping_address.phone}</p>
              <p className="text-[#777]">{order.shipping_address.street}</p>
              <p className="text-[#777]">{order.shipping_address.city}, {order.shipping_address.governorate}</p>
              {order.shipping_address.postal_code && <p className="text-[#777]">{order.shipping_address.postal_code}</p>}
            </div>
          ) : (
            <p className="text-sm text-[#aaa]">No shipping address available.</p>
          )}
        </div>

        <div className="bg-white border border-[#e8e8e8] rounded-lg p-6">
          <h3 className="font-semibold text-[#0D0625] mb-3">Order Summary</h3>
          <div className="space-y-2 text-sm">
            <div className="flex justify-between"><span className="text-[#777]">Subtotal</span><span className="text-[#0D0625]">EGP {order.subtotal?.toFixed(2)}</span></div>
            {order.discount > 0 && <div className="flex justify-between"><span className="text-[#777]">Discount</span><span className="text-green-600">-EGP {order.discount.toFixed(2)}</span></div>}
            <div className="flex justify-between"><span className="text-[#777]">Shipping</span><span className="text-[#0D0625]">EGP {order.shipping_fee?.toFixed(2)}</span></div>
            {order.tax > 0 && <div className="flex justify-between"><span className="text-[#777]">Tax</span><span className="text-[#0D0625]">EGP {order.tax.toFixed(2)}</span></div>}
            <div className="flex justify-between border-t border-[#f0f0f0] pt-3 font-bold text-base">
              <span className="text-[#0D0625]">Total</span>
              <span className="text-[#E14A5C]">EGP {order.total?.toFixed(2)}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
