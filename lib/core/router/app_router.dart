import 'package:flutter/material.dart';
import 'package:path_app/features/auth/screens/login_screen.dart';
import 'package:path_app/features/auth/screens/register_screen.dart';
import 'package:path_app/features/dashboard/screens/dashboard_with_goals.dart';
import 'package:path_app/features/goals/screens/goals_screen.dart';
import 'package:path_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:path_app/features/signature_journey/screens/signature_journey.dart';

import '../../features/dashboard/screens/dashboard_no_goals.dart';

class AppRouter {
  static const String onboardingRoute = '/onboarding';
  static const String dashboardWishGoalRoute = '/dashboard_with';
  static const String signatureJourneyRoute = '/signature_journey';
  static const String goalsRoute = '/goals';
  static const String registerRoute = '/register';
  static const String loginRoute = '/login';
  static const String dashboardNoGoalRoute = '/dashboard_no';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboardingRoute:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case dashboardWishGoalRoute:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case signatureJourneyRoute:
        return MaterialPageRoute(builder: (_) => SignatureJourney());
      case goalsRoute:
        return MaterialPageRoute(builder: (_) => GoalsScreen());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case dashboardNoGoalRoute:
        return MaterialPageRoute(builder: (_) => DashboardNoGoals());
      default:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
    }
  }
}
