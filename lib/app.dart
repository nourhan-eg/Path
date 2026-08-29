import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/core/theme/app_theme.dart';
import 'package:path_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class PathApp extends StatelessWidget {
  const PathApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'PATH',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: AppRouter.onboardingRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
