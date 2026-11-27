import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/features/account/presentation/account_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/validators.dart';

/// Profile: email (read-only) + email-verification state, full name and
/// phone editable via `PATCH /users/me`. The session user is refreshed
/// after a save so the new values show everywhere without a relogin.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool _editing = false;
  bool _controllersSeeded = false;

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _seedControllers(AuthUserDto user) {
    if (_controllersSeeded) {
      return;
    }
    _fullName.text = user.fullName;
    _phone.text = user.phone ?? '';
    _controllersSeeded = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final bool ok = await ref
        .read(accountControllerProvider.notifier)
        .updateProfile(
          fullName: _fullName.text.trim(),
          phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        );
    if (!mounted) {
      return;
    }
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? l10n.profileSaved : l10n.errorGeneric,
        ),
      ),
    );
    if (ok) {
      setState(() => _editing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AccountState state = ref.watch(accountControllerProvider);
    final AuthUserDto? user = state.user;
    ref.listen<AccountState>(accountControllerProvider, (_, AccountState next) {
      if (next.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!.message)),
        );
      }
    });
    if (user != null) {
      _seedControllers(user);
    }
    return Scaffold(
      key: const Key('profile-screen'),
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: <Widget>[
          if (user != null)
            TextButton(
              onPressed: () {
                setState(() => _editing = !_editing);
              },
              child: Text(_editing ? l10n.cancel : l10n.profileEdit),
            ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (user == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(l10n.errorGeneric),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        ref.read(accountControllerProvider.notifier).reload(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(user.email),
                subtitle: Text(
                  user.emailVerified
                      ? l10n.profileEmailVerified
                      : l10n.profileEmailNotVerified,
                ),
                trailing: Icon(
                  user.emailVerified
                      ? Icons.verified_outlined
                      : Icons.warning_amber_outlined,
                  color: user.emailVerified
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ),
              const Divider(),
              if (_editing)
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _fullName,
                        decoration: InputDecoration(
                          labelText: l10n.addressFullName,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (String? v) =>
                            AuthValidators.fullName(v, l10n),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: l10n.addressPhone,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (String? v) {
                          if (v == null || v.trim().isEmpty) {
                            return null;
                          }
                          return AuthValidators.phone(v, l10n);
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: state.isSaving ? null : _save,
                          child: Text(l10n.profileSave),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.addressFullName),
                      subtitle: Text(user.fullName),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.addressPhone),
                      subtitle: Text(user.phone ?? '—'),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
