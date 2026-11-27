import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/l10n/locale_provider.dart';

final tokenStorageProvider = Provider<TokenStorage>((_) => TokenStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  final TokenStorage storage = ref.watch(tokenStorageProvider);
  return ApiClient(
    tokenStorage: storage,
    localeResolver: () => ref.read(appLocaleProvider).languageCode,
  );
});
