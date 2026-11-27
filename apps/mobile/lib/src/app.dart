import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/routing/app_router.dart';
import 'package:nest_electro/src/core/theme/app_theme.dart';

/// App root. Arabic (RTL) is the default locale, English is secondary (D-06).
class NestElectroApp extends StatelessWidget {
  const NestElectroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Nest Electro',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: const Locale('ar'),
      supportedLocales: const <Locale>[Locale('ar'), Locale('en')],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
