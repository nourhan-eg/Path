import 'package:flutter/material.dart';
import 'package:path_app/core/router/app_router.dart';

class PathApp extends StatelessWidget {
  const PathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PATH',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.onboardingRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
