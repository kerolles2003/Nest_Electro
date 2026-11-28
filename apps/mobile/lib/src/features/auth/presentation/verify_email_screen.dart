import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/validators.dart';
import 'package:nest_electro/src/features/auth/presentation/widgets/auth_form_widgets.dart';

/// Verify-email screen. Two entries:
/// - with `?token=...` (link from the email): verifies immediately on open.
/// - without a token (just registered): shows the "check your inbox" note
///   and a resend form.
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({
    this.token,
    this.email,
    this.registered = false,
    super.key,
  });

  final String? token;
  final String? email;
  final bool registered;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _busy = false;
  bool _verifying = false;
  bool _verified = false;
  bool _resent = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
    if (widget.token != null && widget.token!.isNotEmpty) {
      _verify();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() {
      _verifying = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .verifyEmail(widget.token!);
      if (!mounted) {
        return;
      }
      setState(() => _verified = true);
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() => _error = e.message);
    } finally {
      if (mounted) {
        setState(() => _verifying = false);
      }
    }
  }

  Future<void> _resend() async {
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
          .resendVerification(_emailController.text.trim());
      if (!mounted) {
        return;
      }
      setState(() => _resent = true);
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
      title: l10n.verifyEmailTitle,
      subtitle: widget.registered ? l10n.checkInboxMessage : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_verifying) ...<Widget>[
            Text(l10n.verifyingEmail),
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ] else if (_verified) ...<Widget>[
            Text(l10n.emailVerifiedMessage),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: Text(l10n.goToLogin),
            ),
          ] else ...<Widget>[
            if (_error != null) ...<Widget>[
              AuthErrorBanner(message: _error!),
              const SizedBox(height: 16),
            ],
            if (widget.token != null) ...<Widget>[
              Text(l10n.emailVerificationFailed),
              const SizedBox(height: 16),
            ],
            if (_resent) ...<Widget>[
              Text(l10n.resetLinkSent),
              const SizedBox(height: 16),
            ],
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AuthTextField(
                    controller: _emailController,
                    label: l10n.emailLabel,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const <String>[AutofillHints.email],
                    validator: (String? value) =>
                        AuthValidators.email(value, l10n),
                  ),
                  const SizedBox(height: 24),
                  AuthSubmitButton(
                    label: l10n.resendButton,
                    busy: _busy,
                    onPressed: _resend,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
