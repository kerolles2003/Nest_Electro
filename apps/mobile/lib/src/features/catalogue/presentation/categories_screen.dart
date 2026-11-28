import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';

/// Full category tree: roots expand to their children. The tree is built
/// client-side from the flat `GET /categories` list (`parentId`/`depth`).
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AsyncValue<List<CategoryDto>> categories = ref.watch(
      categoriesProvider,
    );

    return Scaffold(
      key: const Key('categories-screen'),
      appBar: AppBar(title: Text(l10n.categoriesTitle)),
      body: categories.when(
        data: (List<CategoryDto> all) {
          final List<CategoryDto> roots = all
              .where((CategoryDto c) => c.parentId == null)
              .toList();
          final Map<String, List<CategoryDto>> childrenByParent =
              <String, List<CategoryDto>>{};
          for (final CategoryDto c in all) {
            if (c.parentId != null) {
              childrenByParent
                  .putIfAbsent(c.parentId!, () => <CategoryDto>[])
                  .add(c);
            }
          }
          return RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: ListView.builder(
              itemCount: roots.length,
              itemBuilder: (_, int index) {
                final CategoryDto root = roots[index];
                final List<CategoryDto> children =
                    childrenByParent[root.id] ?? const <CategoryDto>[];
                if (children.isEmpty) {
                  return ListTile(
                    leading: const Icon(Icons.category_outlined),
                    title: Text(root.name),
                    subtitle: Text('${root.productCount}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/categories/${root.slug}'),
                  );
                }
                return ExpansionTile(
                  leading: const Icon(Icons.category_outlined),
                  title: Text(root.name),
                  subtitle: Text('${root.productCount}'),
                  children: <Widget>[
                    ListTile(
                      title: Text(l10n.homeSeeAll),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/categories/${root.slug}'),
                    ),
                    ...children.map(
                      (CategoryDto child) => ListTile(
                        title: Text(child.name),
                        subtitle: Text('${child.productCount}'),
                        trailing: const Icon(Icons.chevron_right),
                        contentPadding: const EdgeInsetsDirectional.only(
                          start: 56,
                          end: 16,
                        ),
                        onTap: () => context.push('/categories/${child.slug}'),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.cloud_off_outlined, size: 48),
                const SizedBox(height: 12),
                Text(
                  l10n.errorLoadProducts,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(categoriesProvider),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Re-fetches the category list. A failure surfaces through the
  /// screen's error state, so it is swallowed here.
  Future<void> _refresh(WidgetRef ref) async {
    await _guard(ref.refresh(categoriesProvider.future));
  }

  Future<void> _guard(Future<Object?> future) async {
    try {
      await future;
    } catch (_) {
      // The screen's error state shows the failure.
    }
  }
}
