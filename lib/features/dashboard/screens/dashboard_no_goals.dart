import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_app/core/constants/app_images.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/core/widgets/custom_app_bar.dart';

class DashboardNoGoals extends StatefulWidget {
  static const String routeName = AppRouter.dashboardNoGoalRoute;

  const DashboardNoGoals({super.key});

  @override
  State<DashboardNoGoals> createState() => _DashboardNoGoalsState();
}

class _DashboardNoGoalsState extends State<DashboardNoGoals> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGreen = Theme.of(context).primaryColor;
    final secondaryGreen = Theme.of(context).secondaryHeaderColor;

    return Scaffold(
      appBar: CustomAppBar(title: 'dashboard.title'.tr()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Center(
                child: Image.asset(
                  isDark ? AppImages.cupDark : AppImages.cupLight,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 36),

              Text(
                'dashboard.no_goals_title'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              const SizedBox(height: 12),

              Text(
                'dashboard.no_goals_subtitle'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: secondaryGreen),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: const Color(0xFF1B1D19),
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.goalsSetRoute);
                  },
                  child: Text(
                    'dashboard.set_your_goal'.tr(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: .w400,
                      color: isDark ? Color(0xff243422) : Color(0xffFFFFFF),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
