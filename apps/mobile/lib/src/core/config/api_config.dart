/// API configuration. The base URL comes from a dart-define so no URL is ever
/// baked into the source; the default targets the Android emulator host
/// (`10.0.2.2`) mapping to the dev API on the host machine.
abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3002/api/v1',
  );

  /// Optional Cloudinary cloud name (`--dart-define=CLOUDINARY_CLOUD_NAME`).
  /// When set, image URLs use the Cloudinary shape; otherwise the local
  /// media-delivery shape is the default (D-02).
  static const String cloudinaryCloudName =
      String.fromEnvironment('CLOUDINARY_CLOUD_NAME');

  static const String cloudinaryPreset =
      String.fromEnvironment('CLOUDINARY_PRESET');

  static const String _mediaDeliveryPath = 'media-delivery';

  /// Derives a display URL for a stored image, mirroring the storefront's
  /// `lib/images.ts`. The API stores no URLs, only `publicId` (+ `version`).
  /// `version` is omitted for cart lines, which carry no version.
  static String imageUrl(String publicId, {int? version}) {
    if (cloudinaryCloudName.isNotEmpty) {
      final String preset =
          cloudinaryPreset.isNotEmpty ? '$cloudinaryPreset/' : '';
      final String v = version != null ? 'v$version/' : '';
      return 'https://res.cloudinary.com/$cloudinaryCloudName'
          '/image/upload/$preset$v$publicId';
    }
    final String v = version != null ? '/v$version' : '';
    return '$baseUrl/$_mediaDeliveryPath$v/$publicId';
  }
}
