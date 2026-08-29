import 'package:flutter/material.dart';
import 'package:path_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:path_app/features/goals/screens/goals_screen.dart';
import 'package:path_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:path_app/features/signature_journey/screens/signature_journey.dart';

class AppRouter {
  static const String onboardingRoute = '/onboarding';
  static const String dashboardRoute = '/dashboard';
  static const String signatureJourneyRoute = '/signature_journey';
  static const String goalsRoute = '/goals';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboardingRoute:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case signatureJourneyRoute:
        return MaterialPageRoute(builder: (_) => SignatureJourney());
      case goalsRoute:
        return MaterialPageRoute(builder: (_) => GoalsScreen());
      default:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
    }
  }
}
