import 'package:flutter/material.dart';
import 'package:path_app/core/widgets/custom_bottom_nav_bar.dart';
import 'package:path_app/features/dashboard/screens/dashboard_with_goals.dart';
import 'package:path_app/features/goals/screens/goals_screen.dart';
import 'package:path_app/features/profile/screens/profile_screen.dart';
import 'package:path_app/features/resources/screens/resources_screen.dart';
import 'package:path_app/features/signature_journey/screens/signature_journey.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main';
  final int initialIndex;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _tabs = const [
    DashboardWithGoals(),
    GoalsScreen(),
    SignatureJourney(),
    ResourcesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
