import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/validators.dart';
import 'package:nest_electro/src/features/auth/presentation/widgets/auth_form_widgets.dart';

/// Reset-password screen, reached from the link in the reset email
/// (`/forgot-password/reset?token=...`).
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({this.token, super.key});

  final String? token;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _busy = false;
  bool _done = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).resetPassword(
            ResetPasswordDto(
              token: widget.token!,
              newPassword: _passwordController.text,
            ),
          );
      if (!mounted) {
        return;
      }
      setState(() => _done = true);
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() => _error = e.message);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (widget.token == null || widget.token!.isEmpty) {
      return AuthPageFrame(
        title: l10n.forgotPasswordTitle,
        child: Text(l10n.invalidResetLink),
      );
    }
    return AuthPageFrame(
      title: l10n.forgotPasswordTitle,
      subtitle: l10n.resetPasswordSubtitle,
      child: _done
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(l10n.passwordResetDone),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: Text(l10n.goToLogin),
                ),
              ],
            )
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (_error != null) ...<Widget>[
                    AuthErrorBanner(message: _error!),
                    const SizedBox(height: 16),
                  ],
                  AuthTextField(
                    controller: _passwordController,
                    label: l10n.passwordLabel,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const <String>[AutofillHints.newPassword],
                    validator: (String? value) =>
                        AuthValidators.registerPassword(value, l10n),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _confirmController,
                    label: l10n.confirmPasswordLabel,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (String? value) =>
                        AuthValidators.confirmPassword(
                      value,
                      _passwordController.text,
                      l10n,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AuthSubmitButton(
                    label: l10n.resetPasswordButton,
                    busy: _busy,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
    );
  }
}
