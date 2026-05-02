import { useEffect, useState } from 'react';
import { getSupabaseClient } from '@/lib/supabase';
import { HeroBanner } from '@/components/home/HeroBanner';
import { TrustBar } from '@/components/home/TrustBar';
import { FeaturedProducts, FeaturedProductsSkeleton } from '@/components/home/FeaturedProducts';
import { BestPick } from '@/components/home/BestPick';
import { BrandsStrip } from '@/components/home/BrandsStrip';
import { CategoryGrid } from '@/components/home/CategoryGrid';
import type { ProductCardDTO } from '@/components/ProductCard';

interface Category {
  id: string;
  name_en: string;
  slug: string;
  parent_id: string | null;
  sort_order?: number;
  children?: Category[];
}

interface Brand {
  id: string;
  name_en: string;
  slug: string;
}

const PRODUCT_SELECT = `id, slug, sku, name_en, base_price, sale_price, stock_quantity, reserved_quantity, is_featured, images:product_images(url), brand:brands(name_en), category:categories(name_en)`;

function toProductDTO(p: {
  id: string;
  slug: string;
  sku: string;
  name_en: string;
  base_price: number;
  sale_price: number | null;
  stock_quantity: number;
  reserved_quantity: number;
  is_featured: boolean;
  images?: { url: string }[];
  brand?: { name_en: string } | null;
  category?: { name_en: string } | null;
}): ProductCardDTO {
  const available = (p.stock_quantity ?? 0) - (p.reserved_quantity ?? 0);
  return {
    id: p.id,
    slug: p.slug,
    sku: p.sku,
    name: p.name_en,
    brandName: p.brand?.name_en ?? null,
    categoryName: p.category?.name_en ?? null,
    imageUrl: p.images?.[0]?.url ?? null,
    basePrice: p.base_price,
    salePrice: p.sale_price,
    rating: 0,
    reviewCount: 0,
    inStock: available > 0,
    isFeatured: p.is_featured,
  };
}

function buildCategoryTree(categories: Category[]): Category[] {
  const roots = categories.filter((c) => !c.parent_id);
  const childrenOf = (parentId: string) => categories.filter((c) => c.parent_id === parentId);
  return roots.map((r) => ({ ...r, children: childrenOf(r.id) }));
}

export default function HomePage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [featured, setFeatured] = useState<ProductCardDTO[]>([]);
  const [newArrivals, setNewArrivals] = useState<ProductCardDTO[]>([]);
  const [bestPick, setBestPick] = useState<ProductCardDTO[]>([]);
  const [brands, setBrands] = useState<Brand[]>([]);
  const [loading, setLoading] = useState(true);

  const supabase = getSupabaseClient();

  useEffect(() => {
    const load = async () => {
      const [catRes, brandRes, featuredRes, newRes, saleRes] = await Promise.all([
        supabase
          .from('categories')
          .select('id, name_en, slug, parent_id, sort_order')
          .eq('is_active', true)
          .is('deleted_at', null)
          .order('sort_order'),
        supabase
          .from('brands')
          .select('id, name_en, slug')
          .eq('is_active', true)
          .is('deleted_at', null)
          .order('name_en'),
        supabase
          .from('products')
          .select(PRODUCT_SELECT)
          .eq('is_active', true)
          .eq('is_featured', true)
          .is('deleted_at', null)
          .order('created_at', { ascending: false })
          .limit(10),
        supabase
          .from('products')
          .select(PRODUCT_SELECT)
          .eq('is_active', true)
          .is('deleted_at', null)
          .order('created_at', { ascending: false })
          .limit(10),
        // "Best pick" = products with a sale price (good deals)
        supabase
          .from('products')
          .select(PRODUCT_SELECT)
          .eq('is_active', true)
          .is('deleted_at', null)
          .not('sale_price', 'is', null)
          .order('created_at', { ascending: false })
          .limit(8),
      ]);

      setCategories(catRes.data ?? []);
      setBrands(brandRes.data ?? []);
      setFeatured((featuredRes.data ?? []).map(toProductDTO));
      setNewArrivals((newRes.data ?? []).map(toProductDTO));
      // Best pick: prefer sale items, fall back to newest if no sale items
      const saleItems = (saleRes.data ?? []).map(toProductDTO);
      setBestPick(saleItems.length >= 3 ? saleItems : (newRes.data ?? []).map(toProductDTO));
      setLoading(false);
    };

    load();
  }, []);

  const categoryTree = buildCategoryTree(categories);

  return (
    <>
      <HeroBanner categories={categoryTree} />
      <TrustBar />
      {loading ? (
        <FeaturedProductsSkeleton />
      ) : (
        <FeaturedProducts
          featured={featured}
          topRated={featured}
          newArrivals={newArrivals}
        />
      )}
      <BestPick products={bestPick} />
      <BrandsStrip brands={brands} />
      <CategoryGrid categories={categoryTree} />
    </>
  );
}
