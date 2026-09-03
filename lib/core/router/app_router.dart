import 'package:flutter/material.dart';
import 'package:path_app/features/auth/screens/login_screen.dart';
import 'package:path_app/features/auth/screens/register_screen.dart';
import 'package:path_app/features/dashboard/screens/dashboard_no_goals.dart';
import 'package:path_app/features/dashboard/screens/dashboard_with_goals.dart';
import 'package:path_app/features/goals/screens/build_with_ai_screen.dart';
import 'package:path_app/features/goals/screens/goal_details_screen.dart';
import 'package:path_app/features/goals/screens/set_goal_screen.dart';
import 'package:path_app/features/main/main_screen.dart';
import 'package:path_app/features/onboarding/screens/onboarding_screen.dart';

import '../../features/session/session_screen.dart';

class AppRouter {
  static const String mainRoute = '/main';
  static const String onboardingRoute = '/onboarding';
  static const String dashboardWishGoalRoute = '/dashboard_with';
  static const String signatureJourneyRoute = '/signature_journey';
  static const String goalsSetRoute = '/goals set';
  static const String goalsRoute = '/goals';
  static const String goalsWithAiRoute = '/goals ai';
  static const String goalDetailsRoute = '/goal_details';
  static const String registerRoute = '/register';
  static const String loginRoute = '/login';
  static const String dashboardNoGoalRoute = '/dashboard_no';
  static const String sessionRoute = '/session';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainRoute:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case dashboardNoGoalRoute:
        return MaterialPageRoute(builder: (_) => const DashboardNoGoals());
      case dashboardWishGoalRoute:
        return MaterialPageRoute(builder: (_) => const DashboardWithGoals());
      case goalsSetRoute:
        return MaterialPageRoute(builder: (_) => const SetGoalsScreen());
      case signatureJourneyRoute:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(initialIndex: 2),
        );
      case onboardingRoute:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case goalsWithAiRoute:
        return MaterialPageRoute(builder: (_) => BuildWithAiScreen());
      case goalDetailsRoute:
        return MaterialPageRoute(
          builder: (_) => const GoalDetailsScreen(),
          settings: settings,
        );
      case sessionRoute:
        return MaterialPageRoute(builder: (_) => SessionScreen());
      default:
        return MaterialPageRoute(builder: (_) => const MainScreen());
    }
  }
}
