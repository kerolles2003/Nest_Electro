import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get accountTitle;

  /// No description provided for @addressesTitle.
  ///
  /// In en, this message translates to:
  /// **'My addresses'**
  String get addressesTitle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// App name shown in the app bar
  ///
  /// In en, this message translates to:
  /// **'Nest Electro'**
  String get appTitle;

  /// No description provided for @blogTitle.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blogTitle;

  /// No description provided for @browseProducts.
  ///
  /// In en, this message translates to:
  /// **'Browse products'**
  String get browseProducts;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @checkInboxMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox — we sent you a verification link.'**
  String get checkInboxMessage;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactTitle;

  /// No description provided for @createAccountLink.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get createAccountLink;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'This verification link is invalid or expired. Request a new one below.'**
  String get emailVerificationFailed;

  /// No description provided for @emailVerifiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your email is verified. You can now log in.'**
  String get emailVerifiedMessage;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get forgotPasswordButton;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLink;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a reset link.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPasswordTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @fullNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Full name must not exceed 120 characters'**
  String get fullNameTooLong;

  /// No description provided for @fullNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 2 characters'**
  String get fullNameTooShort;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to login'**
  String get goToLogin;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Everything for your electronics projects'**
  String get homeWelcome;

  /// No description provided for @invalidResetLink.
  ///
  /// In en, this message translates to:
  /// **'This reset link is invalid or expired.'**
  String get invalidResetLink;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginLink;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginTitle;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountYet;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetailsTitle;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get ordersTitle;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordResetDone.
  ///
  /// In en, this message translates to:
  /// **'Your password was reset. You can now log in.'**
  String get passwordResetDone;

  /// No description provided for @passwordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password must not exceed 72 characters'**
  String get passwordTooLong;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 10 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Egyptian mobile number'**
  String get phoneInvalid;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneLabel;

  /// No description provided for @productDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetailsTitle;

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerButton;

  /// No description provided for @registerRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many registration attempts. Please wait an hour and try again.'**
  String get registerRateLimited;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to shop and track orders'**
  String get registerSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @resendButton.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resendButton;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for this email, a reset link is on its way.'**
  String get resetLinkSent;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordButton;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password'**
  String get resetPasswordSubtitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products…'**
  String get searchHint;

  /// No description provided for @verifyEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get verifyEmailButton;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyingEmail.
  ///
  /// In en, this message translates to:
  /// **'Verifying your email…'**
  String get verifyingEmail;

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistTitle;

  /// No description provided for @heroSlide1Kicker.
  ///
  /// In en, this message translates to:
  /// **'Ship same day from Cairo'**
  String get heroSlide1Kicker;

  /// No description provided for @heroSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Build what\'s next.'**
  String get heroSlide1Title;

  /// No description provided for @heroSlide1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Arduino, ESP32, sensors, and robotics modules stocked for serious student and maker projects.'**
  String get heroSlide1Subtitle;

  /// No description provided for @heroSlide1Cta.
  ///
  /// In en, this message translates to:
  /// **'Browse all components'**
  String get heroSlide1Cta;

  /// No description provided for @heroSlide2Kicker.
  ///
  /// In en, this message translates to:
  /// **'Recently restocked'**
  String get heroSlide2Kicker;

  /// No description provided for @heroSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'ESP32-S3 dev boards.'**
  String get heroSlide2Title;

  /// No description provided for @heroSlide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Dual-core, Wi-Fi plus BLE, PSRAM-ready boards for IoT prototypes and graduation builds.'**
  String get heroSlide2Subtitle;

  /// No description provided for @heroSlide2Cta.
  ///
  /// In en, this message translates to:
  /// **'Shop ESP32'**
  String get heroSlide2Cta;

  /// No description provided for @heroSlide3Kicker.
  ///
  /// In en, this message translates to:
  /// **'Student project ready'**
  String get heroSlide3Kicker;

  /// No description provided for @heroSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Start your senior project.'**
  String get heroSlide3Title;

  /// No description provided for @heroSlide3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Curated parts for robotics, sensors, displays, motor drivers, and power systems.'**
  String get heroSlide3Subtitle;

  /// No description provided for @heroSlide3Cta.
  ///
  /// In en, this message translates to:
  /// **'Explore project parts'**
  String get heroSlide3Cta;

  /// No description provided for @trustCairoStock.
  ///
  /// In en, this message translates to:
  /// **'Cairo stock'**
  String get trustCairoStock;

  /// No description provided for @trustCairoStockSub.
  ///
  /// In en, this message translates to:
  /// **'Dispatch before 3 PM'**
  String get trustCairoStockSub;

  /// No description provided for @trustVerifiedParts.
  ///
  /// In en, this message translates to:
  /// **'Verified parts'**
  String get trustVerifiedParts;

  /// No description provided for @trustVerifiedPartsSub.
  ///
  /// In en, this message translates to:
  /// **'Boards and modules checked'**
  String get trustVerifiedPartsSub;

  /// No description provided for @trustCod.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery'**
  String get trustCod;

  /// No description provided for @trustCodSub.
  ///
  /// In en, this message translates to:
  /// **'Pay after arrival'**
  String get trustCodSub;

  /// No description provided for @trustSupport.
  ///
  /// In en, this message translates to:
  /// **'Engineer support'**
  String get trustSupport;

  /// No description provided for @trustSupportSub.
  ///
  /// In en, this message translates to:
  /// **'Help choosing compatible parts'**
  String get trustSupportSub;

  /// No description provided for @homeFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured products'**
  String get homeFeatured;

  /// No description provided for @homeNewArrivals.
  ///
  /// In en, this message translates to:
  /// **'New arrivals'**
  String get homeNewArrivals;

  /// No description provided for @homeCategories.
  ///
  /// In en, this message translates to:
  /// **'Shop by category'**
  String get homeCategories;

  /// No description provided for @homeBrands.
  ///
  /// In en, this message translates to:
  /// **'Our brands'**
  String get homeBrands;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeQuickCategories.
  ///
  /// In en, this message translates to:
  /// **'Popular categories'**
  String get homeQuickCategories;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterTitle;

  /// No description provided for @filterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filterCategory;

  /// No description provided for @filterBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get filterBrand;

  /// No description provided for @filterPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get filterPrice;

  /// No description provided for @filterMinPrice.
  ///
  /// In en, this message translates to:
  /// **'Min price (EGP)'**
  String get filterMinPrice;

  /// No description provided for @filterMaxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max price (EGP)'**
  String get filterMaxPrice;

  /// No description provided for @filterInStockOnly.
  ///
  /// In en, this message translates to:
  /// **'In stock only'**
  String get filterInStockOnly;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get filterApply;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get filterClear;

  /// No description provided for @sortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortLabel;

  /// No description provided for @sortRelevance.
  ///
  /// In en, this message translates to:
  /// **'Most relevant'**
  String get sortRelevance;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceDesc;

  /// No description provided for @sortRating.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get sortRating;

  /// No description provided for @sortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name: A to Z'**
  String get sortNameAsc;

  /// No description provided for @productsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String productsCount(int count);

  /// No description provided for @emptyProducts.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get emptyProducts;

  /// No description provided for @emptyProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or clear the filters.'**
  String get emptyProductsHint;

  /// No description provided for @errorLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load products'**
  String get errorLoadProducts;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more…'**
  String get loadingMore;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, SKU, or brand — try “ESP32”.'**
  String get searchEmptyHint;

  /// No description provided for @searchSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get searchSuggestions;

  /// No description provided for @searchNoSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No suggestions'**
  String get searchNoSuggestions;

  /// No description provided for @detailSpecs.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get detailSpecs;

  /// No description provided for @detailDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get detailDescription;

  /// No description provided for @detailRelated.
  ///
  /// In en, this message translates to:
  /// **'Related products'**
  String get detailRelated;

  /// No description provided for @detailReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get detailReviews;

  /// No description provided for @detailReviewsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Reviews are coming soon — this catalogue has no reviews yet.'**
  String get detailReviewsComingSoon;

  /// No description provided for @detailSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get detailSku;

  /// No description provided for @detailStockCount.
  ///
  /// In en, this message translates to:
  /// **'{count} in stock'**
  String detailStockCount(int count);

  /// No description provided for @detailSoldCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sold'**
  String detailSoldCount(int count);

  /// No description provided for @availabilityInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get availabilityInStock;

  /// No description provided for @availabilityLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get availabilityLowStock;

  /// No description provided for @availabilityOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get availabilityOutOfStock;

  /// No description provided for @detailOutOfStockNote.
  ///
  /// In en, this message translates to:
  /// **'This item is currently out of stock.'**
  String get detailOutOfStockNote;

  /// No description provided for @detailOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String detailOff(int percent);

  /// No description provided for @ratingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String ratingCount(int count);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// No description provided for @viewCart.
  ///
  /// In en, this message translates to:
  /// **'View cart'**
  String get viewCart;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Browse the catalogue and add the parts you need.'**
  String get cartEmptyHint;

  /// No description provided for @cartSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotal;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to checkout'**
  String get cartCheckout;

  /// No description provided for @cartClear.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get cartClear;

  /// No description provided for @cartLoginToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Log in to check out'**
  String get cartLoginToCheckout;

  /// No description provided for @cartBlockingIssues.
  ///
  /// In en, this message translates to:
  /// **'Some items need your attention before checkout.'**
  String get cartBlockingIssues;

  /// No description provided for @cartLinePriceChanged.
  ///
  /// In en, this message translates to:
  /// **'Price changed since you added it'**
  String get cartLinePriceChanged;

  /// No description provided for @cartLineReducedStock.
  ///
  /// In en, this message translates to:
  /// **'Only {count} left — quantity reduced'**
  String cartLineReducedStock(int count);

  /// No description provided for @cartLineOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get cartLineOutOfStock;

  /// No description provided for @cartLineUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No longer available'**
  String get cartLineUnavailable;

  /// No description provided for @cartGuestBanner.
  ///
  /// In en, this message translates to:
  /// **'You have {count} item(s) in your guest basket.'**
  String cartGuestBanner(int count);

  /// No description provided for @cartMoveToAccount.
  ///
  /// In en, this message translates to:
  /// **'Move to my account'**
  String get cartMoveToAccount;

  /// No description provided for @cartMovedToAccount.
  ///
  /// In en, this message translates to:
  /// **'Guest basket moved to your account.'**
  String get cartMovedToAccount;

  /// No description provided for @cartItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String cartItemCount(int count);

  /// No description provided for @checkoutAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get checkoutAddress;

  /// No description provided for @checkoutAddAddress.
  ///
  /// In en, this message translates to:
  /// **'Add an address'**
  String get checkoutAddAddress;

  /// No description provided for @checkoutNoAddress.
  ///
  /// In en, this message translates to:
  /// **'Add a delivery address to continue.'**
  String get checkoutNoAddress;

  /// No description provided for @checkoutQuote.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get checkoutQuote;

  /// No description provided for @checkoutShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get checkoutShipping;

  /// No description provided for @checkoutShippingUnpriced.
  ///
  /// In en, this message translates to:
  /// **'Calculated at delivery'**
  String get checkoutShippingUnpriced;

  /// No description provided for @checkoutGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get checkoutGrandTotal;

  /// No description provided for @checkoutVatIncluded.
  ///
  /// In en, this message translates to:
  /// **'VAT included'**
  String get checkoutVatIncluded;

  /// No description provided for @checkoutPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get checkoutPaymentMethod;

  /// No description provided for @checkoutCodNote.
  ///
  /// In en, this message translates to:
  /// **'Pay in cash when your order arrives.'**
  String get checkoutCodNote;

  /// No description provided for @checkoutWalletInstructions.
  ///
  /// In en, this message translates to:
  /// **'Transfer the total to this wallet number, then send a screenshot of the transfer via WhatsApp.'**
  String get checkoutWalletInstructions;

  /// No description provided for @checkoutInstapayInstructions.
  ///
  /// In en, this message translates to:
  /// **'Transfer the total to this InstaPay address, then send a screenshot of the transfer via WhatsApp.'**
  String get checkoutInstapayInstructions;

  /// No description provided for @checkoutTransferSender.
  ///
  /// In en, this message translates to:
  /// **'Your wallet / InstaPay account (the one you sent from)'**
  String get checkoutTransferSender;

  /// No description provided for @checkoutTransferSenderHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 01xxxxxxxxx'**
  String get checkoutTransferSenderHint;

  /// No description provided for @checkoutCustomerNote.
  ///
  /// In en, this message translates to:
  /// **'Order note (optional)'**
  String get checkoutCustomerNote;

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get checkoutPlaceOrder;

  /// No description provided for @checkoutPlacingOrder.
  ///
  /// In en, this message translates to:
  /// **'Placing your order…'**
  String get checkoutPlacingOrder;

  /// No description provided for @checkoutCannotPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'This order can\'t be placed yet — check the items above.'**
  String get checkoutCannotPlaceOrder;

  /// No description provided for @checkoutPaymentMethodsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Payment instructions couldn\'t be loaded — cash on delivery is available.'**
  String get checkoutPaymentMethodsUnavailable;

  /// No description provided for @orderConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Order placed'**
  String get orderConfirmationTitle;

  /// No description provided for @orderPlacedMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your order has been placed.'**
  String get orderPlacedMessage;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get orderNumber;

  /// No description provided for @orderContinueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get orderContinueShopping;

  /// No description provided for @orderViewOrder.
  ///
  /// In en, this message translates to:
  /// **'View order'**
  String get orderViewOrder;

  /// No description provided for @orderPaymentPendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Your payment is pending verification. Send the transfer screenshot via WhatsApp so we can confirm it.'**
  String get orderPaymentPendingVerification;

  /// No description provided for @orderCodPending.
  ///
  /// In en, this message translates to:
  /// **'Please have the total ready in cash on delivery.'**
  String get orderCodPending;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Label (e.g. Home, Work)'**
  String get addressLabel;

  /// No description provided for @addressFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get addressFullName;

  /// No description provided for @addressPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get addressPhone;

  /// No description provided for @addressStreet.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get addressStreet;

  /// No description provided for @addressCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get addressCity;

  /// No description provided for @addressGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get addressGovernorate;

  /// No description provided for @addressPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal code (optional)'**
  String get addressPostalCode;

  /// No description provided for @addressIsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default address'**
  String get addressIsDefault;

  /// No description provided for @addressSave.
  ///
  /// In en, this message translates to:
  /// **'Save address'**
  String get addressSave;

  /// No description provided for @addressAdded.
  ///
  /// In en, this message translates to:
  /// **'Address saved.'**
  String get addressAdded;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeItem;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @checkoutDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get checkoutDiscount;

  /// No description provided for @addressDefaultBadge.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get addressDefaultBadge;

  /// No description provided for @accountLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get accountLogout;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSave;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileSaved;

  /// No description provided for @profileEmailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email verified'**
  String get profileEmailVerified;

  /// No description provided for @profileEmailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified'**
  String get profileEmailNotVerified;

  /// No description provided for @ordersEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no orders yet.'**
  String get ordersEmpty;

  /// No description provided for @ordersFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ordersFilterAll;

  /// No description provided for @orderStatusPlaced.
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get orderStatusPlaced;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusDeliveryFailed.
  ///
  /// In en, this message translates to:
  /// **'Delivery failed'**
  String get orderStatusDeliveryFailed;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @orderStatusReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get orderStatusReturned;

  /// No description provided for @orderStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get orderStatusUnknown;

  /// No description provided for @orderDetailCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get orderDetailCancel;

  /// No description provided for @orderCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get orderCancelTitle;

  /// No description provided for @orderCancelReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for cancellation'**
  String get orderCancelReason;

  /// No description provided for @orderCancelReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us briefly why you are cancelling'**
  String get orderCancelReasonHint;

  /// No description provided for @orderCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel the order'**
  String get orderCancelConfirm;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled.'**
  String get orderCancelled;

  /// No description provided for @orderResubmit.
  ///
  /// In en, this message translates to:
  /// **'Resubmit payment proof'**
  String get orderResubmit;

  /// No description provided for @orderResubmitHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the wallet / InstaPay account you sent the transfer from.'**
  String get orderResubmitHint;

  /// No description provided for @orderResubmitted.
  ///
  /// In en, this message translates to:
  /// **'Payment proof resubmitted.'**
  String get orderResubmitted;

  /// No description provided for @orderPaymentRejected.
  ///
  /// In en, this message translates to:
  /// **'Your payment verification was rejected. Check the account you sent from and resubmit.'**
  String get orderPaymentRejected;

  /// No description provided for @orderDetailItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get orderDetailItems;

  /// No description provided for @orderDetailPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get orderDetailPayment;

  /// No description provided for @orderDetailShipment.
  ///
  /// In en, this message translates to:
  /// **'Shipment'**
  String get orderDetailShipment;

  /// No description provided for @orderDetailCancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get orderDetailCancellation;

  /// No description provided for @orderDetailPlacedOn.
  ///
  /// In en, this message translates to:
  /// **'Placed on'**
  String get orderDetailPlacedOn;

  /// No description provided for @orderPaymentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get orderPaymentStatusPending;

  /// No description provided for @orderPaymentStatusPendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Payment pending verification'**
  String get orderPaymentStatusPendingVerification;

  /// No description provided for @orderPaymentStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Payment verification rejected'**
  String get orderPaymentStatusRejected;

  /// No description provided for @orderPaymentStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get orderPaymentStatusPaid;

  /// No description provided for @orderPaymentStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get orderPaymentStatusRefunded;

  /// No description provided for @addressesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No addresses saved yet.'**
  String get addressesEmpty;

  /// No description provided for @addressesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get addressesEdit;

  /// No description provided for @addressesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete address'**
  String get addressesDelete;

  /// No description provided for @addressesDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this address?'**
  String get addressesDeleteConfirm;

  /// No description provided for @addressesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Address deleted.'**
  String get addressesDeleted;

  /// No description provided for @addressesSetDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get addressesSetDefault;

  /// No description provided for @addressesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Address updated.'**
  String get addressesUpdated;

  /// No description provided for @wishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty.'**
  String get wishlistEmpty;

  /// No description provided for @wishlistLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device only — the API has no wishlist yet.'**
  String get wishlistLocalOnly;

  /// No description provided for @wishlistAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to wishlist.'**
  String get wishlistAdded;

  /// No description provided for @wishlistRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from wishlist.'**
  String get wishlistRemoved;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
