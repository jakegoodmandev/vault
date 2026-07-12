import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';

const claims = [
  {
    id: 'CLM-1048',
    insured: 'Dubai Marine Logistics',
    type: 'Cargo loss',
    status: 'Review',
    reserve: '$420,000',
  },
  {
    id: 'CLM-1039',
    insured: 'Palm District Holdings',
    type: 'Property damage',
    status: 'Investigation',
    reserve: '$285,000',
  },
  {
    id: 'CLM-1027',
    insured: 'Creekside Retail Group',
    type: 'Business interruption',
    status: 'Negotiation',
    reserve: '$190,000',
  },
];

export default function Page() {
  return (
    <main className="flex min-h-svh flex-col gap-6 p-6">
      <div className="space-y-1">
        <h1 className="text-2xl font-semibold tracking-normal">Claims</h1>
        <p className="text-sm text-muted-foreground">
          Track active claims, reserves, and handling status.
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Active Claims</CardTitle>
          <CardDescription>Priority files across the workspace</CardDescription>
        </CardHeader>
        <CardContent className="overflow-x-auto">
          <table className="w-full min-w-[680px] text-sm">
            <thead className="border-b text-left text-muted-foreground">
              <tr>
                <th className="py-3 pr-4 font-medium">Claim</th>
                <th className="py-3 pr-4 font-medium">Insured</th>
                <th className="py-3 pr-4 font-medium">Type</th>
                <th className="py-3 pr-4 font-medium">Status</th>
                <th className="py-3 text-right font-medium">Reserve</th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {claims.map((claim) => (
                <tr key={claim.id}>
                  <td className="py-3 pr-4 font-medium">{claim.id}</td>
                  <td className="py-3 pr-4">{claim.insured}</td>
                  <td className="py-3 pr-4 text-muted-foreground">{claim.type}</td>
                  <td className="py-3 pr-4">
                    <span className="inline-flex rounded-sm border px-2 py-1 text-xs">
                      {claim.status}
                    </span>
                  </td>
                  <td className="py-3 text-right tabular-nums">{claim.reserve}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </CardContent>
      </Card>
    </main>
  );
}
