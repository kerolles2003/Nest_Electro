import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nest_electro/src/app.dart';
import 'package:nest_electro/src/core/api/providers.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/models/brand.dart';
import 'package:nest_electro/src/core/models/cart.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';
import 'package:nest_electro/src/features/auth/data/auth_repository.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/cart/data/cart_repository.dart';
import 'package:nest_electro/src/features/cart/presentation/cart_controller.dart';
import 'package:nest_electro/src/features/catalogue/data/catalogue_repository.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/checkout/data/checkout_repository.dart';
import 'package:nest_electro/src/features/checkout/presentation/checkout_controller.dart';

class _MockCatalogueRepository extends Mock implements CatalogueRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockCartRepository extends Mock implements CartRepository {}

class _MockCheckoutRepository extends Mock implements CheckoutRepository {}

class _MockAccountRepository extends Mock implements AccountRepository {}

AuthUserDto _user() {
  return AuthUserDto.fromJson(<String, dynamic>{
    'id': 'u1',
    'email': 'user@example.com',
    'fullName': 'Test User',
    'phone': '01012345678',
    'role': 'CUSTOMER',
    'emailVerified': true,
    'lastLoginAt': null,
    'createdAt': '2026-01-01T00:00:00.000Z',
  });
}

Map<String, dynamic> _money(int amount, String formatted) {
  return <String, dynamic>{
    'amount': amount,
    'currency': 'EGP',
    'formatted': formatted,
  };
}

ProductListItemDto _listItem() {
  return ProductListItemDto.fromJson(<String, dynamic>{
    'id': 'id-a',
    'slug': 'esp32-board',
    'sku': 'ESP32-BOARD',
    'name': 'ESP32 Dev Board',
    'shortDescription': 'A dev board.',
    'category': <String, dynamic>{
      'id': 'c1',
      'slug': 'microcontrollers',
      'name': 'Microcontrollers',
    },
    'brand': null,
    'pricing': <String, dynamic>{
      'basePrice': _money(25000, '250.00 EGP'),
      'salePrice': null,
      'effectivePrice': _money(25000, '250.00 EGP'),
      'discountPercentBps': 0,
    },
    'primaryImage': null,
    'rating': <String, dynamic>{'average': 4.5, 'count': 12},
    'availability': 'IN_STOCK',
    'isFeatured': true,
  });
}

ProductDetailDto _detail() {
  return ProductDetailDto.fromJson(<String, dynamic>{
    'id': 'id-a',
    'slug': 'esp32-board',
    'sku': 'ESP32-BOARD',
    'name': 'ESP32 Dev Board',
    'shortDescription': 'A dev board.',
    'category': <String, dynamic>{
      'id': 'c1',
      'slug': 'microcontrollers',
      'name': 'Microcontrollers',
    },
    'brand': null,
    'pricing': <String, dynamic>{
      'basePrice': _money(25000, '250.00 EGP'),
      'salePrice': null,
      'effectivePrice': _money(25000, '250.00 EGP'),
      'discountPercentBps': 0,
    },
    'primaryImage': null,
    'rating': <String, dynamic>{'average': 4.5, 'count': 12},
    'availability': 'IN_STOCK',
    'isFeatured': true,
    'description': 'Full description of the board.',
    'images': <dynamic>[],
    'specs': <dynamic>[],
    'stockOnHand': 14,
    'salesCount': 42,
    'weight': 0.05,
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-02T00:00:00.000Z',
  });
}

PaginatedList<ProductListItemDto> _page(List<ProductListItemDto> items) {
  return PaginatedList<ProductListItemDto>(
    items: items,
    meta: PaginationMetaDto(
      page: 1,
      limit: 10,
      total: items.length,
      totalPages: 1,
      hasNext: false,
      hasPrev: false,
    ),
  );
}

