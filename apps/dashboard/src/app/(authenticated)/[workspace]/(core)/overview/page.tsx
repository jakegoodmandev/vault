import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';

const metrics = [
  { label: 'Open claims', value: '128', detail: '18 require review' },
  { label: 'Cycle time', value: '4.2d', detail: 'Average across active claims' },
  { label: 'Recovery', value: '$1.8M', detail: 'Tracked this quarter' },
];

const activity = [
  'New high-value claim assigned to review',
  'Coverage packet approved for Dubai Marine',
  'Reserve adjustment posted for property loss',
];

export default function Page() {
  return (
    <main className="flex min-h-svh flex-col gap-6 p-6">
      <div className="space-y-1">
        <h1 className="text-2xl font-semibold tracking-normal">Overview</h1>
        <p className="text-sm text-muted-foreground">
          Workspace health, claim volume, and operational signals.
        </p>
      </div>

      <section className="grid gap-4 md:grid-cols-3">
        {metrics.map((metric) => (
          <Card key={metric.label}>
            <CardHeader>
              <CardDescription>{metric.label}</CardDescription>
              <CardTitle className="text-3xl">{metric.value}</CardTitle>
            </CardHeader>
            <CardContent className="text-sm text-muted-foreground">
              {metric.detail}
            </CardContent>
          </Card>
        ))}
      </section>

      <section className="grid gap-4 lg:grid-cols-[2fr_1fr]">
        <Card>
          <CardHeader>
            <CardTitle>Portfolio Snapshot</CardTitle>
            <CardDescription>Current workload by claim stage</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {[
              ['Intake', '24%'],
              ['Investigation', '42%'],
              ['Negotiation', '21%'],
              ['Settlement', '13%'],
            ].map(([stage, value]) => (
              <div key={stage} className="space-y-2">
                <div className="flex items-center justify-between text-sm">
                  <span>{stage}</span>
                  <span className="text-muted-foreground">{value}</span>
                </div>
                <div className="h-2 rounded-sm bg-muted">
                  <div className="h-2 rounded-sm bg-primary" style={{ width: value }} />
                </div>
              </div>
            ))}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Recent Activity</CardTitle>
            <CardDescription>Latest workspace updates</CardDescription>
          </CardHeader>
          <CardContent>
            <ul className="space-y-3 text-sm">
              {activity.map((item) => (
                <li key={item} className="border-l-2 border-border pl-3">
                  {item}
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
      </section>
    </main>
  );
}
