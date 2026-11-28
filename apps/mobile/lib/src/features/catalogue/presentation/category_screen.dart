import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/catalogue/presentation/product_list_screen.dart';

/// One category's product list. The header shows the category description
/// (from `GET /categories/{slug}`); the list itself is the shared
/// [ProductListScreen] with `category` fixed.
class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CategoryDetailDto> detail = ref.watch(
      categoryDetailProvider(slug),
    );
    final CategoryDetailDto? category = detail.valueOrNull;

    return ProductListScreen(
      query: ProductQuery(category: slug),
      title: category?.name ?? slug,
      header: category == null
          ? null
          : category.description.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    category.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
    );
  }
}
