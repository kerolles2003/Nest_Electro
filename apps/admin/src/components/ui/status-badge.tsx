import { StatusBadge as SharedStatusBadge } from "@nest/ui";

/** Add the API's current fulfilment states without changing storefront styles. */
export function StatusBadge({
  status,
  className = "",
}: {
  status: string;
  className?: string;
}) {
  return (
    <SharedStatusBadge
      status={status}
      className={`admin-status-${status.toLowerCase()} ${className}`}
    />
  );
}
