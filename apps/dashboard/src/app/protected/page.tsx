import { redirect } from 'next/navigation'

import { LogoutButton } from '@/components/auth/logout-button'
import { createClient } from '@/lib/supabase/server'

export default async function ProtectedPage() {
  const supabase = await createClient()

  const { data: { user }, error: getUserError } = await supabase.auth.getUser();    
  if (getUserError) {
    console.error("Error getting user:", getUserError)
    throw new Error(getUserError.message)
  }
  if (!user) {
    redirect('/auth/login')
  }

  const { data, error: getStaffError } = await supabase
    .from('staff')
    .select()

  if (getStaffError) {
    throw new Error(getStaffError.message)
  }
  if (!data) {
    throw new Error('No staff found')
  }

  return (
    <div className="flex h-svh w-full items-center justify-center gap-2">
      <p>
        Hello <span>{user.email}</span>
      </p>
      <LogoutButton />
    </div>
  )
}
