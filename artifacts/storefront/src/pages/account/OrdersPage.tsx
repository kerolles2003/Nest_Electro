import { useEffect, useState } from 'react';
import { Link } from 'wouter';
import { Package, AlertTriangle } from 'lucide-react';
import { getSupabaseClient } from '@/lib/supabase';
import { ROUTES } from '@/lib/constants';

const statusLabels: Record<string, string> = {
  pending_payment: 'Pending Payment',
  paid: 'Paid',
  processing: 'Processing',
  shipped: 'Shipped',
  delivered: 'Delivered',
  cancelled: 'Cancelled',
  failed: 'Failed',
};

const statusColors: Record<string, string> = {
  pending_payment: 'bg-amber-50 text-amber-700',
  paid: 'bg-blue-50 text-blue-700',
  processing: 'bg-blue-50 text-blue-700',
  shipped: 'bg-sky-50 text-sky-700',
  delivered: 'bg-green-50 text-green-700',
  cancelled: 'bg-red-50 text-red-600',
  failed: 'bg-red-50 text-red-600',
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
        <div className="h-8 w-40 bg-slate-100 animate-pulse rounded mb-6" />
        {Array.from({ length: 3 }).map((_, i) => <div key={i} className="h-20 bg-slate-100 animate-pulse rounded-md" />)}
      </div>
    );
  }

  if (!isLoggedIn) {
    return (
      <div className="text-center py-16 bg-white border border-slate-200 rounded-md">
        <Package className="w-12 h-12 mx-auto text-slate-300 mb-4" />
        <h2 className="text-lg font-medium text-slate-900">Sign in to view your orders</h2>
        <Link href={ROUTES.login} className="inline-block mt-4 text-sm font-medium text-blue-600 hover:text-blue-700">Sign In</Link>
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-16 bg-white border border-slate-200 rounded-md">
        <AlertTriangle className="w-12 h-12 mx-auto text-red-400 mb-4" />
        <h2 className="text-lg font-medium text-slate-900">Failed to load orders</h2>
        <p className="text-slate-500 mt-1">{error}</p>
      </div>
    );
  }

  if (orders.length === 0) {
    return (
      <div className="text-center py-16 bg-white border border-slate-200 rounded-md">
        <Package className="w-12 h-12 mx-auto text-slate-300 mb-4" />
        <h2 className="text-lg font-medium text-slate-900">No orders yet</h2>
        <p className="text-slate-500 mt-1">Start shopping to see your orders here.</p>
        <Link href={ROUTES.products} className="inline-block mt-4 text-sm font-medium text-blue-600 hover:text-blue-700">Browse Products</Link>
      </div>
    );
  }

  return (
    <div>
      <h2 className="text-2xl font-bold text-slate-900 mb-6">Your Orders</h2>
      <div className="space-y-3">
        {orders.map((order) => {
          const itemCount = Array.isArray(order.items) ? order.items.length : 0;
          const statusLabel = statusLabels[order.order_status] ?? order.order_status;
          const statusClass = statusColors[order.order_status] ?? 'bg-slate-50 text-slate-700';
          return (
            <Link key={order.id} href={ROUTES.account.order(order.id)}>
              <a className="block bg-white border border-slate-200 rounded-md p-4 hover:shadow-sm transition-shadow">
                <div className="flex items-start justify-between mb-2">
                  <div>
                    <p className="text-sm font-semibold text-slate-900">#{order.order_number}</p>
                    <p className="text-xs text-slate-400 mt-0.5">
                      {new Date(order.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}
                    </p>
                  </div>
                  <span className={`inline-flex items-center text-xs font-medium px-2.5 py-1 rounded-full ${statusClass}`}>{statusLabel}</span>
                </div>
                <div className="flex items-center justify-between text-sm pt-2 border-t border-slate-100">
                  <span className="text-slate-500">{itemCount} {itemCount === 1 ? 'item' : 'items'}</span>
                  <span className="font-semibold text-slate-900">EGP {order.total.toFixed(2)}</span>
                </div>
              </a>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
