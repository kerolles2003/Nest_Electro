import { Link } from 'wouter';
import { AlertCircle } from 'lucide-react';

export default function NotFound() {
  return (
    <div className="min-h-screen bg-[#f8f8f8] flex items-center justify-center p-8">
      <div className="bg-white border border-[#e8e8e8] rounded-lg shadow-sm p-10 max-w-md w-full text-center space-y-5">
        <div className="w-20 h-20 rounded-full bg-[#fde8ea] flex items-center justify-center mx-auto">
          <AlertCircle className="w-10 h-10 text-[#E14A5C]" />
        </div>
        <div>
          <h1 className="font-heading font-bold text-3xl text-[#0D0625]">404</h1>
          <p className="font-heading font-semibold text-lg text-[#0D0625] mt-1">Page Not Found</p>
          <p className="text-sm text-[#777] mt-2">
            The page you're looking for doesn't exist or has been moved.
          </p>
        </div>
        <Link
          href="/"
          className="inline-flex items-center gap-2 bg-[#E14A5C] hover:bg-[#c93e4e] text-white px-6 py-2.5 rounded-md font-semibold text-sm transition-colors"
        >
          Back to Home
        </Link>
      </div>
    </div>
  );
}
