import { useEffect, useState } from 'react';
import { Link } from 'wouter';
import { Package, AlertTriangle } from 'lucide-react';
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

export default function OrdersPage() {
  const [orders, setOrders] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  useEffect(() => {
    const load = async () => {
      try {
        const supabase = getSupabaseClient();
        const { data: { session } } = await supabase.auth.getSession();
        if (!session?.user) { setLoading(false); return; }
        setIsLoggedIn(true);
        const { data: orderData, error: ordErr } = await supabase
          .from('orders')
          .select('*, items:order_items(*)')
          .eq('user_id', session.user.id)
          .order('created_at', { ascending: false });
        if (ordErr) throw ordErr;
        setOrders(orderData ?? []);
      } catch (e: any) {
        setError(e.message ?? 'Failed to load orders');
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  if (loading) {
    return (
      <div className="space-y-3">
        <div className="h-8 w-40 bg-[#f2f2f2] animate-pulse rounded mb-6" />
        {Array.from({ length: 3 }).map((_, i) => (
          <div key={i} className="h-20 bg-[#f2f2f2] animate-pulse rounded-md" />
        ))}
      </div>
    );
  }

  if (!isLoggedIn) {
    return (
      <div className="text-center py-16 bg-white border border-[#e8e8e8] rounded-lg">
        <div className="w-16 h-16 rounded-full bg-[#fde8ea] flex items-center justify-center mx-auto mb-4">
          <Package className="w-8 h-8 text-[#E14A5C]/40" />
        </div>
        <h2 className="font-heading font-semibold text-lg text-[#0D0625]">Sign in to view your orders</h2>
        <Link href={ROUTES.login} className="inline-block mt-4 text-sm font-semibold text-[#E14A5C] hover:underline">Sign In</Link>
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-16 bg-white border border-[#e8e8e8] rounded-lg">
        <AlertTriangle className="w-12 h-12 mx-auto text-red-400 mb-4" />
        <h2 className="font-heading font-semibold text-lg text-[#0D0625]">Failed to load orders</h2>
        <p className="text-[#777] mt-1 text-sm">{error}</p>
      </div>
    );
  }

  if (orders.length === 0) {
    return (
      <div className="text-center py-16 bg-white border border-[#e8e8e8] rounded-lg">
        <div className="w-16 h-16 rounded-full bg-[#fde8ea] flex items-center justify-center mx-auto mb-4">
          <Package className="w-8 h-8 text-[#E14A5C]/40" />
        </div>
        <h2 className="font-heading font-semibold text-lg text-[#0D0625]">No orders yet</h2>
        <p className="text-[#777] mt-1 text-sm">Start shopping to see your orders here.</p>
        <Link href={ROUTES.products} className="inline-block mt-4 text-sm font-semibold text-[#E14A5C] hover:underline">Browse Products</Link>
      </div>
    );
  }

  return (
    <div>
      <h2 className="font-heading font-bold text-xl text-[#0D0625] mb-5">Your Orders</h2>
      <div className="space-y-3">
        {orders.map((order) => {
          const itemCount = Array.isArray(order.items) ? order.items.length : 0;
          const statusLabel = statusLabels[order.order_status] ?? order.order_status;
          const statusClass = statusColors[order.order_status] ?? 'bg-[#f8f8f8] text-[#555]';
          return (
            <Link key={order.id} href={ROUTES.account.order(order.id)}>
              <a className="block bg-white border border-[#e8e8e8] rounded-md p-4 hover:border-[#E14A5C]/30 hover:shadow-sm transition-all">
                <div className="flex items-start justify-between mb-2">
                  <div>
                    <p className="text-sm font-semibold text-[#0D0625]">#{order.order_number}</p>
                    <p className="text-xs text-[#aaa] mt-0.5">
                      {new Date(order.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}
                    </p>
                  </div>
                  <span className={`inline-flex items-center text-xs font-semibold px-2.5 py-1 rounded-full ${statusClass}`}>
                    {statusLabel}
                  </span>
                </div>
                <div className="flex items-center justify-between text-sm pt-2 border-t border-[#f5f5f5]">
                  <span className="text-[#999]">{itemCount} {itemCount === 1 ? 'item' : 'items'}</span>
                  <span className="font-bold text-[#0D0625]">EGP {order.total.toFixed(2)}</span>
                </div>
              </a>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
