"use client";
import { useRef, type ReactNode } from "react";
import {
  Dialog,
  DialogContent,
  DialogTitle,
  DialogDescription,
} from "@nest/ui";
/** Existing Radix primitives provide focus trapping, Escape, and modal semantics. */
export function AdminDialog({
  title,
  children,
  onClose,
  drawer = false,
}: {
  title: string;
  children: ReactNode;
  onClose: () => void;
  drawer?: boolean;
}) {
  const opener = useRef<HTMLElement | null>(null);
  return (
    <Dialog
      open
      onOpenChange={(open) => {
        if (!open) onClose();
      }}
    >
      <DialogContent
        className={drawer ? "admin-dialog admin-drawer" : "admin-dialog"}
        onOpenAutoFocus={() => {
          opener.current =
            document.activeElement instanceof HTMLElement
              ? document.activeElement
              : null;
        }}
        onCloseAutoFocus={(event) => {
          event.preventDefault();
          opener.current?.focus();
        }}
      >
        <DialogTitle className="sr-only">{title}</DialogTitle>
        <DialogDescription className="sr-only">
          {drawer
            ? "Review the recorded inventory movements."
            : "Review the details below. Changes are applied only when you submit."}
        </DialogDescription>
        {children}
      </DialogContent>
    </Dialog>
  );
}
