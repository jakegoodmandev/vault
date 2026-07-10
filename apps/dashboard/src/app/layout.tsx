import { GeistMono } from 'geist/font/mono';
import {
  GeistPixelCircle,
  GeistPixelGrid,
  GeistPixelLine,
  GeistPixelSquare,
  GeistPixelTriangle,
} from 'geist/font/pixel';
import { GeistSans } from 'geist/font/sans';
import type { Metadata } from 'next';
import { TooltipProvider } from '@/components/ui/tooltip';
import { ThemeProvider } from '@/components/theme-provider';
import { getWorkspaces } from '@/lib/data/workspace';
import { redirect } from 'next/navigation';

import './globals.css';

export const metadata: Metadata = {
  title: 'Dashboard',
  description: 'Dashboard for healthcare.',
};

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  console.log('Rendering RootLayout...');
  return (
    <html
      lang="en"
      suppressHydrationWarning // This is recommended for using next-themes
      className={`
        ${GeistSans.variable}
        ${GeistMono.variable}
        ${GeistPixelSquare.variable}
        ${GeistPixelGrid.variable}
        ${GeistPixelCircle.variable}
        ${GeistPixelTriangle.variable}
        ${GeistPixelLine.variable}
        antialiased
      `}
    >
      <body>
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <TooltipProvider>{children}</TooltipProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
