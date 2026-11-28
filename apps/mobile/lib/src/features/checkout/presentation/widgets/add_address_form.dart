import 'package:flutter/material.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/auth/presentation/validators.dart';

/// Address form used by the checkout (when the user has no saved address)
/// and, in Phase 6, by the addresses screen. Validation mirrors the API:
/// label/fullName/street/city/governorate required, phone is an Egyptian
/// mobile, postal code optional. Pass [initial] to edit an existing address
/// — the fields are pre-filled and `onSubmit` still returns the full DTO;
/// the caller converts it to an [UpdateAddressDto] for the PATCH call.
class AddAddressForm extends StatefulWidget {
  const AddAddressForm({required this.onSubmit, this.initial, super.key});

  final Future<bool> Function(CreateAddressDto dto) onSubmit;

  final AddressDto? initial;

  @override
  State<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _label = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _governorate = TextEditingController();
  final TextEditingController _postalCode = TextEditingController();
  bool _isDefault = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final AddressDto? initial = widget.initial;
    if (initial != null) {
      _label.text = initial.label;
      _fullName.text = initial.fullName;
      _phone.text = initial.phone;
      _street.text = initial.street;
      _city.text = initial.city;
      _governorate.text = initial.governorate;
      _postalCode.text = initial.postalCode;
      _isDefault = initial.isDefault;
    }
  }

  @override
  void dispose() {
    _label.dispose();
    _fullName.dispose();
    _phone.dispose();
    _street.dispose();
    _city.dispose();
    _governorate.dispose();
    _postalCode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final bool ok = await widget.onSubmit(
      CreateAddressDto(
        label: _label.text.trim(),
        fullName: _fullName.text.trim(),
        phone: _phone.text.trim(),
        street: _street.text.trim(),
        city: _city.text.trim(),
        governorate: _governorate.text.trim(),
        postalCode: _postalCode.text.trim().isEmpty
            ? null
            : _postalCode.text.trim(),
        isDefault: _isDefault,
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  l10n.checkoutAddAddress,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _label,
                  decoration: InputDecoration(labelText: l10n.addressLabel),
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty) ? l10n.requiredField : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _fullName,
                  decoration: InputDecoration(
                    labelText: l10n.addressFullName,
                  ),
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty) ? l10n.requiredField : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: l10n.addressPhone),
                  validator: (String? v) => AuthValidators.phone(v, l10n),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _street,
                  decoration: InputDecoration(labelText: l10n.addressStreet),
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty) ? l10n.requiredField : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _city,
                        decoration: InputDecoration(
                          labelText: l10n.addressCity,
                        ),
                        validator: (String? v) =>
                            (v == null || v.trim().isEmpty)
                            ? l10n.requiredField
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _governorate,
                        decoration: InputDecoration(
                          labelText: l10n.addressGovernorate,
                        ),
                        validator: (String? v) =>
                            (v == null || v.trim().isEmpty)
                            ? l10n.requiredField
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _postalCode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.addressPostalCode,
                  ),
                ),
                SwitchListTile(
                  title: Text(l10n.addressIsDefault),
                  value: _isDefault,
                  onChanged: (bool v) => setState(() => _isDefault = v),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.addressSave),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
