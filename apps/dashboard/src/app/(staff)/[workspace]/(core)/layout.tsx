import { AppNav } from '@/components/app-nav';
import { AppSidebar } from '@/components/app-sidebar';
import { SidebarInset, SidebarProvider } from '@/components/ui/sidebar';

export default async function CoreLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <SidebarProvider>
      <AppSidebar variant="inset" />
      <SidebarInset>
        {/* <AppNav user={user} /> */}
        {children}
      </SidebarInset>
    </SidebarProvider>
  );
}
