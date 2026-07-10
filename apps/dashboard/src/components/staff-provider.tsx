'use client';

import { Tables } from '@/lib/database.types';
import { createContext, useContext } from 'react';

type StaffContextProps = Omit<Tables<'staff'>, 'auth_user_id'> & {
  workspaces: Tables<'workspace'>[];
};

const StaffContext = createContext<StaffContextProps | null>(null);

export function useStaff() {
  const context = useContext(StaffContext);
  if (!context) {
    throw new Error('useStaff must be used within a StaffProvider.');
  }

  return context;
}

export function StaffProvider({
  staffContextProps,
  children,
}: {
  staffContextProps: StaffContextProps;
  children: React.ReactNode;
}) {
  return (
    <StaffContext.Provider value={staffContextProps}>{children}</StaffContext.Provider>
  );
}
