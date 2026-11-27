import type { Metadata } from "next";
import { connection } from 'next/server';
import { Albert_Sans, Urbanist } from "next/font/google";
import { AdminProviders } from "@/components/AdminProviders";
import "./globals.css";

/*
 * The storefront's typefaces (apps/storefront/src/app/layout.tsx): Albert
 * Sans for body text, Urbanist for headings. Loading the same two families
 * here is what makes the console read as the same brand before a single
 * colour is seen. next/font self-hosts the files, so the CSP `font-src
 * 'self'` policy is untouched and no runtime request leaves the origin.
 */
const albertSans = Albert_Sans({
  subsets: ["latin"],
  variable: "--font-body",
  display: "swap",
});
const urbanist = Urbanist({
  subsets: ["latin"],
  variable: "--font-display",
  display: "swap",
});

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
      className={`h-full antialiased ${albertSans.variable} ${urbanist.variable}`}
    >
      <body className="admin-app min-h-full bg-background text-foreground font-sans">
        <AdminProviders>
          {children}
        </AdminProviders>
      </body>
    </html>
  );
}
