import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';
import 'package:nest_electro/src/features/auth/presentation/validators.dart';
import 'package:nest_electro/src/features/auth/presentation/widgets/auth_form_widgets.dart';

/// Login screen. On success navigates to the `redirect` target (from the
/// router guard) or home.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({this.redirect, super.key});

  final String? redirect;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final bool ok = await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) {
      return;
    }
    if (ok) {
      context.go(widget.redirect ?? '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AuthState state = ref.watch(authControllerProvider);
    final bool busy = state.isLoading;
    final String? error = state.error?.message;

    return AuthPageFrame(
      title: l10n.loginTitle,
      subtitle: l10n.loginSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (error != null) ...<Widget>[
              AuthErrorBanner(message: error),
              const SizedBox(height: 16),
            ],
            AuthTextField(
              controller: _emailController,
              label: l10n.emailLabel,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const <String>[AutofillHints.email],
              validator: (String? value) =>
                  AuthValidators.email(value, l10n),
              onChanged: (_) =>
                  ref.read(authControllerProvider.notifier).clearError(),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _passwordController,
              label: l10n.passwordLabel,
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const <String>[AutofillHints.password],
              validator: (String? value) =>
                  AuthValidators.loginPassword(value, l10n),
              onChanged: (_) =>
                  ref.read(authControllerProvider.notifier).clearError(),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.push('/forgot-password'),
                child: Text(l10n.forgotPasswordLink),
              ),
            ),
            const SizedBox(height: 8),
            AuthSubmitButton(
              label: l10n.loginButton,
              busy: busy,
              onPressed: _submit,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(l10n.noAccountYet),
                TextButton(
                  onPressed: () => context.push('/register'),
                  child: Text(l10n.createAccountLink),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
