import { Suspense } from "react";
import { createClient } from "@/lib/supabase/server";
import { getCurrentStaff } from "@/lib/auth";
import { Building2, Stethoscope, CreditCard, Users, FileText } from "lucide-react";

async function DashboardStats() {
  const { practiceId } = await getCurrentStaff();
  const supabase = await createClient();

  const { data: practice } = await supabase
    .from("practices")
    .select("name")
    .eq("id", practiceId)
    .single();

  const { data: staff } = await supabase
    .from("staff")
    .select("role")
    .eq("practice_id", practiceId)
    .limit(1)
    .single();

  const [{ count: facilityCount }, { count: providerCount }, { count: payerCount }, { count: patientCount }] = await Promise.all([
    supabase.from("facilities").select("*", { count: "exact", head: true }).eq("practice_id", practiceId),
    supabase.from("providers").select("*", { count: "exact", head: true }).eq("practice_id", practiceId),
    supabase.from("payers").select("*", { count: "exact", head: true }).eq("practice_id", practiceId),
    supabase.from("patients").select("*", { count: "exact", head: true }).eq("practice_id", practiceId),
  ]);

  const { data: facilityIds } = await supabase
    .from("facilities")
    .select("id")
    .eq("practice_id", practiceId);

  const { count: claimCount } = await supabase
    .from("claims")
    .select("*", { count: "exact", head: true })
    .in("facility_id", facilityIds?.map((f) => f.id) ?? []);

  const cards = [
    { label: "Facilities", value: facilityCount ?? 0, icon: Building2, href: "/protected/facilities" },
    { label: "Providers", value: providerCount ?? 0, icon: Stethoscope, href: "/protected/providers" },
    { label: "Payers", value: payerCount ?? 0, icon: CreditCard, href: "/protected/payers" },
    { label: "Patients", value: patientCount ?? 0, icon: Users, href: "/protected/patients" },
    { label: "Claims", value: claimCount ?? 0, icon: FileText, href: "/protected/claims" },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold">{practice?.name ?? "My Practice"}</h1>
        <p className="text-muted-foreground text-sm">Role: {staff?.role ?? "-"}</p>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-4">
        {cards.map((card) => (
          <a
            key={card.label}
            href={card.href}
            className="flex flex-col gap-2 rounded-lg border p-4 hover:bg-accent transition-colors"
          >
            <div className="flex items-center gap-2 text-muted-foreground">
              <card.icon className="h-4 w-4" />
              <span className="text-sm font-medium">{card.label}</span>
            </div>
            <span className="text-3xl font-bold">{card.value}</span>
          </a>
        ))}
      </div>
    </div>
  );
}

export default function DashboardPage() {
  return (
    <Suspense fallback={<div className="text-muted-foreground p-4">Loading dashboard...</div>}>
      <DashboardStats />
    </Suspense>
  );
}
