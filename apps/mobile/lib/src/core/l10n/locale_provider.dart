import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App locale. Arabic (RTL) is the default (D-06). The API client reads this
/// to send `Accept-Language` (D-12).
final appLocaleProvider = StateProvider<Locale>((_) => const Locale('ar'));
