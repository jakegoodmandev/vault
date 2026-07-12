'use client';
import { useStaff } from '@/components/staff-provider';
import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { useRouter } from 'next/navigation';

export default function Page() {
  const router = useRouter();
  const { workspaces } = useStaff();

  return (
    <div className="flex min-h-svh w-full items-center justify-center p-6 md:p-10">
      <div className="w-full max-w-sm">
        <Card>
          <CardHeader>
            <CardTitle>Pick workspace</CardTitle>
            <CardDescription>Choose a workspace</CardDescription>
          </CardHeader>
          <CardContent>
            {workspaces.map((workspace) => {
              return (
                <Button
                  key={workspace.id}
                  variant="outline"
                  size="lg"
                  onClick={() => {
                    router.push(`/${workspace.id}`);
                  }}
                >
                  <Avatar>
                    <AvatarImage src={'test'} alt={'test'} />
                    <AvatarFallback className="rounded-lg">CN</AvatarFallback>
                  </Avatar>
                  <span>{workspace.name}</span>
                </Button>
              );
            })}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
