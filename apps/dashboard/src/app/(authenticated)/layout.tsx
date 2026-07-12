import { StaffProvider } from '@/components/staff-provider';
import { getStaff } from '@/lib/data/staff';
import { getWorkspaces } from '@/lib/data/workspace';
import { redirect } from 'next/navigation';

export default async function StaffLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  let staff = null;
  let workspaces = null;

  // Redirect to login if there is an error fetching staff or workspaces
  try {
    staff = await getStaff();
    workspaces = await getWorkspaces();
  } catch (error: unknown) {
    console.error('Error fetching staff or workspaces:', error);
    redirect('/auth/login');
  }

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
