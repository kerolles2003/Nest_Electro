"use client";

import {
  Children,
  cloneElement,
  isValidElement,
  useId,
  type ReactNode,
  type ReactElement,
} from "react";

/** Label and existing validation feedback for one native control. */
export function FormField({
  label,
  required,
  error,
  children,
}: {
  label: string;
  required?: boolean;
  error?: string;
  children: ReactNode;
}) {
  const id = useId();
  return (
    <div className="admin-form-field">
      <label
        htmlFor={id}
        className="mb-1.5 block text-xs font-medium text-muted-foreground"
      >
        {label}
        {required && <span className="ml-0.5 text-destructive">*</span>}
      </label>
      {Children.map(children, (child) => {
        if (
          !isValidElement(child) ||
          !["input", "select", "textarea"].includes(String(child.type))
        )
          return child;
        return cloneElement(child as ReactElement<Record<string, unknown>>, {
          id,
          "aria-invalid": error !== undefined,
          "aria-describedby": error !== undefined ? `${id}-error` : undefined,
        });
      })}
      {error !== undefined && (
        <p id={`${id}-error`} className="mt-1 text-xs text-destructive">
          {error}
        </p>
      )}
    </div>
  );
}
