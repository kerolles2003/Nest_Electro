import { useState, useEffect } from 'react';
import { getSupabaseClient } from '@/lib/supabase';
import type { User } from '@supabase/supabase-js';

interface AuthUser {
  id: string;
  email: string;
  fullName: string;
  initials: string;
}

function toAuthUser(user: User | null): AuthUser | null {
  if (!user) return null;
  const fullName = user.user_metadata?.full_name ?? user.email ?? 'User';
  const initials = fullName
    .split(' ')
    .slice(0, 2)
    .map((n: string) => n[0]?.toUpperCase() ?? '')
    .join('');
  return { id: user.id, email: user.email ?? '', fullName, initials };
}

export function useAuth() {
  const supabase = getSupabaseClient();
  const [user, setUser] = useState<AuthUser | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(toAuthUser(session?.user ?? null));
      setLoading(false);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(toAuthUser(session?.user ?? null));
    });

    return () => subscription.unsubscribe();
  }, []);

  const signOut = async () => {
    await supabase.auth.signOut();
  };

  const signInWithGoogle = async () => {
    await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: {
        redirectTo: `${window.location.origin}/account/orders`,
      },
    });
  };

  return { user, loading, signOut, signInWithGoogle };
}
