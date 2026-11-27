import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((_) {
  return WishlistRepository();
});

/// A saved product in the local wishlist.
///
/// The API has no wishlist endpoint (API_GAPS.md G1) and the storefront
/// keeps its wishlist in Supabase, so this repository is a clearly marked
/// LOCAL-ONLY mock: items live in SharedPreferences on this device and
/// carry a snapshot (name / price at save time) that can go stale. Tapping
/// an item opens the product detail, which always shows live data.
class WishlistItem {
  const WishlistItem({
    required this.productId,
    required this.slug,
    required this.name,
    required this.imagePublicId,
    required this.priceFormatted,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productId: json['productId'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      imagePublicId: json['imagePublicId'] as String,
      priceFormatted: json['priceFormatted'] as String,
    );
  }

  final String productId;
  final String slug;
  final String name;
  final String imagePublicId;
  final String priceFormatted;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'productId': productId,
      'slug': slug,
      'name': name,
      'imagePublicId': imagePublicId,
      'priceFormatted': priceFormatted,
    };
  }
}

class WishlistRepository {
  WishlistRepository({SharedPreferences? prefs}) : _prefs = prefs;

  static const String storageKey = 'nest_wishlist_v1';

  final SharedPreferences? _prefs;

  Future<SharedPreferences> _store() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  Future<List<WishlistItem>> load() async {
    final SharedPreferences store = await _store();
    final String? raw = store.getString(storageKey);
    if (raw == null || raw.isEmpty) {
      return const <WishlistItem>[];
    }
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (Object? e) =>
                WishlistItem.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } on FormatException {
      // A corrupt payload must not brick the wishlist.
      return const <WishlistItem>[];
    }
  }

  Future<void> _save(List<WishlistItem> items) async {
    final SharedPreferences store = await _store();
    await store.setString(
      storageKey,
      jsonEncode(items.map((WishlistItem i) => i.toJson()).toList()),
    );
  }

  Future<List<WishlistItem>> add(WishlistItem item) async {
    final List<WishlistItem> items = await load();
    if (items.any((WishlistItem i) => i.productId == item.productId)) {
      return items;
    }
    final List<WishlistItem> updated = <WishlistItem>[...items, item];
    await _save(updated);
    return updated;
  }

  Future<List<WishlistItem>> remove(String productId) async {
    final List<WishlistItem> items = await load();
    final List<WishlistItem> updated = items
        .where((WishlistItem i) => i.productId != productId)
        .toList();
    await _save(updated);
    return updated;
  }

  Future<bool> isSaved(String productId) async {
    final List<WishlistItem> items = await load();
    return items.any((WishlistItem i) => i.productId == productId);
  }
}
