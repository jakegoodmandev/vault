import { Suspense } from "react";
import { createClient } from "@/lib/supabase/server";
import { getCurrentStaff } from "@/lib/auth";

const statusStyles: Record<string, string> = {
  draft: "bg-gray-100 text-gray-700",
  ready: "bg-blue-100 text-blue-700",
  submitted: "bg-yellow-100 text-yellow-700",
  accepted: "bg-green-100 text-green-700",
  partial_paid: "bg-teal-100 text-teal-700",
  paid: "bg-green-100 text-green-700",
  denied: "bg-red-100 text-red-700",
  appealed: "bg-purple-100 text-purple-700",
  closed: "bg-gray-100 text-gray-700",
  void: "bg-red-100 text-red-700",
};

async function ClaimsTable() {
  const { practiceId } = await getCurrentStaff();
  const supabase = await createClient();

  const { data: facilityIds } = await supabase
    .from("facilities")
    .select("id")
    .eq("practice_id", practiceId);

  const ids = facilityIds?.map((f) => f.id) ?? [];

  const { data: claims } = await supabase
    .from("claims")
    .select(`
      *,
      patient:patient_id(first_name, last_name),
      provider:primary_provider_id(first_name, last_name),
      facility:facility_id(name)
    `)
    .in("facility_id", ids.length > 0 ? ids : [])
    .order("created_at", { ascending: false })
    .limit(50);

  const items = claims ?? [];

  return (
    <div className="rounded-lg border overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-muted/50">
            <th className="text-left p-3 font-medium">Claim #</th>
            <th className="text-left p-3 font-medium">Patient</th>
            <th className="text-left p-3 font-medium">Provider</th>
            <th className="text-left p-3 font-medium">Facility</th>
            <th className="text-left p-3 font-medium">Service Date</th>
            <th className="text-left p-3 font-medium">Total Billed</th>
            <th className="text-left p-3 font-medium">Status</th>
          </tr>
        </thead>
        <tbody>
          {items.length === 0 ? (
            <tr>
              <td colSpan={7} className="p-3 text-center text-muted-foreground">No claims found.</td>
            </tr>
          ) : items.map((c) => (
            <tr key={c.id} className="border-t hover:bg-muted/50">
              <td className="p-3 font-medium">{c.claim_number ?? "-"}</td>
              <td className="p-3">
                {c.patient?.last_name}, {c.patient?.first_name}
              </td>
              <td className="p-3 text-muted-foreground">
                {c.provider?.last_name}, {c.provider?.first_name}
              </td>
              <td className="p-3 text-muted-foreground">{c.facility?.name ?? "-"}</td>
              <td className="p-3 text-muted-foreground">
                {c.service_date_from} - {c.service_date_to}
              </td>
              <td className="p-3 font-medium">
                ${Number(c.total_billed_amount).toLocaleString("en-US", { minimumFractionDigits: 2 })}
              </td>
              <td className="p-3">
                <span className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium ${statusStyles[c.status] ?? "bg-gray-100 text-gray-700"}`}>
                  {c.status.replace(/_/g, " ")}
                </span>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default function ClaimsPage() {
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Claims</h1>
      <Suspense fallback={<div className="text-muted-foreground p-4">Loading...</div>}>
        <ClaimsTable />
      </Suspense>
    </div>
  );
}
