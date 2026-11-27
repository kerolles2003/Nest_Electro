import 'dart:convert';

import 'package:nest_electro/src/core/models/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The guest basket: product ids + quantities kept on the device until the
/// user signs in. The server cart is the source of truth once authed; the
/// guest basket is only ever moved into it by an explicit user action
/// (`CartController.moveGuestLinesToAccount`), never silently.
class GuestCartStorage {
  GuestCartStorage({SharedPreferences? prefs}) : _prefs = prefs;

  static const String _key = 'nest_guest_cart_v1';

  final SharedPreferences? _prefs;

  Future<SharedPreferences> get _store async =>
      _prefs ?? SharedPreferences.getInstance();

  Future<List<GuestCartLineDto>> load() async {
    final String? raw = (await _store).getString(_key);
    if (raw == null || raw.isEmpty) {
      return const <GuestCartLineDto>[];
    }
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (Object? e) =>
                GuestCartLineDto.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } on FormatException {
      // Corrupt payload: start over rather than crashing the cart.
      return const <GuestCartLineDto>[];
    }
  }

  Future<void> save(List<GuestCartLineDto> lines) async {
    final String raw = jsonEncode(
      lines.map((GuestCartLineDto l) => l.toJson()).toList(),
    );
    await (await _store).setString(_key, raw);
  }

  Future<void> clear() async {
    await (await _store).remove(_key);
  }
}
