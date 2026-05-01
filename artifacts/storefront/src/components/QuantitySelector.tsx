import { Minus, Plus } from 'lucide-react';

interface QuantitySelectorProps {
  quantity: number;
  onIncrease: () => void;
  onDecrease: () => void;
  max?: number;
  min?: number;
}

export function QuantitySelector({ quantity, onIncrease, onDecrease, max = 99, min = 1 }: QuantitySelectorProps) {
  return (
    <div className="flex items-center border border-slate-200 rounded-md">
      <button onClick={onDecrease} disabled={quantity <= min} className="px-2 py-1.5 text-slate-500 hover:bg-slate-50 disabled:opacity-40 transition-colors" aria-label="Decrease">
        <Minus className="w-4 h-4" />
      </button>
      <span className="w-10 text-center text-sm font-medium text-slate-900">{quantity}</span>
      <button onClick={onIncrease} disabled={quantity >= max} className="px-2 py-1.5 text-slate-500 hover:bg-slate-50 disabled:opacity-40 transition-colors" aria-label="Increase">
        <Plus className="w-4 h-4" />
      </button>
    </div>
  );
}
