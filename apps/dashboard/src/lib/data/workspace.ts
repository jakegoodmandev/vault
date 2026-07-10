import { createClient } from '@/lib/supabase/server';
import { Tables } from '@/lib/database.types';
import { getStaff } from '@/lib/data/staff';
import { cache } from 'react';

export const getWorkspaces = cache(async (): Promise<Tables<'workspace'>[]> => {
  const supabase = await createClient();
  const staff = await getStaff();
  const { data: staffWorkspaces } = await supabase
    .from('staff_workspace')
    .select('workspace_id')
    .eq('staff_id', staff.id);
  if (!staffWorkspaces) {
    throw new Error('Failed to get staff_workspaces');
  }
  const { data: workspaces } = await supabase
    .from('workspace')
    .select('id, name, created_at')
    .in(
      'id',
      staffWorkspaces.map((sw) => sw.workspace_id)
    );
  if (!workspaces) {
    throw new Error('Failed to get workspaces');
  }

  console.log('Inside getWorkspaces...', workspaces);
  return workspaces;
});
