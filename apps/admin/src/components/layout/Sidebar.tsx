"use client";

import { useId, useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { LogOut, Menu, ChevronDown, Package } from "lucide-react";
import { logoutAction } from "@/actions/admin-auth.actions";
import type { AdminIdentity } from "@/lib/api/identity";
import { navSections } from "@/config/navigation";
import {
  Avatar,
  Dialog,
  DialogContent,
  DialogTitle,
  DialogDescription,
  DialogTrigger,
} from "@nest/ui";

function SidebarContent({
  identity,
  onNavigate,
}: {
  identity: AdminIdentity | null;
  onNavigate?: () => void;
}) {
  const pathname = usePathname().replace(/^\/admin(?=\/|$)/, "") || "/";
  const id = useId();
  const [collapsed, setCollapsed] = useState<Record<string, boolean>>({});
  return (
    <>
      <Link
        href="/"
        className="admin-brand"
        onClick={onNavigate}
        aria-label="Nest Electronics dashboard"
      >
        <span className="admin-brand-mark">
          n<span>·</span>
        </span>
        <span>
          nest<small>ELECTRONICS</small>
        </span>
      </Link>
      <div className="admin-workspace-label">
        <Package size={15} aria-hidden="true" /> Store workspace
      </div>
      <nav className="admin-navigation" aria-label="Admin navigation">
        {navSections.map((section) => (
          <div className="admin-nav-group" key={section.label}>
            {section.label !== "Overview" && (
              <button
                className="admin-nav-label"
                type="button"
                aria-expanded={!collapsed[section.label]}
                aria-controls={`${id}-${section.label}`}
                onClick={() =>
                  setCollapsed((current) => ({
                    ...current,
                    [section.label]: !current[section.label],
                  }))
                }
              >
                {section.label}
                <ChevronDown
                  size={12}
                  className={collapsed[section.label] ? "-rotate-90" : ""}
                  aria-hidden="true"
                />
              </button>
            )}
            <div
              id={`${id}-${section.label}`}
              hidden={!!collapsed[section.label]}
            >
              {section.items.map((item) => {
                const active =
                  item.href === "/"
                    ? pathname === "/"
                    : pathname === item.href ||
                      pathname.startsWith(`${item.href}/`);
                const Icon = item.icon;
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    onClick={onNavigate}
                    aria-current={active ? "page" : undefined}
                    className={`admin-nav-item ${active ? "is-active" : ""}`}
                  >
                    <Icon size={17} aria-hidden="true" />
                    <span>{item.label}</span>
                  </Link>
                );
              })}
            </div>
          </div>
        ))}
      </nav>
      <div className="admin-sidebar-profile">
        <Avatar size="sm" fallback={identity?.initials ?? "?"} />
        <div className="min-w-0 flex-1">
          {identity ? (
            <>
              <p className="truncate font-medium">{identity.fullName}</p>
              <p
                className="truncate text-xs text-muted-foreground"
                title={identity.email}
              >
                {identity.email}
              </p>
            </>
          ) : (
            <p className="text-warning">Identity unavailable</p>
          )}
        </div>
        <form action={logoutAction}>
          <button
            type="submit"
            className="admin-icon-button"
            aria-label="Sign Out"
            title="Sign Out"
          >
            <LogOut size={16} aria-hidden="true" />
          </button>
        </form>
      </div>
    </>
  );
}

export function AdminSidebar({ identity }: { identity: AdminIdentity | null }) {
  const [mobileOpen, setMobileOpen] = useState(false);
  return (
    <>
      <aside className="admin-sidebar">
        <SidebarContent identity={identity} />
      </aside>
      <Dialog open={mobileOpen} onOpenChange={setMobileOpen}>
        <DialogTrigger asChild>
          <button
            type="button"
            className="admin-mobile-nav-trigger admin-icon-button"
            aria-label="Open navigation"
          >
            <Menu size={20} aria-hidden="true" />
          </button>
        </DialogTrigger>
        <DialogContent className="admin-nav-dialog">
          <DialogTitle className="sr-only">Store navigation</DialogTitle>
          <DialogDescription className="sr-only">
            Navigate the Nest Electronics admin workspace.
          </DialogDescription>
          <SidebarContent
            identity={identity}
            onNavigate={() => setMobileOpen(false)}
          />
        </DialogContent>
      </Dialog>
    </>
  );
}
