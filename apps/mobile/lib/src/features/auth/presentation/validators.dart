import 'dart:convert';

import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';

/// Client-side form validation mirroring the API's server-side rules
/// (apps/api `auth-request.dto.ts` + `domain/password-policy.ts`):
/// - email: valid format, max 254 chars
/// - register password: min 10 chars, max 72 bytes (bcrypt truncation),
///   no composition rules — the server also rejects well-known passwords
///   and passwords containing the email address
/// - login password: non-empty
/// - fullName: 2–120 chars
/// - phone (optional): Egyptian mobile — `01xxxxxxxxx`, `+201xxxxxxxxx`
///   or `201xxxxxxxxx`, operator prefix 0/1/2/5
/// Server errors still win: these checks only catch typos early.
class AuthValidators {
  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.emailRequired;
    }
    final String email = value.trim();
    if (email.length > 254 ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return l10n.emailInvalid;
    }
    return null;
  }

  static String? loginPassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    return null;
  }

  static String? registerPassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 10) {
      return l10n.passwordTooShort;
    }
    if (utf8.encode(value).length > 72) {
      return l10n.passwordTooLong;
    }
    return null;
  }

  static String? fullName(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.fullNameRequired;
    }
    final String name = value.trim();
    if (name.length < 2) {
      return l10n.fullNameTooShort;
    }
    if (name.length > 120) {
      return l10n.fullNameTooLong;
    }
    return null;
  }

  static String? phone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional
    }
    if (!RegExp(r'^(\+?20|0)?1[0125][0-9]{8}$').hasMatch(value.trim())) {
      return l10n.phoneInvalid;
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String password,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value != password) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }
}
