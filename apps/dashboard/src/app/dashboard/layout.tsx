import { AppNav } from '@/components/app-nav';
import { createClient } from '@/lib/supabase/server';
import { SidebarInset, SidebarProvider } from '@/components/ui/sidebar';
import { AppSidebar } from '@/components/app-sidebar';
import { StaffProvider } from '@/components/staff-provider';

export default async function DashboardLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const supabase = await createClient();

  // Get authorized user
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // Get staff associated with the authorized user
  const { data } = await supabase
    .from('staff')
    .select('id, email')
    .eq('auth_user_id', user!.id);

  const staff = data![0];
  console.log('got user:', data);

  return (
    <StaffProvider staffContextProps={{ id: staff.id, email: staff.email }}>
      <SidebarProvider>
        <AppSidebar variant="inset" />
        <SidebarInset>
          <AppNav user={user} />
          {children}
        </SidebarInset>
      </SidebarProvider>
    </StaffProvider>
  );
}
