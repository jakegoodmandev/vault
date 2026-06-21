import { Suspense } from "react";
import { createClient } from "@/lib/supabase/server";
import { getCurrentStaff } from "@/lib/auth";

async function FacilitiesTable() {
  const { practiceId } = await getCurrentStaff();
  const supabase = await createClient();

  console.log(practiceId)
  const { data: facilities } = await supabase
    .from("facilities")
    .select("*")
    .eq("practice_id", practiceId)
    .order("name");

  const items = facilities ?? [];

  return (
    <div className="rounded-lg border overflow-hidden">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-muted/50">
            <th className="text-left p-3 font-medium">Name</th>
            <th className="text-left p-3 font-medium">City</th>
            <th className="text-left p-3 font-medium">Province</th>
            <th className="text-left p-3 font-medium">Phone</th>
            <th className="text-left p-3 font-medium">Status</th>
          </tr>
        </thead>
        <tbody>
          {items.length === 0 ? (
            <tr>
              <td colSpan={5} className="p-3 text-center text-muted-foreground">No facilities found.</td>
            </tr>
          ) : items.map((f) => (
            <tr key={f.id} className="border-t hover:bg-muted/50">
              <td className="p-3 font-medium">{f.name}</td>
              <td className="p-3 text-muted-foreground">{f.city ?? "-"}</td>
              <td className="p-3 text-muted-foreground">{f.province ?? "-"}</td>
              <td className="p-3 text-muted-foreground">{f.phone ?? "-"}</td>
              <td className="p-3">
                <span className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium ${f.is_active ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}`}>
                  {f.is_active ? "Active" : "Inactive"}
                </span>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default function FacilitiesPage() {
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Facilities</h1>
      <Suspense fallback={<div className="text-muted-foreground p-4">Loading...</div>}>
        <FacilitiesTable />
      </Suspense>
    </div>
  );
}
