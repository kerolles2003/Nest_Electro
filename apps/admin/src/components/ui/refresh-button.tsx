"use client";
import { useTransition } from "react";
import { useRouter } from "next/navigation";
import { RefreshCw } from "lucide-react";
import { Button } from "@nest/ui";
export function RefreshButton() {
  const router = useRouter();
  const [pending, startTransition] = useTransition();
  return (
    <Button
      variant="outline"
      size="sm"
      disabled={pending}
      onClick={() => startTransition(() => router.refresh())}
    >
      <RefreshCw
        className={`mr-2 h-4 w-4 ${pending ? "animate-spin" : ""}`}
        aria-hidden="true"
      />
      {pending ? "Refreshing…" : "Try again"}
    </Button>
  );
}
