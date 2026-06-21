import { createClient } from "@/lib/supabase/server";
import { LogoutButton } from "./logout-button";

export async function DashboardHeader() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  return (
    <header className="h-14 border-b flex items-center justify-between px-6 bg-background">
      <p className="text-sm text-muted-foreground">
        Welcome, <span className="font-medium text-foreground">{user?.email}</span>
      </p>
      <div className="flex items-center gap-3">
        <LogoutButton />
      </div>
    </header>
  );
}
