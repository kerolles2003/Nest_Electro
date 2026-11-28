import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/config/api_config.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';

/// Search: type, get live suggestions from `GET /products/suggest`
/// (debounced 400 ms), tap one to open it, or submit to see the full
/// result list. An empty query issues no request — like the storefront's
/// search page.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() => _query = value.trim());
      }
    });
  }

  void _submit(String value) {
    final String q = value.trim();
    if (q.isEmpty) return;
    context.push('/products?q=${Uri.encodeQueryComponent(q)}');
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AsyncValue<List<ProductSuggestionDto>> suggestions = ref.watch(
      suggestionsProvider(_query),
    );

    return Scaffold(
      key: const Key('search-screen'),
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          onSubmitted: _submit,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
          ),
        ),
        actions: <Widget>[
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: l10n.searchClear,
              onPressed: () {
                _controller.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.search, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      l10n.searchEmptyHint,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : suggestions.when(
              data: (List<ProductSuggestionDto> items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(l10n.searchNoSuggestions),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => _submit(_query),
                            child: Text('“$_query”'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        l10n.searchSuggestions,
                        style: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                    ...items.map(
                      (ProductSuggestionDto s) => ListTile(
                        leading: s.primaryImage == null
                            ? const Icon(Icons.image_outlined)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                  imageUrl: ApiConfig.imageUrl(
                                    s.primaryImage!.publicId,
                                    version: s.primaryImage!.version,
                                  ),
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) => const Icon(
                                    Icons.broken_image_outlined,
                                  ),
                                ),
                              ),
                        title: Text(s.name),
                        subtitle: Text(s.sku),
                        onTap: () => context.push('/products/${s.slug}'),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.search),
                      title: Text('“$_query”'),
                      onTap: () => _submit(_query),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(
                child: TextButton(
                  onPressed: () => ref.invalidate(suggestionsProvider(_query)),
                  child: Text(l10n.retry),
                ),
              ),
            ),
    );
  }
}
