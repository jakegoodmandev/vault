import { createClient } from '@/lib/supabase/server';
import { Tables } from '@/lib/database.types';
import { cache } from 'react';

export const getStaff = cache(async (): Promise<Tables<'staff'>> => {
  const supabase = await createClient();

  // Get authorized user
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    throw new Error('Cannot get user because the user is not authorized.');
  }

  // Get staff associated with the authorized user
  const { data: staffList } = await supabase
    .from('staff')
    .select('id, auth_user_id, email, created_at')
    .eq('auth_user_id', user.id);

  if (!staffList || staffList.length !== 1) {
    throw new Error('Failed to get staff associated with the authorized user.');
  }

  console.log('Inside getStaff...', staffList[0]);
  return staffList[0];
});
