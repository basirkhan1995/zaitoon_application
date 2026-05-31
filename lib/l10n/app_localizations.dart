import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('fa')
  ];

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String required(String fieldName);

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(String name);

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @invoice_total.
  ///
  /// In en, this message translates to:
  /// **'Invoice Total'**
  String get invoice_total;

  /// No description provided for @databases.
  ///
  /// In en, this message translates to:
  /// **'Databases'**
  String get databases;

  /// No description provided for @newDatabase.
  ///
  /// In en, this message translates to:
  /// **'New Database'**
  String get newDatabase;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @recentDatabases.
  ///
  /// In en, this message translates to:
  /// **'Recent Databases'**
  String get recentDatabases;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @accessDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Username or password is incorrect'**
  String get accessDeniedMessage;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found.'**
  String get userNotFound;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get incorrectPassword;

  /// No description provided for @userInactive.
  ///
  /// In en, this message translates to:
  /// **'User account is inactive.'**
  String get userInactive;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful.'**
  String get loginSuccess;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @estimate.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get estimate;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @editor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get editor;

  /// No description provided for @viewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get viewer;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get report;

  /// No description provided for @database.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get database;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @invoiceSettings.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoiceSettings;

  /// No description provided for @databaseSettings.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get databaseSettings;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSettings;

  /// No description provided for @systemSettings.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemSettings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get logoutMessage;

  /// No description provided for @ignore.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get ignore;

  /// No description provided for @alertTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get alertTitle;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you wanna delete?'**
  String get deleteMessage;

  /// No description provided for @removeMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you wanna remove?'**
  String get removeMessage;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Password is not verified'**
  String get passwordErrorMessage;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get update;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match!'**
  String get passwordNotMatch;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get confirmPassword;

  /// No description provided for @passwordSettingHint.
  ///
  /// In en, this message translates to:
  /// **'Verify your current password'**
  String get passwordSettingHint;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @mobile2.
  ///
  /// In en, this message translates to:
  /// **'Mobile 2'**
  String get mobile2;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get businessName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'EDIT'**
  String get edit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @backupMessage.
  ///
  /// In en, this message translates to:
  /// **'Backup successfully'**
  String get backupMessage;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'QTY'**
  String get qty;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax %'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get discount;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice number'**
  String get invoiceNumber;

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer not found'**
  String get customerNotFound;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @invoiceDate.
  ///
  /// In en, this message translates to:
  /// **'Invoice date'**
  String get invoiceDate;

  /// No description provided for @newEstimate.
  ///
  /// In en, this message translates to:
  /// **'New Estimate'**
  String get newEstimate;

  /// No description provided for @duplicateProductMessage.
  ///
  /// In en, this message translates to:
  /// **'Product already exists'**
  String get duplicateProductMessage;

  /// No description provided for @vat.
  ///
  /// In en, this message translates to:
  /// **'Vat'**
  String get vat;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @termsAndCondition.
  ///
  /// In en, this message translates to:
  /// **'Terms & Condition'**
  String get termsAndCondition;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get action;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'CREATE'**
  String get create;

  /// No description provided for @sellPrice.
  ///
  /// In en, this message translates to:
  /// **'Sell Price'**
  String get sellPrice;

  /// No description provided for @buyPrice.
  ///
  /// In en, this message translates to:
  /// **'Buy Price'**
  String get buyPrice;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @newProductTitle.
  ///
  /// In en, this message translates to:
  /// **'NEW PRODUCT'**
  String get newProductTitle;

  /// No description provided for @serialNumber.
  ///
  /// In en, this message translates to:
  /// **'SerialNumber'**
  String get serialNumber;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get step1;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'Step 2'**
  String get step2;

  /// No description provided for @step3.
  ///
  /// In en, this message translates to:
  /// **'Step 3'**
  String get step3;

  /// No description provided for @userAccount.
  ///
  /// In en, this message translates to:
  /// **'User Account'**
  String get userAccount;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @databaseName.
  ///
  /// In en, this message translates to:
  /// **'Database Name'**
  String get databaseName;

  /// No description provided for @registerCompany.
  ///
  /// In en, this message translates to:
  /// **'Company Registration'**
  String get registerCompany;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @printPreview.
  ///
  /// In en, this message translates to:
  /// **'Print preview'**
  String get printPreview;

  /// No description provided for @printer.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get printer;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountName;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @newAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newAccountTitle;

  /// No description provided for @searchAccounts.
  ///
  /// In en, this message translates to:
  /// **'Search accounts'**
  String get searchAccounts;

  /// No description provided for @noAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'No Account found'**
  String get noAccountMessage;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No Products Available'**
  String get noProducts;

  /// No description provided for @productSearch.
  ///
  /// In en, this message translates to:
  /// **'Search Products'**
  String get productSearch;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get inventory;

  /// No description provided for @averagePrice.
  ///
  /// In en, this message translates to:
  /// **'Avg Price'**
  String get averagePrice;

  /// No description provided for @newKeyword.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newKeyword;

  /// No description provided for @currency_code.
  ///
  /// In en, this message translates to:
  /// **'Currency Code'**
  String get currency_code;

  /// No description provided for @currnecy_symbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get currnecy_symbol;

  /// No description provided for @currency_name.
  ///
  /// In en, this message translates to:
  /// **'Currency name'**
  String get currency_name;

  /// No description provided for @newCurrency.
  ///
  /// In en, this message translates to:
  /// **'New Currency'**
  String get newCurrency;
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
      <String>['ar', 'en', 'fa'].contains(locale.languageCode);

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
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
