import { ShieldX } from 'lucide-react';

export default function UnauthorizedPage() {
  return (
    <div className="admin-access-page">
      <div className="admin-access-panel text-center space-y-8">
        <div className="text-center space-y-2">
          <div className="inline-flex p-3 rounded-2xl bg-destructive/10 mb-2">
            <ShieldX className="w-8 h-8 text-destructive" />
          </div>
          <h1 className="text-foreground">
            Access Denied
          </h1>
          <p className="text-muted-foreground font-medium">
            You do not have permission to access the admin dashboard.
          </p>
        </div>

        <div className="admin-card p-6 sm:p-8 space-y-6">
          <p className="text-sm text-muted-foreground">
            If you believe this is an error, contact a super administrator.
          </p>
          <a
            href="/admin/login"
            className="inline-flex items-center justify-center w-full bg-primary hover:bg-primary-hover text-primary-foreground font-bold py-3 rounded-lg transition-colors"
          >
            Return to Login
          </a>
        </div>

        <p className="text-center text-sm text-foreground-subtle font-normal">
          &copy; {new Date().getFullYear()} Nest Electronics - Secure Access Only
        </p>
      </div>
    </div>
  );
}
