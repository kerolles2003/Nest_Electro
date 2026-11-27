import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/config/api_config.dart';

void main() {
  group('ApiConfig.imageUrl (default local provider)', () {
    test('derives a versioned media-delivery URL', () {
      expect(
        ApiConfig.imageUrl(
          'nest/products/abc/xyz',
          version: 1795369735,
        ),
        'http://10.0.2.2:3002/api/v1/media-delivery/v1795369735/'
        'nest/products/abc/xyz',
      );
    });

    test('derives a version-less URL for cart lines', () {
      expect(
        ApiConfig.imageUrl('nest/products/abc/xyz'),
        'http://10.0.2.2:3002/api/v1/media-delivery/nest/products/abc/xyz',
      );
    });

    test('uses the documented default base URL', () {
      expect(ApiConfig.baseUrl, 'http://10.0.2.2:3002/api/v1');
    });
  });
}
