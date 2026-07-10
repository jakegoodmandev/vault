import { getWorkspaces } from '@/lib/data/workspace';
import { redirect } from 'next/navigation';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';

export default async function HomePage() {
  const workspaces = await getWorkspaces();
  console.log('Rendering HomePage...', workspaces);
  if (workspaces?.length) redirect(`/${workspaces[0].id}`);

  return (
    <div className="flex min-h-svh w-full items-center justify-center p-6 md:p-10">
      <div className="w-full max-w-sm">
        <Card>
          <CardHeader>
            <CardTitle>App for Doctors</CardTitle>
            <CardDescription>It's an app... for doctors</CardDescription>
          </CardHeader>
          <CardContent>Help the people!</CardContent>
        </Card>
      </div>
    </div>
  );
}
