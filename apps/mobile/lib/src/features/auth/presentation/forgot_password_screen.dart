import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/validators.dart';
import 'package:nest_electro/src/features/auth/presentation/widgets/auth_form_widgets.dart';

/// Forgot-password screen. The message is deliberately generic: whether or
/// not an account exists for the email, the same text is shown (the API
/// does not disclose account existence).
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _busy = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
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
      await ref
          .read(authRepositoryProvider)
          .forgotPassword(_emailController.text.trim());
      if (!mounted) {
        return;
      }
      setState(() => _sent = true);
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
    return AuthPageFrame(
      title: l10n.forgotPasswordTitle,
      subtitle: l10n.forgotPasswordSubtitle,
      child: _sent
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(l10n.resetLinkSent),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => setState(() => _sent = false),
                  child: Text(l10n.resendButton),
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
                    controller: _emailController,
                    label: l10n.emailLabel,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const <String>[AutofillHints.email],
                    validator: (String? value) =>
                        AuthValidators.email(value, l10n),
                    onChanged: (_) => setState(() => _error = null),
                  ),
                  const SizedBox(height: 24),
                  AuthSubmitButton(
                    label: l10n.forgotPasswordButton,
                    busy: _busy,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
    );
  }
}
