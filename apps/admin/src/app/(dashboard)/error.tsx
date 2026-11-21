"use client";

import { Button } from "@nest/ui";
import { AlertCircle } from "lucide-react";

export default function DashboardError({
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="admin-error-state" role="alert">
      <AlertCircle aria-hidden="true" />
      <h1>This page could not be loaded</h1>
      <p>Your workspace is still available. Try loading this page again.</p>
      <Button className="mt-5" onClick={reset}>
        Try again
      </Button>
    </div>
  );
}
