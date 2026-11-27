import 'package:flutter/material.dart';

/// Labelled text field used by all auth forms, with an optional
/// show/hide toggle for passwords.
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    required this.controller,
    required this.label,
    super.key,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.autofillHints,
    this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final void Function(String value)? onChanged;
  final bool enabled;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      obscureText: widget.obscureText && !_visible,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _visible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => _visible = !_visible),
              )
            : null,
      ),
    );
  }
}

/// Error banner shown above an auth form when the last attempt failed.
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.error.withValues(alpha: 0.3)),
      ),
      child: Text(
        message,
        style: TextStyle(color: scheme.error),
      ),
    );
  }
}

/// Submit button that shows a spinner while the form is busy.
class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    required this.label,
    required this.onPressed,
    required this.busy,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: busy ? null : onPressed,
        child: busy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
      ),
    );
  }
}

/// Shared page frame for the auth screens: centred column, max width for
/// large screens, scrollable for small ones.
class AuthPageFrame extends StatelessWidget {
  const AuthPageFrame({
    required this.title,
    required this.child,
    super.key,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (subtitle != null) ...<Widget>[
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
