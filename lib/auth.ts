import { createClient } from "@/lib/supabase/server";

export async function getCurrentStaff() {
  const supabase = await createClient();

  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Not authenticated");

  console.log("Authenticated user:", user);

  // Get session to verify access token is available for PostgREST
  const { data: { session } } = await supabase.auth.getSession();
  console.log("Session:", session ? "present (token: " + session.access_token : "MISSING");

  const { data: staff, error } = await supabase
    .from("staff")
    .select("*")
    .eq("auth_user_id", user.id)
    .single();

  console.log("error:", error);

  if (error || !staff) {
    throw new Error("Staff record not found");
  }

  return { staff, staffId: staff.id, practiceId: staff.practice_id, role: staff.role as StaffRole, providerId: staff.provider_id };
}

export type StaffRole = "admin" | "biller" | "provider" | "front_desk";
