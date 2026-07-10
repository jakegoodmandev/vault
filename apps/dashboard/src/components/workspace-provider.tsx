'use client';

import { createContext, useContext } from 'react';
import { Tables } from '@/lib/database.types';

type WorkspaceContextProps = Tables<'workspace'> & { settings: string };

const WorkspaceContext = createContext<WorkspaceContextProps | null>(null);

export function useWorkspace() {
  const context = useContext(WorkspaceContext);
  if (!context) {
    throw new Error('useWorkspace must be used within a WorkspaceProvider.');
  }

  return context;
}

export function WorkspaceProvider({
  workspaceContextProps,
  children,
}: {
  workspaceContextProps: WorkspaceContextProps;
  children: React.ReactNode;
}) {
  return (
    <WorkspaceContext.Provider value={workspaceContextProps}>
      {children}
    </WorkspaceContext.Provider>
  );
}
