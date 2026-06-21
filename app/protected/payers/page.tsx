import { Suspense } from "react";
import { createClient } from "@/lib/supabase/server";
import { getCurrentStaff } from "@/lib/auth";

async function PayersTable() {
  const { practiceId } = await getCurrentStaff();
  const supabase = await createClient();

  const { data: payers } = await supabase
    .from("payers")
    .select("*")
    .eq("practice_id", practiceId)
    .order("name");

  const items = payers ?? [];

  return (
    <div className="rounded-lg border overflow-hidden">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-muted/50">
            <th className="text-left p-3 font-medium">Name</th>
            <th className="text-left p-3 font-medium">Payer ID</th>
            <th className="text-left p-3 font-medium">Type</th>
            <th className="text-left p-3 font-medium">City</th>
            <th className="text-left p-3 font-medium">Status</th>
          </tr>
        </thead>
        <tbody>
          {items.length === 0 ? (
            <tr>
              <td colSpan={5} className="p-3 text-center text-muted-foreground">No payers found.</td>
            </tr>
          ) : items.map((p) => (
            <tr key={p.id} className="border-t hover:bg-muted/50">
              <td className="p-3 font-medium">{p.name}</td>
              <td className="p-3 text-muted-foreground">{p.payer_id ?? "-"}</td>
              <td className="p-3">
                <span className="inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium bg-blue-100 text-blue-700">
                  {p.payer_type ?? "N/A"}
                </span>
              </td>
              <td className="p-3 text-muted-foreground">{p.city ?? "-"}</td>
              <td className="p-3">
                <span className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium ${p.is_active ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}`}>
                  {p.is_active ? "Active" : "Inactive"}
                </span>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default function PayersPage() {
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Payers</h1>
      <Suspense fallback={<div className="text-muted-foreground p-4">Loading...</div>}>
        <PayersTable />
      </Suspense>
    </div>
  );
}
