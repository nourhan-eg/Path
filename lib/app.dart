import 'package:flutter/material.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/core/theme/app_theme.dart';

class PathApp extends StatelessWidget {
  const PathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PATH',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.onboardingRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
