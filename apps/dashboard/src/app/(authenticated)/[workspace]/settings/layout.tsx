import { createClient } from '@/lib/supabase/server';
import { SidebarInset, SidebarProvider } from '@/components/ui/sidebar';
import { AppSidebar } from '@/components/app-sidebar';
import { StaffProvider } from '@/components/staff-provider';
import { WorkspaceProvider } from '@/components/workspace-provider';
import { SupabaseClient } from '@supabase/supabase-js';

export default async function SettingsLayout({
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
