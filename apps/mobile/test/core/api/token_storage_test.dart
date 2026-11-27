import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/models/auth.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockSecureStorage storage;
  late TokenStorage tokenStorage;

  setUp(() {
    storage = _MockSecureStorage();
    tokenStorage = TokenStorage(storage: storage);
  });

  SessionTokensDto tokens() {
    return SessionTokensDto.fromJson(
      <String, dynamic>{
        'tokenType': 'Bearer',
        'accessToken': 'access-1',
        'expiresIn': 900,
        'accessTokenExpiresAt': '2026-11-27T10:15:00.000Z',
        'refreshToken': 'refresh-1',
        'refreshTokenExpiresAt': '2026-12-04T10:00:00.000Z',
      },
    );
  }

  test('saveTokens writes all four values', () async {
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});

    await tokenStorage.saveTokens(tokens());

    verify(() => storage.write(key: 'nest_access_token', value: 'access-1'))
        .called(1);
    verify(() => storage.write(key: 'nest_refresh_token', value: 'refresh-1'))
        .called(1);
    verify(
      () => storage.write(
        key: 'nest_access_expires_at',
        value: '2026-11-27T10:15:00.000Z',
      ),
    ).called(1);
    verify(
      () => storage.write(
        key: 'nest_refresh_expires_at',
        value: '2026-12-04T10:00:00.000Z',
      ),
    ).called(1);
  });

  test('readAccessToken returns the stored token', () async {
    when(() => storage.read(key: 'nest_access_token'))
        .thenAnswer((_) async => 'access-1');

    expect(await tokenStorage.readAccessToken(), 'access-1');
  });

  test('readAccessExpiresAt parses ISO strings and tolerates garbage',
      () async {
    when(() => storage.read(key: 'nest_access_expires_at'))
        .thenAnswer((_) async => '2026-11-27T10:15:00.000Z');
    expect(
      await tokenStorage.readAccessExpiresAt(),
      DateTime.utc(2026, 11, 27, 10, 15),
    );

    when(() => storage.read(key: 'nest_access_expires_at'))
        .thenAnswer((_) async => 'not-a-date');
    expect(await tokenStorage.readAccessExpiresAt(), isNull);
  });

  test('hasRefreshToken is false when nothing is stored', () async {
    when(() => storage.read(key: 'nest_refresh_token'))
        .thenAnswer((_) async => null);

    expect(await tokenStorage.hasRefreshToken, isFalse);
  });

  test('clear deletes all four keys', () async {
    when(
      () => storage.delete(key: any(named: 'key')),
    ).thenAnswer((_) async {});

    await tokenStorage.clear();

    verify(() => storage.delete(key: 'nest_access_token')).called(1);
    verify(() => storage.delete(key: 'nest_refresh_token')).called(1);
    verify(() => storage.delete(key: 'nest_access_expires_at')).called(1);
    verify(() => storage.delete(key: 'nest_refresh_expires_at')).called(1);
  });
}
