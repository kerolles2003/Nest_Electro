import Link from "next/link";
import { Suspense } from "react";
import {
  Package,
  ShoppingBag,
  AlertTriangle,
  Clock,
  ArrowUpRight,
  CheckCircle2,
  Banknote,
  Warehouse,
} from "lucide-react";
import { Button } from "@nest/ui";
import { StatusBadge } from "@/components/ui/status-badge";
import {
  PageHeader,
  SectionHeader,
  AdminCard,
  StatCard,
  TableScroll,
  ChartContainer,
  ActivityItem,
  EmptyState,
  ErrorState,
  LoadingState,
} from "@/components/ui/admin";
import { requireAdmin, getDashboardStats } from "@/lib/services";
import { tryApi } from "@/lib/api/client";
import * as api from "@/lib/api/endpoints";
import { orderStatusCounts, ORDER_STATUSES } from "@/lib/api/order-stats";
import { DASHBOARD_WINDOWS, type DashboardWindowKey } from "@/lib/api/types";

const WINDOW_LABELS: Record<DashboardWindowKey, string> = {
  "30d": "30 days",
  "90d": "90 days",
  all: "All time",
};
function requestedWindow(
  raw: string | string[] | undefined,
): DashboardWindowKey | undefined {
  const value = Array.isArray(raw) ? raw[0] : raw;
  return DASHBOARD_WINDOWS.includes(value as DashboardWindowKey)
    ? (value as DashboardWindowKey)
    : undefined;
}
function getGreeting() {
  const hour = new Date().getHours();
  return hour < 12
    ? "Good morning"
    : hour < 17
      ? "Good afternoon"
      : "Good evening";
}
function formatRelativeTime(value: string) {
  const date = new Date(value);
  const mins = Math.floor((Date.now() - date.getTime()) / 60000);
  if (mins < 1) return "Just now";
  if (mins < 60) return `${mins}m ago`;
  if (mins < 1440) return `${Math.floor(mins / 60)}h ago`;
  return date.toLocaleDateString("en-US", { month: "short", day: "numeric" });
}
function WindowPicker({ active }: { active: DashboardWindowKey | null }) {
  return (
    <div className="space-y-2">
      <nav
        aria-label="Revenue period"
        className="inline-flex flex-wrap gap-1 rounded-lg border border-border bg-card p-1"
      >
        {DASHBOARD_WINDOWS.map((key) => (
          <Link
            key={key}
            href={`/?window=${key}`}
            aria-current={key === active ? "true" : undefined}
            className={`rounded-md px-3 py-2 text-xs ${key === active ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:bg-muted"}`}
          >
            {WINDOW_LABELS[key]}
          </Link>
        ))}
      </nav>
      <p className="text-xs text-muted-foreground">
        Applies to revenue only. The queue counts are live and unbounded.
      </p>
    </div>
  );
}
async function ActivityFeed() {
  const result = await tryApi(() => api.listAuditLogs({ limit: 8 }));
  return (
    <AdminCard>
      <SectionHeader
        title="Recent activity"
        description="The people and actions behind your store."
        action={
          <Link href="/audit-log" className="admin-link">
            Audit log <ArrowUpRight size={14} />
          </Link>
        }
      />
      {!result.ok ? (
        <ErrorState
          title="Activity could not be loaded"
          description={result.error.message}
        />
      ) : result.data.data.length === 0 ? (
        <EmptyState
          title="No recent activity"
          description="Administrative actions will appear here as your team works."
        />
      ) : (
        <ol className="admin-activity-list">
          {result.data.data.map((entry) => (
            <ActivityItem
              key={entry.id}
              title={
                entry.action.charAt(0) +
                entry.action.slice(1).toLowerCase().replace(/_/g, " ")
              }
              description={
                <>
                  {entry.entity.label} · {entry.actor.name}
                </>
              }
              time={formatRelativeTime(entry.createdAt)}
            />
          ))}
        </ol>
      )}
    </AdminCard>
  );
}

