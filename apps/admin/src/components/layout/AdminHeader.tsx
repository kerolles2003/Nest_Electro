"use client";

import { useRef, useEffect } from "react";
import { usePathname, useRouter } from "next/navigation";
import {
  Bell,
  Search,
  ChevronRight,
  Check,
  Settings,
  Shield,
  LogOut,
  ChevronDown,
} from "lucide-react";
import Link from "next/link";
import { logoutAction } from "@/actions/admin-auth.actions";
import type { AdminIdentity } from "@/lib/api/identity";
import {
  Avatar,
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@nest/ui";

export function AdminHeader({ identity }: { identity: AdminIdentity | null }) {
  const pathname = usePathname().replace(/^\/admin(?=\/|$)/, "") || "/";
  const segments = pathname.split("/").filter(Boolean);
  const router = useRouter();
  const search = useRef<HTMLInputElement>(null);
  useEffect(() => {
    const onKey = (event: KeyboardEvent) => {
      if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === "k") {
        event.preventDefault();
        search.current?.focus();
      }
    };
    document.addEventListener("keydown", onKey);
    return () => document.removeEventListener("keydown", onKey);
  }, []);
  return (
    <header className="admin-topbar">
      <nav aria-label="Breadcrumb" className="admin-breadcrumb">
        <Link href="/">Workspace</Link>
        <ChevronRight size={12} aria-hidden="true" />
        {segments.length === 0 ? (
          <span>Overview</span>
        ) : (
          <>
            <Link href={`/${segments[0]}`} className="capitalize">
              {segments[0].replace(/-/g, " ")}
            </Link>
            {segments.length > 1 && (
              <>
                <ChevronRight size={12} aria-hidden="true" />
                <span>
                  {segments.includes("new")
                    ? "New product"
                    : segments.includes("edit")
                      ? "Edit product"
                      : "Details"}
                </span>
              </>
            )}
          </>
        )}
      </nav>
      <div className="admin-topbar-tools">
        <form
          className="admin-global-search"
          role="search"
          onSubmit={(event) => {
            event.preventDefault();
            const query = search.current?.value.trim() ?? "";
            router.push(
              query ? `/orders?q=${encodeURIComponent(query)}` : "/orders",
            );
          }}
        >
          <Search size={16} aria-hidden="true" />
          <input
            ref={search}
            name="q"
            type="search"
            aria-label="Search orders"
            placeholder="Search orders…"
          />
          <kbd>Ctrl K</kbd>
        </form>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <button className="admin-icon-button" aria-label="Notifications">
              <Bell size={18} aria-hidden="true" />
            </button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-72 p-4">
            <DropdownMenuLabel>Notifications</DropdownMenuLabel>
            <div className="px-3 py-7 text-center">
              <Check
                className="mx-auto mb-3 h-7 w-7 text-primary"
                aria-hidden="true"
              />
              <p className="font-medium">A quieter workspace</p>
              <p className="mt-1 text-xs text-muted-foreground">
                Notifications aren’t available yet.
              </p>
            </div>
          </DropdownMenuContent>
        </DropdownMenu>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <button
              className="admin-user-trigger"
              aria-label={identity?.fullName ?? "Not identified"}
            >
              <span data-testid="header-avatar">
                <Avatar size="sm" fallback={identity?.initials ?? "?"} />
              </span>
              <span className="admin-user-name">
                {identity?.fullName ?? "Not identified"}
              </span>
              <ChevronDown size={12} aria-hidden="true" />
            </button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-64 p-2">
            <DropdownMenuLabel className="font-normal p-3">
              {identity ? (
                <>
                  <p className="font-medium break-words">{identity.fullName}</p>
                  <p className="text-xs text-muted-foreground break-all">
                    {identity.email}
                  </p>
                  <p className="mt-1 text-xs text-muted-foreground">
                    {identity.role.replace("_", " ")}
                  </p>
                </>
              ) : (
                <>
                  <p className="text-warning">Identity unavailable</p>
                  <p className="text-xs text-muted-foreground">
                    The API did not confirm who is signed in. Reload, or sign in
                    again.
                  </p>
                </>
              )}
            </DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem asChild>
              <Link href="/settings">
                <Settings className="mr-2 h-4 w-4" />
                Settings
              </Link>
            </DropdownMenuItem>
            <DropdownMenuItem asChild>
              <Link href="/audit-log">
                <Shield className="mr-2 h-4 w-4" />
                Audit Log
              </Link>
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <form action={logoutAction}>
              <DropdownMenuItem
                asChild
                onSelect={(event) => event.preventDefault()}
              >
                <button
                  type="submit"
                  className="flex w-full items-center gap-2 text-destructive"
                >
                  <LogOut size={16} />
                  Sign Out
                </button>
              </DropdownMenuItem>
            </form>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}
