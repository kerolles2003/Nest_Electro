import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';

/// Account home: the signed-in user's name/email, then menu entries for
/// profile, orders, addresses and the (local) wishlist, plus log out.
/// All routes under `/account` are auth-guarded by the router.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AuthState authState = ref.watch(authControllerProvider);
    final String name = authState.user?.fullName ?? '';
    final String email = authState.user?.email ?? '';
    return Scaffold(
      key: const Key('account-screen'),
      appBar: AppBar(title: Text(l10n.accountTitle)),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Text(
                name.isEmpty ? '?' : name.characters.first.toUpperCase(),
              ),
            ),
            title: Text(
              name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(email),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.profileTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/account/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(l10n.ordersTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/account/orders'),
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(l10n.addressesTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/account/addresses'),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: Text(l10n.wishlistTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/wishlist'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.accountLogout),
            onTap: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
    );
  }
}
