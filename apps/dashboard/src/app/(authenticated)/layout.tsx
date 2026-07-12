import { StaffProvider } from '@/components/staff-provider';
import { getStaff } from '@/lib/data/staff';
import { getWorkspaces } from '@/lib/data/workspace';

export default async function StaffLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const staff = await getStaff();
  const workspaces = await getWorkspaces();

  console.log('Rendering StaffLayout...');
  return (
    <StaffProvider
      staffContextProps={{
        id: staff.id,
        email: staff.email,
        created_at: staff.created_at,
        workspaces: workspaces,
      }}
    >
      {children}
    </StaffProvider>
  );
}
