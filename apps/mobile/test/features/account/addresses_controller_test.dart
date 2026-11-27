import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';
import 'package:nest_electro/src/features/account/presentation/addresses_controller.dart';

class _MockAccountRepository extends Mock implements AccountRepository {}

AddressDto _address(String id, {bool isDefault = false}) {
  return AddressDto.fromJson(<String, dynamic>{
    'id': id,
    'label': 'Home',
    'fullName': 'Test User',
    'phone': '01000000000',
    'street': '1 Main St',
    'city': 'Cairo',
    'governorate': 'Cairo',
    'postalCode': '',
    'isDefault': isDefault,
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-01T00:00:00.000Z',
  });
}

Future<void> _pump() async {
  for (int i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CreateAddressDto(
        label: '',
        fullName: '',
        phone: '',
        street: '',
        city: '',
        governorate: '',
      ),
    );
    registerFallbackValue(const UpdateAddressDto());
  });

  late _MockAccountRepository repository;
  late ProviderContainer container;
  late AddressesController controller;

  setUp(() {
    repository = _MockAccountRepository();
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[
        _address('a1', isDefault: true),
        _address('a2'),
      ],
    );
    container = ProviderContainer(
      overrides: <Override>[
        accountRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    controller = container.read(addressesControllerProvider.notifier);
  });

  test('loads the saved addresses', () async {
    await _pump();
    final AddressesState state = container.read(addressesControllerProvider);
    expect(state.isLoading, false);
    expect(state.addresses.length, 2);
    expect(state.addresses.first.isDefault, true);
  });

  test('create appends the new address', () async {
    when(() => repository.createAddress(any())).thenAnswer(
      (_) async => _address('a3'),
    );
    await _pump();

    final AddressDto? created = await controller.create(
      const CreateAddressDto(
        label: 'Work',
        fullName: 'Test User',
        phone: '01000000000',
        street: '2 Work St',
        city: 'Cairo',
        governorate: 'Cairo',
      ),
    );
    expect(created?.id, 'a3');
    expect(container.read(addressesControllerProvider).addresses.length, 3);
  });

  test('update replaces the edited address in place', () async {
    when(() => repository.updateAddress(any(), any())).thenAnswer(
      (_) async => _address('a2'),
    );
    await _pump();

    final AddressDto? updated = await controller.update(
      'a2',
      const UpdateAddressDto(label: 'Office'),
    );
    expect(updated?.id, 'a2');
    verify(() => repository.updateAddress('a2', any())).called(1);
  });

  test('delete and setDefault use the list the API returns', () async {
    when(() => repository.deleteAddress(any())).thenAnswer(
      (_) async => <AddressDto>[_address('a1', isDefault: true)],
    );
    when(() => repository.setDefaultAddress(any())).thenAnswer(
      (_) async => <AddressDto>[
        _address('a1'),
        _address('a2', isDefault: true),
      ],
    );
    await _pump();

    expect(await controller.delete('a2'), true);
    expect(
      container.read(addressesControllerProvider).addresses.length,
      1,
    );

    expect(await controller.setDefault('a2'), true);
    final AddressesState state = container.read(addressesControllerProvider);
    expect(state.addresses.length, 2);
    expect(state.addresses.last.isDefault, true);
  });

  test('non-API load failure surfaces LOAD_FAILED instead of spinning',
      () async {
    // Phase 10: the setUp container already loaded successfully (its
    // microtasked load runs before this body), so the failing load is
    // proven on a fresh container stubbed to throw first.
    when(() => repository.listAddresses()).thenThrow(
      StateError('platform failure'),
    );
    final ProviderContainer fresh = ProviderContainer(
      overrides: <Override>[
        accountRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(fresh.dispose);
    fresh.read(addressesControllerProvider.notifier);
    await _pump();

    final AddressesState state = fresh.read(addressesControllerProvider);
    expect(state.isLoading, false);
    expect(state.error?.code, 'LOAD_FAILED');
    expect(state.addresses, isEmpty);
  });
}
