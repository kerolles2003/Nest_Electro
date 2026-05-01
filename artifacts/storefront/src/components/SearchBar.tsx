import { useState } from 'react';
import { useLocation } from 'wouter';
import { Search } from 'lucide-react';

interface SearchBarProps {
  initialQuery?: string;
  placeholder?: string;
}

export function SearchBar({ initialQuery = '', placeholder = 'Search products...' }: SearchBarProps) {
  const [query, setQuery] = useState(initialQuery);
  const [, navigate] = useLocation();

  const handleSearch = () => {
    const q = query.trim();
    if (q) navigate(`/search?q=${encodeURIComponent(q)}`);
  };

  return (
    <div className="flex items-center gap-2">
      <div className="relative flex-1">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 pointer-events-none" />
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onKeyDown={(e) => { if (e.key === 'Enter') handleSearch(); }}
          placeholder={placeholder}
          className="w-full h-10 pl-9 pr-4 border border-slate-200 rounded-md text-sm bg-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-200 transition-colors"
        />
      </div>
      <button
        onClick={handleSearch}
        className="h-10 px-4 bg-blue-600 text-white rounded-md text-sm font-medium hover:bg-blue-700 transition-colors"
      >
        Search
      </button>
    </div>
  );
}
