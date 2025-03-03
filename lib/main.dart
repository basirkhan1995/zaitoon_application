import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zaitoon_invoice/Bloc/AccountsCubit/AccountCategory/account_category_cubit.dart';
import 'package:zaitoon_invoice/Bloc/AccountsCubit/accounts_cubit.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Bloc/BackupBloc/database_backup_bloc.dart';
import 'package:zaitoon_invoice/Bloc/CurrencyCubit/Currency/currency_cubit.dart';
import 'package:zaitoon_invoice/Bloc/DatabaseCubit/database_cubit.dart';
import 'package:zaitoon_invoice/Bloc/EstimateBloc/bloc/estimate_bloc.dart';
import 'package:zaitoon_invoice/Bloc/EstimateCubit/estimate_cubit.dart';
import 'package:zaitoon_invoice/Bloc/InvoiceCubit/cubit/invoice_cubit.dart';
import 'package:zaitoon_invoice/Bloc/LanguageCubit/PDF/pdf_language_cubit.dart';
import 'package:zaitoon_invoice/Bloc/LanguageCubit/language_cubit.dart';
import 'package:zaitoon_invoice/Bloc/MenuCubit/General/general_cubit.dart';
import 'package:zaitoon_invoice/Bloc/PasswordCubit/password_cubit.dart';
import 'package:zaitoon_invoice/Bloc/Printer/printer_cubit.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/Categories/product_category_cubit.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/Inventory/inventory_cubit.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/Units/units_cubit.dart';
import 'package:zaitoon_invoice/Bloc/ProductsCubit/products_cubit.dart';
import 'package:zaitoon_invoice/Bloc/ThemeCubit/theme_cubit.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Themes/themes.dart';
import 'package:zaitoon_invoice/Views/DatabaseView/databases.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Estimate/PDF/pdf.dart';
import 'Bloc/MenuCubit/MainMenu/menu_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Pdf.loadPersianFont(); // Load Persian Font
  await Pdf.loadEnglishFont(); // Load English Font

  if (Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    windowManager.setMinimumSize(const Size(750, 500));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => EstimateCubit()),
        //Language
        BlocProvider(create: (context) => LanguageCubit()),
        //PDF Language
        BlocProvider(create: (context) => PDFLanguageCubit()),
        //Printer Cubit
        BlocProvider(create: (context) => PrinterCubit()),
        //Theme
        BlocProvider(create: (context) => ThemeCubit()),
        //Database Cubit
        BlocProvider(create: (context) => DatabaseCubit()..loadDatabaseEvent()),
        //Auth Cubit
        BlocProvider(create: (context) => AuthCubit(Repositories())),
        //Side Menu Cubit
        BlocProvider(
            create: (context) => MenuCubit()..onChangedEvent(index: 0)),
        // General settings Menu Cubit
        BlocProvider(
            create: (context) => GeneralCubit()..onChangedEvent(index: 0)),
        //Password
        BlocProvider(create: (context) => PasswordCubit(Repositories())),
        //Backup
        BlocProvider(create: (context) => BackupBloc()),
        //Account Categories
        BlocProvider(
            create: (context) => AccountCategoryCubit(Repositories())
              ..loadAccountCategoriesEvent()),
        //Accounts
        BlocProvider(
            create: (context) =>
                AccountsCubit(Repositories())..loadAccountsEvent()),
        //Products
        BlocProvider(
            create: (context) =>
                ProductsCubit(Repositories())..loadProductsEvent()),
        BlocProvider(
            create: (context) => ProductCategoryCubit(Repositories())
              ..loadProductCategoryEvent()),
        BlocProvider(
            create: (context) =>
                UnitsCubit(Repositories())..loadProductUnitEvent()),
        //Currencies
        BlocProvider(
            create: (context) =>
                CurrencyCubit(Repositories())..loadCurrenciesEvent()),
        //Currencies
        BlocProvider(
            create: (context) =>
                InventoryCubit(Repositories())..loadInventoryEvent()),
        BlocProvider(
            create: (context) => EstimateBloc()..add(LoadItemsEvent())),
        BlocProvider(create: (context) => InvoiceCubit()),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final theme = AppThemes(TextTheme.of(context));
              return MaterialApp(
                title: 'Zaitoon System',
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  Locale('en'), // English
                  Locale('fa'), // Persian
                  Locale('ar') //  Pashto
                ],
                locale: locale,
                themeMode: themeMode,
                darkTheme: theme.dark(),
                theme: theme.light(),
                home: const DatabaseManager(),
              );
            },
          );
        },
      ),
    );
  }
}
