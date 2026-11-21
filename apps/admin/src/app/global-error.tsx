'use client';

import { useEffect } from 'react';

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error(error);
  }, [error]);

  return (
    <html lang="en">
      <body style={{ margin: 0, background: '#f8f7f4', color: '#292f2c', fontFamily: 'Segoe UI, Arial, sans-serif' }}>
        <div style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          minHeight: '100vh',
          padding: '0 1.5rem',
          textAlign: 'center',
        }}>
          <div style={{
            width: '64px',
            height: '64px',
            background: 'rgba(239, 68, 68, 0.1)',
            borderRadius: '50%',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            marginBottom: '1.5rem',
          }}>
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#a43e39" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z" />
              <line x1="12" y1="9" x2="12" y2="13" />
              <line x1="12" y1="17" x2="12.01" y2="17" />
            </svg>
          </div>
          <h1 style={{ fontFamily: 'Georgia, serif', fontSize: '2rem', fontWeight: 400, marginBottom: '0.5rem' }}>
            Something went wrong
          </h1>
          <p style={{ color: '#62675f', maxWidth: '28rem', marginBottom: '0.5rem', fontSize: '0.875rem' }}>
            {error.message || 'An unexpected error occurred.'}
          </p>
          <div style={{ display: 'flex', gap: '0.75rem', marginTop: '1.5rem' }}>
            <button
              onClick={reset}
              style={{
                padding: '0.5rem 1rem',
                border: '1px solid #c5c9be',
                borderRadius: '0.375rem',
                background: 'transparent',
                color: '#292f2c',
                cursor: 'pointer',
                fontSize: '0.875rem',
              }}
            >
              Try Again
            </button>
            <a
              href="/admin"
              style={{
                padding: '0.5rem 1rem',
                border: 'none',
                borderRadius: '0.375rem',
                background: '#3d604c',
                color: '#ffffff',
                cursor: 'pointer',
                fontSize: '0.875rem',
                textDecoration: 'none',
              }}
            >
              Back to Dashboard
            </a>
          </div>
        </div>
      </body>
    </html>
  );
}
