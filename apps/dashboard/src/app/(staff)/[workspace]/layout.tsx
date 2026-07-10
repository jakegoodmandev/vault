import { WorkspaceProvider } from '@/components/workspace-provider';
import { getWorkspaces } from '@/lib/data/workspace';
import { redirect } from 'next/navigation';

export default async function WorkspaceLayout({
  children,
  params,
}: Readonly<{
  children: React.ReactNode;
  params: Promise<{ workspace: string }>;
}>) {
  const { workspace: workspaceId } = await params;
  const availableWorkspaces = await getWorkspaces();
  const activeWorkspace = availableWorkspaces.find((w) => w.id === workspaceId);
  console.log(
    'Rendering WorkspaceLayout...',
    workspaceId,
    availableWorkspaces,
    activeWorkspace
  );
  if (!activeWorkspace) {
    throw new Error('Unauthorized access to workspace: ' + workspaceId);
  }

  // Theoretically make another API call to get more details about the workspace
  const settings = 'settings details from the server';
  return (
    <WorkspaceProvider workspaceContextProps={{ ...activeWorkspace!, settings }}>
      {children}
    </WorkspaceProvider>
  );
}
