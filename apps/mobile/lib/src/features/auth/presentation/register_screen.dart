import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';
import 'package:nest_electro/src/features/auth/presentation/validators.dart';
import 'package:nest_electro/src/features/auth/presentation/widgets/auth_form_widgets.dart';

/// Register screen. The API rate-limits registration to 3 attempts/hour:
/// a 429 shows the dedicated rate-limit message instead of the raw error,
/// and the button stays disabled while the request is in flight so a
/// double-tap cannot burn two of the three attempts.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final String phone = _phoneController.text.trim();
    final RegisterPayloadDto? payload =
        await ref.read(authControllerProvider.notifier).register(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              fullName: _fullNameController.text.trim(),
              phone: phone.isEmpty ? null : phone,
            );
    if (!mounted) {
      return;
    }
    if (payload != null) {
      if (payload.emailVerificationRequired) {
        context.go(
          '/verify-email?email=${Uri.encodeComponent(_emailController.text.trim())}&registered=true',
        );
      } else {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AuthState state = ref.watch(authControllerProvider);
    final bool busy = state.isLoading;
    final ApiException? apiError = state.error;
    final String? errorMessage = apiError == null
        ? null
        : apiError.isRateLimited
            ? l10n.registerRateLimited
            : apiError.message;

    return AuthPageFrame(
      title: l10n.registerTitle,
      subtitle: l10n.registerSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (errorMessage != null) ...<Widget>[
              AuthErrorBanner(message: errorMessage),
              const SizedBox(height: 16),
            ],
            AuthTextField(
              controller: _fullNameController,
              label: l10n.fullNameLabel,
              textInputAction: TextInputAction.next,
              autofillHints: const <String>[AutofillHints.name],
              validator: (String? value) =>
                  AuthValidators.fullName(value, l10n),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailController,
              label: l10n.emailLabel,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const <String>[AutofillHints.email],
              validator: (String? value) =>
                  AuthValidators.email(value, l10n),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _phoneController,
              label: l10n.phoneLabel,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autofillHints: const <String>[AutofillHints.telephoneNumber],
              validator: (String? value) =>
                  AuthValidators.phone(value, l10n),
            ),
            const SizedBox(height: 16),
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
              validator: (String? value) => AuthValidators.confirmPassword(
                value,
                _passwordController.text,
                l10n,
              ),
            ),
            const SizedBox(height: 24),
            AuthSubmitButton(
              label: l10n.registerButton,
              busy: busy,
              onPressed: _submit,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(l10n.alreadyHaveAccount),
                TextButton(
                  onPressed: () => context.push('/login'),
                  child: Text(l10n.loginLink),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
