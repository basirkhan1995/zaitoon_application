import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Bloc/BackupBloc/database_backup_bloc.dart';
import 'package:zaitoon_invoice/Bloc/DatabaseCubit/database_cubit.dart';
import 'package:zaitoon_invoice/Bloc/LanguageCubit/language_cubit.dart';
import 'package:zaitoon_invoice/Bloc/MenuCubit/General/general_cubit.dart';
import 'package:zaitoon_invoice/Bloc/PasswordCubit/password_cubit.dart';
import 'package:zaitoon_invoice/Bloc/SettingsCubit/cubit/settings_cubit.dart';
import 'package:zaitoon_invoice/Bloc/ThemeCubit/theme_cubit.dart';
import 'package:zaitoon_invoice/DatabaseHelper/repositories.dart';
import 'package:zaitoon_invoice/Themes/themes.dart';
import 'package:zaitoon_invoice/Views/DatabaseView/databases.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Bloc/MenuCubit/MainMenu/menu_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        //Language
        BlocProvider(create: (context) => LanguageCubit()),
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
        //Settings
        BlocProvider(create: (context) => SettingsCubit()),
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
