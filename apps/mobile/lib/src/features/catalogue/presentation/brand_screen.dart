import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/models/brand.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/catalogue/presentation/product_list_screen.dart';

/// One brand's product list, with the brand description as the header.
class BrandScreen extends ConsumerWidget {
  const BrandScreen({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BrandDto> detail = ref.watch(brandDetailProvider(slug));
    final BrandDto? brand = detail.valueOrNull;

    return ProductListScreen(
      query: ProductQuery(brand: slug),
      title: brand?.name ?? slug,
      header: brand == null
          ? null
          : brand.description.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    brand.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
    );
  }
}
