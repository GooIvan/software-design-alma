import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @sectionKeywords.
  ///
  /// In en, this message translates to:
  /// **'---------------------------------------------'**
  String get sectionKeywords;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @selectSize.
  ///
  /// In en, this message translates to:
  /// **'Select a size'**
  String get selectSize;

  /// No description provided for @sizesAvailable.
  ///
  /// In en, this message translates to:
  /// **'Sizes available'**
  String get sizesAvailable;

  /// No description provided for @noSizes.
  ///
  /// In en, this message translates to:
  /// **'No sizes available'**
  String get noSizes;

  /// No description provided for @noImage.
  ///
  /// In en, this message translates to:
  /// **'No image'**
  String get noImage;

  /// No description provided for @aggProductToCart.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart'**
  String get aggProductToCart;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProducts;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategories;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @configuration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signin;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error, please try again.'**
  String get unknownError;

  /// No description provided for @functionalityNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Functionality not implemented'**
  String get functionalityNotImplemented;

  /// No description provided for @see.
  ///
  /// In en, this message translates to:
  /// **'See'**
  String get see;

  /// No description provided for @sectionHome.
  ///
  /// In en, this message translates to:
  /// **'---------------------------------------------'**
  String get sectionHome;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Design Alma'**
  String get appTitle;

  /// No description provided for @homeNewest.
  ///
  /// In en, this message translates to:
  /// **'New Arrivals'**
  String get homeNewest;

  /// No description provided for @homeErrorMessageProducts.
  ///
  /// In en, this message translates to:
  /// **'Error loading products'**
  String get homeErrorMessageProducts;

  /// No description provided for @homeErrorMessageCategories.
  ///
  /// In en, this message translates to:
  /// **'Error loading categories'**
  String get homeErrorMessageCategories;

  /// No description provided for @sectionFavorites.
  ///
  /// In en, this message translates to:
  /// **'---------------------------------------------'**
  String get sectionFavorites;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'Your favorites list is empty'**
  String get noFavorites;

  /// No description provided for @messageNoFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add products to favorites to see them here.'**
  String get messageNoFavorites;

  /// No description provided for @sectionProfile.
  ///
  /// In en, this message translates to:
  /// **'---------------------------------------------'**
  String get sectionProfile;

  /// No description provided for @profileErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get profileErrorMessage;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @guestMessage1.
  ///
  /// In en, this message translates to:
  /// **'Did you know you can access more features?'**
  String get guestMessage1;

  /// No description provided for @guestMessage2.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your account, orders and more.'**
  String get guestMessage2;

  /// No description provided for @sectionLogin.
  ///
  /// In en, this message translates to:
  /// **'---------------------------------------------'**
  String get sectionLogin;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginTitle;

  /// No description provided for @loginMessage.
  ///
  /// In en, this message translates to:
  /// **'log in to your account'**
  String get loginMessage;

  /// No description provided for @inputEmail.
  ///
  /// In en, this message translates to:
  /// **'enter your email'**
  String get inputEmail;

  /// No description provided for @inputPassword.
  ///
  /// In en, this message translates to:
  /// **'enter your password'**
  String get inputPassword;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get validationEmail;

  /// No description provided for @validationPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get validationPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @continueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueGoogle;

  /// No description provided for @continueFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueFacebook;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @loginIncorrectParameters.
  ///
  /// In en, this message translates to:
  /// **'Incorrect parameters, please check and try again.'**
  String get loginIncorrectParameters;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @sectionRegister.
  ///
  /// In en, this message translates to:
  /// **'---------------------------------------------'**
  String get sectionRegister;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Design Alma'**
  String get registerTitle;

  /// No description provided for @registerMessage.
  ///
  /// In en, this message translates to:
  /// **'create your account to get started'**
  String get registerMessage;

  /// No description provided for @registerInputName.
  ///
  /// In en, this message translates to:
  /// **'enter your first name'**
  String get registerInputName;

  /// No description provided for @validationName.
  ///
  /// In en, this message translates to:
  /// **'First name is required.'**
  String get validationName;

  /// No description provided for @registerInputLastName.
  ///
  /// In en, this message translates to:
  /// **'enter your last name'**
  String get registerInputLastName;

  /// No description provided for @validationLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name is required.'**
  String get validationLastName;

  /// No description provided for @registerInputCity.
  ///
  /// In en, this message translates to:
  /// **'enter your city'**
  String get registerInputCity;

  /// No description provided for @validationCity.
  ///
  /// In en, this message translates to:
  /// **'City is required.'**
  String get validationCity;

  /// No description provided for @registerInputPhone.
  ///
  /// In en, this message translates to:
  /// **'enter your phone number'**
  String get registerInputPhone;

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required.'**
  String get validationPhone;

  /// No description provided for @registerInputAddress.
  ///
  /// In en, this message translates to:
  /// **'enter your address'**
  String get registerInputAddress;

  /// No description provided for @validationAddress.
  ///
  /// In en, this message translates to:
  /// **'Address is required.'**
  String get validationAddress;

  /// No description provided for @registerInputPassword.
  ///
  /// In en, this message translates to:
  /// **'enter your password'**
  String get registerInputPassword;

  /// No description provided for @validationRegisterPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get validationRegisterPassword;

  /// No description provided for @registerInputConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'confirm your password'**
  String get registerInputConfirmPassword;

  /// No description provided for @validationConfirmPasswordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationConfirmPasswordNotMatch;

  /// No description provided for @validationConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password.'**
  String get validationConfirmPassword;

  /// No description provided for @registerInputEmail.
  ///
  /// In en, this message translates to:
  /// **'enter your email'**
  String get registerInputEmail;

  /// No description provided for @validationRegisterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get validationRegisterEmail;

  /// No description provided for @yesAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get yesAccount;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'The email is already in use.'**
  String get emailInUse;

  /// No description provided for @passwordsNotValid.
  ///
  /// In en, this message translates to:
  /// **'invalid password'**
  String get passwordsNotValid;

  /// No description provided for @nameNotValid.
  ///
  /// In en, this message translates to:
  /// **'You must enter a valid name.'**
  String get nameNotValid;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registerSuccess;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'---------------------------------------------'**
  String get sectionAbout;

  /// No description provided for @titleDoc.
  ///
  /// In en, this message translates to:
  /// **'Project Documentation'**
  String get titleDoc;

  /// No description provided for @contributors.
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get contributors;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
