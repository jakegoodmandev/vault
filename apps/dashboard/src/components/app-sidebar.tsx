'use client';

import * as React from 'react';

import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuPortal,
  DropdownMenuSeparator,
  DropdownMenuSub,
  DropdownMenuSubContent,
  DropdownMenuSubTrigger,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  Sidebar,
  SidebarContent,
  SidebarHeader,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from '@/components/ui/sidebar';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { ClipboardListIcon, LayoutDashboardIcon, ChevronDownIcon } from 'lucide-react';
import { createClient } from '@/lib/supabase/client';
import { useStaff } from '@/components/staff-provider';
import { useWorkspace } from '@/components/workspace-provider';
import Link from 'next/link';
import { useParams, usePathname } from 'next/navigation';

const mainNavItems = [
  {
    title: 'Overview',
    href: '/overview',
    icon: LayoutDashboardIcon,
  },
  {
    title: 'Claims',
    href: '/claims',
    icon: ClipboardListIcon,
  },
];

export function AppSidebar({ ...props }: React.ComponentProps<typeof Sidebar>) {
  return (
    <Sidebar collapsible="icon" {...props}>
      <SidebarHeader>
        <AppSidebarHeaderMenu />
      </SidebarHeader>
      <SidebarContent>
        <AppSidebarMainMenu />
      </SidebarContent>
    </Sidebar>
  );
}

function AppSidebarMainMenu() {
  const params = useParams<{ workspace?: string | string[] }>();
  const pathname = usePathname();
  const workspace =
    typeof params.workspace === 'string' ? params.workspace : params.workspace?.[0];

  if (!workspace) {
    return null;
  }

  return (
    <SidebarGroup>
      <SidebarGroupLabel>Workspace</SidebarGroupLabel>
      <SidebarGroupContent>
        <SidebarMenu>
          {mainNavItems.map((item) => {
            const href = `/${workspace}${item.href}`;
            const isActive = pathname === href || pathname.startsWith(`${href}/`);
            const Icon = item.icon;

            return (
              <SidebarMenuItem key={item.title}>
                <SidebarMenuButton asChild tooltip={item.title} isActive={isActive}>
                  <Link href={href}>
                    <Icon />
                    <span>{item.title}</span>
                  </Link>
                </SidebarMenuButton>
              </SidebarMenuItem>
            );
          })}
        </SidebarMenu>
      </SidebarGroupContent>
    </SidebarGroup>
  );
}

export function AppSidebarHeaderMenu() {
  const logout = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    window.location.href = '/auth/login';
  };

  const { email: staffEmail } = useStaff();
  const { name: workspaceName } = useWorkspace();

  return (
    <SidebarMenu>
      <SidebarMenuItem>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <SidebarMenuButton
              size="lg"
              className="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
            >
              <Avatar>
                <AvatarImage src={'test'} alt={'test'} />
                <AvatarFallback className="rounded-lg">CN</AvatarFallback>
              </Avatar>
              <span className="truncate text-sm font-semibold">{workspaceName}</span>
              <ChevronDownIcon className="ml-auto" />
            </SidebarMenuButton>
          </DropdownMenuTrigger>
          <DropdownMenuContent
            className="w-fit"
            align="start"
            side="bottom"
            sideOffset={4}
          >
            <DropdownMenuItem asChild>
              <Link href={`settings`}>Settings</Link>
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuSub>
              <DropdownMenuSubTrigger>Switch workspace</DropdownMenuSubTrigger>
              <DropdownMenuPortal>
                <DropdownMenuSubContent>
                  <DropdownMenuGroup>
                    <DropdownMenuLabel>{staffEmail}</DropdownMenuLabel>
                    <DropdownMenuItem className={true ? 'bg-accent' : ''}>
                      <Avatar>
                        <AvatarImage src={'test'} alt={'test'} />
                        <AvatarFallback className="rounded-lg">CN</AvatarFallback>
                      </Avatar>
                      <span>{workspaceName}</span>
                    </DropdownMenuItem>
                  </DropdownMenuGroup>
                  <DropdownMenuGroup>
                    <DropdownMenuLabel>Account</DropdownMenuLabel>
                    <DropdownMenuItem disabled>
                      Create or join a workspace...
                    </DropdownMenuItem>
                    <DropdownMenuItem disabled>Add an account...</DropdownMenuItem>
                  </DropdownMenuGroup>
                </DropdownMenuSubContent>
              </DropdownMenuPortal>
            </DropdownMenuSub>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={logout}>Log out</DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </SidebarMenuItem>
    </SidebarMenu>
  );
}