CartDto _cart({bool withLine = false}) {
  return CartDto.fromJson(<String, dynamic>{
    'items': withLine
        ? <dynamic>[
            <String, dynamic>{
              'productId': 'id-a',
              'slug': 'esp32-board',
              'sku': 'ESP32-BOARD',
              'name': 'ESP32 Dev Board',
              'imagePublicId': 'nest/products/id-a/hero',
              'quantity': 1,
              'effectiveQuantity': 1,
              'availableQuantity': 14,
              'unitPrice': _money(25000, '250.00 EGP'),
              'previousUnitPrice': null,
              'lineTotal': _money(25000, '250.00 EGP'),
              'status': 'OK',
              'addedAt': '2026-01-01T00:00:00.000Z',
            },
          ]
        : <dynamic>[],
    'itemCount': withLine ? 1 : 0,
    'totalQuantity': withLine ? 1 : 0,
    'itemsSubtotal': _money(withLine ? 25000 : 0, withLine ? '250.00 EGP' : '0.00 EGP'),
    'currency': 'EGP',
    'hasBlockingIssues': false,
    'updatedAt': '2026-01-01T00:00:00.000Z',
    'expiresAt': '2026-01-02T00:00:00.000Z',
  });
}

AddressDto _address() {
  return AddressDto.fromJson(<String, dynamic>{
    'id': 'addr-1',
    'label': 'Home',
    'fullName': 'Test User',
    'phone': '01012345678',
    'street': '1 Main St',
    'city': 'Cairo',
    'governorate': 'Cairo',
    'postalCode': '',
    'isDefault': true,
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-01T00:00:00.000Z',
  });
}

CheckoutQuoteViewDto _quote() {
  return CheckoutQuoteViewDto.fromJson(<String, dynamic>{
    'items': <dynamic>[],
    'itemCount': 1,
    'totalQuantity': 1,
    'currency': 'EGP',
    'pricing': <String, dynamic>{
      'itemsSubtotal': _money(25000, '250.00 EGP'),
      'discountTotal': null,
      'shippingFee': _money(5000, '50.00 EGP'),
      'shippingPriced': true,
      'grandTotal': _money(30000, '300.00 EGP'),
      'vatInclusive': true,
      'vatRateBps': 1400,
    },
    'hasBlockingIssues': false,
    'canPlaceOrder': true,
    'generatedAt': '2026-01-01T00:00:00.000Z',
  });
}

ManualPaymentInstructionsDto _methods() {
  return ManualPaymentInstructionsDto.fromJson(<String, dynamic>{
    'availableMethods': <String>['COD', 'WALLET', 'INSTAPAY'],
    'walletNumber': '01099998888',
    'instapayAddress': '01099998888@instapay',
    'whatsappNumber': '201099998888',
  });
}

OrderDto _order() {
  return OrderDto.fromJson(<String, dynamic>{
    'id': 'o1',
    'orderNumber': 'NE-1001',
    'status': 'PLACED',
    'customer': <String, dynamic>{
      'fullName': 'Test User',
      'email': 'user@example.com',
      'phone': null,
    },
    'items': <dynamic>[],
    'currency': 'EGP',
    'pricing': <String, dynamic>{
      'itemsSubtotal': _money(25000, '250.00 EGP'),
      'discountTotal': null,
      'shippingFee': _money(5000, '50.00 EGP'),
      'shippingPriced': true,
      'grandTotal': _money(30000, '300.00 EGP'),
      'vatInclusive': true,
      'vatRateBps': 1400,
    },
    'payment': <String, dynamic>{
      'method': 'COD',
      'status': 'PENDING',
      'collectedAt': null,
      'verification': null,
    },
    'shippingAddress': <String, dynamic>{
      'fullName': 'Test User',
      'phone': '01012345678',
      'street': '1 Main St',
      'city': 'Cairo',
      'governorate': 'Cairo',
      'postalCode': '',
    },
    'customerNote': '',
    'cancellation': null,
    'shipment': null,
    'placedAt': '2026-01-01T00:00:00.000Z',
  });
}

