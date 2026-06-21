import Link from "next/link";
import { Building2, Stethoscope, CreditCard, Users, FileText, LayoutDashboard, Activity } from "lucide-react";

const navItems = [
  { href: "/protected", label: "Dashboard", icon: LayoutDashboard },
  { href: "/protected/facilities", label: "Facilities", icon: Building2 },
  { href: "/protected/providers", label: "Providers", icon: Stethoscope },
  { href: "/protected/payers", label: "Payers", icon: CreditCard },
  { href: "/protected/patients", label: "Patients", icon: Users },
  { href: "/protected/claims", label: "Claims", icon: FileText },
];

export function Sidebar() {
  return (
    <aside className="w-60 border-r bg-background flex flex-col shrink-0">
      <div className="p-4 border-b">
        <Link href="/protected" className="flex items-center gap-2 font-semibold text-lg">
          <Activity className="h-5 w-5 text-primary" />
          <span>Vault</span>
        </Link>
      </div>
      <nav className="flex-1 p-3 space-y-1">
        {navItems.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            className="flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium text-muted-foreground hover:text-foreground hover:bg-accent transition-colors"
          >
            <item.icon className="h-4 w-4" />
            {item.label}
          </Link>
        ))}
      </nav>
    </aside>
  );
}
