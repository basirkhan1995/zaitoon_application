import 'package:flutter/material.dart';
import 'package:zaitoon_invoice/Bloc/DatabaseCubit/database_cubit.dart';
import 'package:zaitoon_invoice/Bloc/LanguageCubit/language_cubit.dart';
import 'package:zaitoon_invoice/Bloc/ThemeCubit/theme_cubit.dart';
import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';
import 'package:zaitoon_invoice/Themes/themes.dart';
import 'package:zaitoon_invoice/Views/DatabaseView/databases.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        BlocProvider(create: (context) => DatabaseCubit()),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final theme = AppThemes(TextTheme.of(context));
              return MaterialApp(
                title: 'Zaitoon Invoice',
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
                home: const LoadAllDatabases(),
              );
            },
          );
        },
      ),
    );
  }
}