void main() {
  setUpAll(() {
    // Phase 10: fonts are bundled — no GoogleFonts config needed.
    // The cart controller reads guest storage (SharedPreferences) during
    // its load — without mock values that throws and the cart spins
    // forever (caught by this test before the fix).
    SharedPreferences.setMockInitialValues(<String, Object>{});
    registerFallbackValue(const ProductQuery());
    registerFallbackValue(const PlaceOrderDto(addressId: ''));
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
  });

  testWidgets('happy path: browse -> cart -> checkout -> confirmation',
      (WidgetTester tester) async {
    final _MockCatalogueRepository catalogue = _MockCatalogueRepository();
    final _MockAuthRepository auth = _MockAuthRepository();
    final _MockTokenStorage tokens = _MockTokenStorage();
    final _MockCartRepository cartRepo = _MockCartRepository();
    final _MockCheckoutRepository checkoutRepo = _MockCheckoutRepository();
    final _MockAccountRepository accountRepo = _MockAccountRepository();

    when(() => tokens.hasRefreshToken).thenAnswer((_) async => true);
    when(() => auth.me()).thenAnswer((_) async => _user());
    when(() => catalogue.listCategories()).thenAnswer(
      (_) async => <CategoryDto>[
        CategoryDto.fromJson(<String, dynamic>{
          'id': 'c1',
          'slug': 'microcontrollers',
          'name': 'Microcontrollers',
          'description': '',
          'parentId': null,
          'depth': 0,
          'image': null,
          'productCount': 1,
          'sortOrder': 0,
        }),
      ],
    );
    when(() => catalogue.listBrands())
        .thenAnswer((_) async => <BrandDto>[]);
    when(() => catalogue.listProducts(any()))
        .thenAnswer((_) async => _page(<ProductListItemDto>[_listItem()]));
    when(() => catalogue.getProduct('esp32-board'))
        .thenAnswer((_) async => _detail());
    when(() => catalogue.getRelated('esp32-board'))
        .thenAnswer((_) async => <ProductListItemDto>[]);
    // Stateful cart mock: the real server keeps an added line, so a
    // reload after the add must still show it (a rebuild of the cart
    // controller re-runs _load -> getCart, which would otherwise
    // overwrite the added line with an empty cart).
    bool lineAdded = false;
    when(() => cartRepo.getCart())
        .thenAnswer((_) async => _cart(withLine: lineAdded));
    when(() => cartRepo.addItem(any(), any())).thenAnswer((_) async {
      lineAdded = true;
      return _cart(withLine: true);
    });
    when(() => checkoutRepo.listAddresses())
        .thenAnswer((_) async => <AddressDto>[_address()]);
    when(() => checkoutRepo.getQuote('addr-1'))
        .thenAnswer((_) async => _quote());
    when(() => checkoutRepo.getPaymentMethods())
        .thenAnswer((_) async => _methods());
    when(() => checkoutRepo.placeOrder(any(), any()))
        .thenAnswer((_) async => _order());

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          catalogueRepositoryProvider.overrideWithValue(catalogue),
          authRepositoryProvider.overrideWithValue(auth),
          tokenStorageProvider.overrideWithValue(tokens),
          cartRepositoryProvider.overrideWithValue(cartRepo),
          checkoutRepositoryProvider.overrideWithValue(checkoutRepo),
          accountRepositoryProvider.overrideWithValue(accountRepo),
        ],
        child: const NestElectroApp(),
      ),
    );
    // Manual pumps: the home hero's 8-second auto-advance timer never
    // settles under pumpAndSettle (D-19).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Home (Arabic default locale) with the featured product.
    expect(find.text('نيست إلكترو'), findsOneWidget);
    expect(find.text('ESP32 Dev Board'), findsWidgets);

    // Browse -> product detail. The featured rail sits below the fold,
    // so scroll it into view before tapping.
    await tester.ensureVisible(find.text('ESP32 Dev Board').first);
    await tester.pump();
    await tester.tap(find.text('ESP32 Dev Board').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('ESP32 Dev Board'), findsWidgets);

    // Add to cart -> snackbar -> view cart. The bar uses
    // FilledButton.icon, whose runtime type is a private subclass, so
    // widgetWithText(FilledButton, …) never matches it — tap the text.
    await tester.tap(find.text('أضف إلى السلة'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('تمت الإضافة إلى السلة'), findsOneWidget);
    verify(() => cartRepo.addItem('id-a', 1)).called(1);
    await tester.tap(find.text('عرض السلة'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('ESP32 Dev Board'), findsWidgets);

    // Cart -> checkout (authenticated, so no login redirect).
    await tester.tap(find.widgetWithText(FilledButton, 'إتمام الشراء'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    verify(() => checkoutRepo.listAddresses()).called(1);
    verify(() => checkoutRepo.getQuote('addr-1')).called(1);

    // Place the order with the default address + COD.
    await tester.tap(find.widgetWithText(FilledButton, 'تأكيد الطلب'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    verify(() => checkoutRepo.placeOrder(any(), any())).called(1);

    // Confirmation screen.
    expect(find.text('شكرًا! تم تأكيد طلبك.'), findsOneWidget);
    expect(find.textContaining('NE-1001'), findsOneWidget);
    expect(find.text('300.00 EGP'), findsOneWidget);
  });
}
