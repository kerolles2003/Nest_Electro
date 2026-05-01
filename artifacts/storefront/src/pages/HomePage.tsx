import { useEffect, useState } from 'react';
import { getSupabaseClient } from '@/lib/supabase';
import { HeroBanner } from '@/components/home/HeroBanner';
import { TrustBar } from '@/components/home/TrustBar';
import { FeaturedProducts, FeaturedProductsSkeleton } from '@/components/home/FeaturedProducts';
import { NewArrivals } from '@/components/home/NewArrivals';
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

function toProductDTO(p: any): ProductCardDTO {
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
    rating: p.avg_rating ?? 0,
    reviewCount: p.review_count ?? 0,
    inStock: p.available_stock > 0,
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
  const [brands, setBrands] = useState<Brand[]>([]);
  const [loadingFeatured, setLoadingFeatured] = useState(true);

  const supabase = getSupabaseClient();

  useEffect(() => {
    const load = async () => {
      const [catRes, brandRes, featuredRes, newRes] = await Promise.all([
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
          .order('name_en')
          .limit(20),
        supabase
          .from('products')
          .select(`id, slug, sku, name_en, base_price, sale_price, avg_rating, review_count, available_stock, is_featured, images:product_images(url), brand:brands(name_en), category:categories(name_en)`)
          .eq('is_published', true)
          .eq('is_featured', true)
          .order('created_at', { ascending: false })
          .limit(10),
        supabase
          .from('products')
          .select(`id, slug, sku, name_en, base_price, sale_price, avg_rating, review_count, available_stock, is_featured, images:product_images(url), brand:brands(name_en), category:categories(name_en)`)
          .eq('is_published', true)
          .order('created_at', { ascending: false })
          .limit(10),
      ]);

      setCategories(catRes.data ?? []);
      setBrands(brandRes.data ?? []);
      setFeatured((featuredRes.data ?? []).map(toProductDTO));
      setNewArrivals((newRes.data ?? []).map(toProductDTO));
      setLoadingFeatured(false);
    };

    load();
  }, []);

  const categoryTree = buildCategoryTree(categories);

  return (
    <>
      <HeroBanner categories={categoryTree} />
      <TrustBar />
      {loadingFeatured ? <FeaturedProductsSkeleton /> : <FeaturedProducts products={featured} />}
      <NewArrivals products={newArrivals} />
      <BrandsStrip brands={brands} />
      <CategoryGrid categories={categoryTree} />
    </>
  );
}
