import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/account/presentation/addresses_controller.dart';
import 'package:nest_electro/src/features/checkout/presentation/widgets/add_address_form.dart';

/// Saved addresses: list with the default badge, set-default, edit and
/// delete. Add/edit reuse the checkout address form (with the existing
/// address pre-filled when editing).
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  Future<void> _showForm(
    BuildContext context,
    WidgetRef ref, {
    AddressDto? initial,
  }) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AddressesController controller = ref.read(
      addressesControllerProvider.notifier,
    );
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: AddAddressForm(
            initial: initial,
            onSubmit: (CreateAddressDto dto) async {
              if (initial == null) {
                final AddressDto? created = await controller.create(dto);
                if (created != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.addressAdded)),
                  );
                }
                return created != null;
              }
              final AddressDto? updated = await controller.update(
                initial.id,
                UpdateAddressDto(
                  label: dto.label,
                  fullName: dto.fullName,
                  phone: dto.phone,
                  street: dto.street,
                  city: dto.city,
                  governorate: dto.governorate,
                  postalCode: dto.postalCode,
                ),
              );
              if (updated != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.addressesUpdated)),
                );
              }
              return updated != null;
            },
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AddressDto address,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.addressesDeleteConfirm),
        content: Text(address.label),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.addressesDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final bool ok = await ref
        .read(addressesControllerProvider.notifier)
        .delete(address.id);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? l10n.addressesDeleted : l10n.errorGeneric),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AddressesState state = ref.watch(addressesControllerProvider);
    ref.listen<AddressesState>(addressesControllerProvider,
        (_, AddressesState next) {
      if (next.error != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!.message)),
        );
      }
    });
    return Scaffold(
      key: const Key('addresses-screen'),
      appBar: AppBar(title: Text(l10n.addressesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.checkoutAddAddress),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.addresses.isEmpty) {
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(addressesControllerProvider.notifier).reload(),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      l10n.addressesEmpty,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(addressesControllerProvider.notifier).reload(),
            child: ListView.builder(
              itemCount: state.addresses.length,
              itemBuilder: (BuildContext context, int index) {
                final AddressDto address = state.addresses[index];
                return ListTile(
                  title: Text(address.label),
                  subtitle: Text(
                    '${address.fullName} • ${address.street}, '
                    '${address.city}, ${address.governorate}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (address.isDefault)
                        Chip(label: Text(l10n.addressDefaultBadge))
                      else
                        TextButton(
                          onPressed: state.isSaving
                              ? null
                              : () => ref
                                  .read(addressesControllerProvider.notifier)
                                  .setDefault(address.id),
                          child: Text(l10n.addressesSetDefault),
                        ),
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          if (value == 'edit') {
                            _showForm(context, ref, initial: address);
                          } else if (value == 'delete') {
                            _confirmDelete(context, ref, address);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text(l10n.addressesEdit),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text(l10n.addressesDelete),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
