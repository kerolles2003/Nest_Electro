import type { ReactNode, HTMLAttributes } from "react";
import { AlertCircle, Activity } from "lucide-react";
import { Card, EmptyState, cn } from "@nest/ui";
import { RefreshButton } from "./refresh-button";

/** Admin-only presentation. Existing shared controls and domain logic stay in place. */
export function PageHeader({
  title,
  description,
  context,
  actions,
}: {
  title: ReactNode;
  description?: ReactNode;
  context?: ReactNode;
  actions?: ReactNode;
}) {
  return (
    <header className="admin-page-header">
      <div className="min-w-0">
        {context && <div className="admin-page-context">{context}</div>}
        <h1>{title}</h1>
        {description && <p>{description}</p>}
      </div>
      {actions && <div className="admin-page-actions">{actions}</div>}
    </header>
  );
}
export function SectionHeader({
  title,
  description,
  action,
}: {
  title: ReactNode;
  description?: ReactNode;
  action?: ReactNode;
}) {
  return (
    <div className="admin-section-header">
      <div className="min-w-0">
        <h2>{title}</h2>
        {description && <p>{description}</p>}
      </div>
      {action && <div className="shrink-0">{action}</div>}
    </div>
  );
}
export function AdminCard({
  className,
  ...props
}: HTMLAttributes<HTMLDivElement>) {
  return <Card className={cn("admin-card", className)} {...props} />;
}
export function StatCard({
  label,
  value,
  description,
  tone = "neutral",
  icon,
}: {
  label: string;
  value: ReactNode;
  description?: ReactNode;
  tone?: "peach" | "sage" | "slate" | "rose" | "neutral";
  icon?: ReactNode;
}) {
  return (
    <article className={`admin-stat admin-stat-${tone}`}>
      <div className="admin-stat-label">
        <span>{label}</span>
        {icon}
      </div>
      <p className="admin-stat-value">{value}</p>
      {description && (
        <div className="admin-stat-description">{description}</div>
      )}
    </article>
  );
}
export function FilterBar({
  className,
  ...props
}: HTMLAttributes<HTMLDivElement>) {
  return <div className={cn("admin-filter-bar", className)} {...props} />;
}
export function TableScroll({
  children,
  label = "Data table",
  className,
}: {
  children: ReactNode;
  label?: string;
  className?: string;
}) {
  return (
    <div
      className={cn("admin-table-scroll", className)}
      tabIndex={0}
      role="region"
      aria-label={label}
    >
      {children}
    </div>
  );
}
export function LoadingState({
  title = "Loading your workspace",
  rows = 5,
}: {
  title?: string;
  rows?: number;
}) {
  return (
    <div className="admin-loading" role="status" aria-label={title}>
      <span className="sr-only">{title}</span>
      <div className="admin-skeleton h-8 w-52 max-w-full" />
      <div className="admin-skeleton h-4 w-80 max-w-full" />
      <div className="admin-card mt-6 p-5">
        <div className="admin-skeleton mb-6 h-10 w-full" />
        {Array.from({ length: rows }, (_, i) => (
          <div key={i} className="flex gap-5 border-t border-border py-5">
            <div className="admin-skeleton h-4 w-2/5" />
            <div className="admin-skeleton h-4 w-1/4" />
            <div className="admin-skeleton h-4 w-1/6" />
          </div>
        ))}
      </div>
    </div>
  );
}
export function ErrorState({
  title,
  description,
  children,
}: {
  title: string;
  description: ReactNode;
  children?: ReactNode;
}) {
  return (
    <div className="admin-error-state" role="alert">
      <AlertCircle aria-hidden="true" />
      <h2>{title}</h2>
      <div className="admin-state-description">{description}</div>
      <div className="mt-5 flex flex-wrap justify-center gap-3">
        <RefreshButton />
        {children}
      </div>
    </div>
  );
}
export function ChartContainer({
  title,
  description,
  children,
  action,
}: {
  title: string;
  description?: ReactNode;
  children: ReactNode;
  action?: ReactNode;
}) {
  return (
    <AdminCard>
      <SectionHeader title={title} description={description} action={action} />
      {children}
    </AdminCard>
  );
}
export function ActivityItem({
  title,
  description,
  time,
}: {
  title: string;
  description: ReactNode;
  time: string;
}) {
  return (
    <li className="admin-activity-item">
      <span className="admin-activity-icon">
        <Activity aria-hidden="true" />
      </span>
      <div className="min-w-0">
        <p className="font-medium text-foreground">{title}</p>
        <p>{description}</p>
        <small>{time}</small>
      </div>
    </li>
  );
}
export { EmptyState };
