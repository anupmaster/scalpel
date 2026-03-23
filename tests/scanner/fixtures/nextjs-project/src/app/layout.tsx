import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Providers } from "@/components/Providers";

const inter = Inter({ subsets: ["latin"] });

/**
 * Root metadata for the Acme Storefront application.
 * Used by Next.js to populate <head> tags across all pages.
 */
export const metadata: Metadata = {
  title: {
    default: "Acme Storefront",
    template: "%s | Acme Storefront",
  },
  description:
    "Premium products curated for modern living. Fast shipping, easy returns.",
  metadataBase: new URL("https://acme-storefront.vercel.app"),
  openGraph: {
    type: "website",
    locale: "en_US",
    siteName: "Acme Storefront",
  },
};

/**
 * Root layout wrapping all pages with shared providers, fonts, and structure.
 */
export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <Providers>
          <header className="sticky top-0 z-50 border-b bg-white/80 backdrop-blur-sm">
            <nav className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
              <a href="/" className="text-xl font-bold tracking-tight">
                Acme
              </a>
              {/* TODO: Extract navigation links to a shared NavLinks component */}
              <div className="flex items-center gap-6">
                <a href="/products" className="text-sm hover:underline">
                  Products
                </a>
                <a href="/about" className="text-sm hover:underline">
                  About
                </a>
                <a href="/cart" className="text-sm hover:underline">
                  Cart
                </a>
              </div>
            </nav>
          </header>
          <main className="min-h-screen">{children}</main>
          <footer className="border-t py-8 text-center text-sm text-gray-500">
            &copy; {new Date().getFullYear()} Acme Inc. All rights reserved.
          </footer>
        </Providers>
      </body>
    </html>
  );
}