export default async function AdminPage(props: {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  const identity = await requireAdmin();
  const sp = await props.searchParams;
  const window = requestedWindow(sp["window"]);
  // Preserve the existing request boundaries and server-owned money formatting.
  const [stats, orderCounts, recentOrders] = await Promise.all([
    getDashboardStats(window),
    orderStatusCounts(),
    tryApi(() => api.listOrders({ limit: 8 })),
  ]);
  const show = (value: number | null | undefined) =>
    value == null ? "—" : value.toLocaleString("en-EG");
  const placed = orderCounts.counts["PLACED"];
  const ready = orderCounts.counts["CONFIRMED"];
  const failed = orderCounts.counts["DELIVERY_FAILED"];
  const peak = Math.max(
    1,
    ...Object.values(orderCounts.counts).filter((n): n is number => n !== null),
  );
  const date = new Date().toLocaleDateString("en-US", {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  return (
    <div className="admin-page">
      <PageHeader
        context={date}
        title={`${getGreeting()}${identity ? `, ${identity.fullName.split(" ")[0]}` : ""}.`}
        description="A little clarity for a busy day at Nest."
        actions={
          <Button asChild>
            <Link href="/orders">
              <ShoppingBag className="mr-2 h-4 w-4" />
              Manage Orders
            </Link>
          </Button>
        }
      />
      <section className="admin-attention" aria-label="Needs attention">
        <div className="admin-attention-intro">
          <span className="admin-attention-icon">
            <Warehouse size={20} />
          </span>
          <div>
            <h2>
              {placed == null || failed == null
                ? "Start with your order queue."
                : placed + failed > 0
                  ? "A few things need your attention."
                  : "Your order queue is in good shape."}
            </h2>
            <p>
              {placed == null || failed == null
                ? "Some queue counts are unavailable. Review orders for the latest details."
                : `${show(placed)} awaiting confirmation · ${show(failed)} delivery failures to follow up.`}
            </p>
          </div>
        </div>
        <Link href="/orders?status=PLACED" className="admin-link">
          Review the queue <ArrowUpRight size={15} />
        </Link>
      </section>
      <section className="admin-stats" aria-label="Store metrics">
        <StatCard
          tone="peach"
          label="Delivered Revenue"
          value={stats.revenue?.delivered.formatted ?? "—"}
          icon={<Banknote />}
          description={
            <>
              {stats.window?.label ?? "Period unavailable"}
              <br />
              {stats.revenue
                ? `${stats.revenue.deliveredCount} paid orders`
                : "Counted at delivery"}
            </>
          }
        />
        <StatCard
          tone="sage"
          label="Awaiting confirmation"
          value={show(placed)}
          icon={<Clock />}
          description="Call the customer to confirm · all time"
        />
        <StatCard
          tone="slate"
          label="Ready to ship"
          value={show(ready)}
          icon={<CheckCircle2 />}
          description="Confirmed, not yet dispatched · all time"
        />
        <StatCard
          tone="rose"
          label="Delivery failed"
          value={show(failed)}
          icon={<AlertTriangle />}
          description="Re-dispatch or return · all time"
        />
      </section>
      <div className="admin-overview">
        <ChartContainer
          title="The bigger picture"
          description="Order status distribution · all time"
          action={
            <Link href="/orders" className="admin-link">
              View orders <ArrowUpRight size={14} />
            </Link>
          }
        >
          <div
            className="admin-status-chart"
            role="group"
            aria-label="All-time order counts by status"
          >
            {ORDER_STATUSES.map((status) => {
              const count = orderCounts.counts[status];
              return (
                <div className="admin-status-row" key={status}>
                  <span>
                    {status.charAt(0) +
                      status.slice(1).toLowerCase().replace(/_/g, " ")}
                  </span>
                  <div className="admin-status-track" aria-hidden="true">
                    <span
                      style={{
                        width: `${count == null ? 0 : (count / peak) * 100}%`,
                      }}
                    />
                  </div>
                  <strong>{show(count)}</strong>
                </div>
              );
            })}
          </div>
          <div className="admin-catalog-summary">
            <Link href="/orders">
              <strong>{show(orderCounts.total)}</strong>Total Orders
            </Link>
            <Link href="/products">
              <strong>{stats.products ? show(stats.productCount) : "—"}</strong>
              Products
            </Link>
            <Link href="/customers">
              <strong>
                {stats.customers ? show(stats.customerCount) : "—"}
              </strong>
              Customers
            </Link>
          </div>
        </ChartContainer>
        <AdminCard>
          <SectionHeader
            title="Revenue, with context"
            description={stats.window?.label ?? "Revenue unavailable"}
          />
          <div className="space-y-5 px-6 pb-6">
            <WindowPicker active={stats.window?.key ?? null} />
            <dl className="space-y-4">
              <div className="flex flex-wrap justify-between gap-3 border-b border-border pb-4">
                <dt className="text-sm text-muted-foreground">Delivered</dt>
                <dd className="font-medium tabular-nums">
                  {stats.revenue?.delivered.formatted ?? "—"}
                </dd>
              </div>
              <div className="flex flex-wrap justify-between gap-3">
                <dt className="text-sm text-muted-foreground">Pipeline</dt>
                <dd className="font-medium tabular-nums">
                  {stats.revenue?.pipeline.formatted ?? "—"}
                </dd>
              </div>
            </dl>
            <p className="text-xs text-muted-foreground">
              Net of returns — recognised at delivery, removed retroactively if
              returned.
            </p>
            {stats.revenue === null && (
              <ErrorState
                title="Revenue could not be loaded"
                description="Try again to retrieve the selected period."
              />
            )}
          </div>
        </AdminCard>
      </div>
      <div className="admin-overview">
        <div className="space-y-6">
          <AdminCard>
            <SectionHeader
              title="Recent orders"
              description="Every order, a new project in the making."
              action={
                <Link href="/orders" className="admin-link">
                  View all <ArrowUpRight size={14} />
                </Link>
              }
            />
            {!recentOrders.ok ? (
              <ErrorState
                title="Recent orders could not be loaded"
                description={recentOrders.error.message}
              />
            ) : recentOrders.data.data.length === 0 ? (
              <EmptyState
                title="No orders yet"
                description="New customer orders will appear here. Your catalog is ready to explore."
                action={
                  <Link href="/products" className="admin-link">
                    Review products <ArrowUpRight size={14} />
                  </Link>
                }
              />
            ) : (
              <TableScroll label="Recent orders">
                <table>
                  <thead>
                    <tr>
                      <th className="px-6 text-left">Order</th>
                      <th className="text-left">Items</th>
                      <th className="text-right">Amount</th>
                      <th className="px-4 text-left">Status</th>
                      <th className="px-6 text-right">Action</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-border">
                    {recentOrders.data.data.map((order) => (
                      <tr key={order.id}>
                        <td className="px-6">
                          <Link
                            href={`/orders/${order.id}`}
                            className="font-medium text-primary"
                          >
                            {order.orderNumber}
                          </Link>
                          <p className="text-xs text-muted-foreground">
                            {formatRelativeTime(order.placedAt)}
                          </p>
                        </td>
                        <td>
                          {order.itemCount} line
                          {order.itemCount === 1 ? "" : "s"}
                        </td>
                        <td className="text-right tabular-nums whitespace-nowrap">
                          {order.pricing.grandTotal.formatted}
                        </td>
                        <td className="px-4">
                          <StatusBadge status={order.status} />
                        </td>
                        <td className="px-6 text-right">
                          <Link
                            href={`/orders/${order.id}`}
                            className="admin-link"
                          >
                            View <ArrowUpRight size={14} />
                          </Link>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </TableScroll>
            )}
          </AdminCard>
          <AdminCard>
            <SectionHeader
              title="Low stock"
              description="A quick check before the next dispatch."
              action={
                <Link href="/inventory" className="admin-link">
                  Manage Inventory <ArrowUpRight size={14} />
                </Link>
              }
            />
            {!stats.products ? (
              <ErrorState
                title="Stock levels could not be loaded"
                description="Retry to check the inventory snapshot."
              />
            ) : stats.lowStock.length === 0 ? (
              <EmptyState
                title="Stock levels are healthy"
                description="No products are currently below their stock threshold."
                icon={<Package />}
              />
            ) : (
              <ul className="divide-y divide-border">
                {stats.lowStock.map((item) => (
                  <li
                    key={item.sku}
                    className="flex items-center justify-between gap-4 px-6 py-4"
                  >
                    <div className="min-w-0">
                      <p className="text-sm font-medium">{item.name_en}</p>
                      <p className="text-xs text-muted-foreground">
                        {item.sku}
                      </p>
                    </div>
                    <div className="shrink-0 text-right">
                      <strong className="text-destructive tabular-nums">
                        {item.stock_quantity - (item.reserved_quantity ?? 0)}
                      </strong>
                      <p className="text-xs text-muted-foreground">available</p>
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </AdminCard>
        </div>
        <Suspense
          fallback={<LoadingState title="Loading recent activity" rows={4} />}
        >
          <ActivityFeed />
        </Suspense>
      </div>
    </div>
  );
}
