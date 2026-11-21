import type { Metadata } from "next";
import { connection } from 'next/server';
import { AdminProviders } from "@/components/AdminProviders";
import "./globals.css";

export const metadata: Metadata = {
  title: "Nest Electronics Admin",
  description: "Admin dashboard for Nest Electronics",
};

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  // Nonces are per request; never prerender a shell with nonce-less scripts.
  await connection();
  return (
    <html
      lang="en"
      className="h-full antialiased"
    >
      <body className="admin-app min-h-full bg-background text-foreground font-sans">
        <AdminProviders>
          {children}
        </AdminProviders>
      </body>
    </html>
  );
}
