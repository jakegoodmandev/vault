'use client';

import { createContext, useContext } from 'react';

type StaffContextProps = {
  id: string;
  email: string;
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
