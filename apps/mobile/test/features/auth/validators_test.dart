import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/features/auth/presentation/validators.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('AuthValidators.email', () {
    test('rejects empty and malformed addresses', () {
      expect(AuthValidators.email('', l10n), isNotNull);
      expect(AuthValidators.email('not-an-email', l10n), isNotNull);
      expect(AuthValidators.email('a@b', l10n), isNotNull);
    });

    test('accepts a normal address', () {
      expect(AuthValidators.email('user@example.com', l10n), isNull);
    });
  });

  group('AuthValidators.registerPassword', () {
    test('enforces the 10-character minimum', () {
      expect(AuthValidators.registerPassword('short', l10n), isNotNull);
      expect(AuthValidators.registerPassword('123456789', l10n), isNotNull);
      expect(AuthValidators.registerPassword('1234567890', l10n), isNull);
    });

    test('enforces the 72-byte maximum', () {
      expect(AuthValidators.registerPassword('a' * 73, l10n), isNotNull);
      expect(AuthValidators.registerPassword('a' * 72, l10n), isNull);
    });
  });

  group('AuthValidators.phone', () {
    test('is optional', () {
      expect(AuthValidators.phone('', l10n), isNull);
      expect(AuthValidators.phone(null, l10n), isNull);
    });

    test('accepts the documented Egyptian forms', () {
      expect(AuthValidators.phone('01012345678', l10n), isNull);
      expect(AuthValidators.phone('+201012345678', l10n), isNull);
      expect(AuthValidators.phone('201012345678', l10n), isNull);
      expect(AuthValidators.phone('01512345678', l10n), isNull);
    });

    test('rejects bad prefixes and short numbers', () {
      expect(AuthValidators.phone('01312345678', l10n), isNotNull);
      expect(AuthValidators.phone('0101234567', l10n), isNotNull);
      expect(AuthValidators.phone('02012345678', l10n), isNotNull);
    });
  });

  test('confirmPassword must match', () {
    expect(
      AuthValidators.confirmPassword('abc', 'xyz', l10n),
      isNotNull,
    );
    expect(
      AuthValidators.confirmPassword('same-password', 'same-password', l10n),
      isNull,
    );
  });
}
