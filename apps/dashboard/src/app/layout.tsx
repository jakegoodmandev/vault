import type { Metadata } from "next";
import { GeistSans } from 'geist/font/sans';
import { GeistMono } from 'geist/font/mono';
import { GeistPixelSquare, GeistPixelGrid, GeistPixelCircle, GeistPixelTriangle, GeistPixelLine } from 'geist/font/pixel';

import "./globals.css";

export const metadata: Metadata = {
  title: "Dashboard",
  description: "Dashboard for healthcare.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`
        ${GeistSans.variable}
        ${GeistMono.variable}
        ${GeistPixelSquare.variable}
        ${GeistPixelGrid.variable}
        ${GeistPixelCircle.variable}
        ${GeistPixelTriangle.variable}
        ${GeistPixelLine.variable}
        h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}
