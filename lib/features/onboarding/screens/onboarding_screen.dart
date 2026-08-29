import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 48),
            Text(
              'onboarding.title'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),

            Image.asset(
              isDark
                  ? 'assets/images/onboarding_path_dark.png'
                  : 'assets/images/onboarding_path_light.png',
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'onboarding.description'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      final currentLocale = context.locale;
                      final newLocale = currentLocale.languageCode == 'en'
                          ? const Locale('ar')
                          : const Locale('en');
                      context.setLocale(newLocale);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.language,
                          size: 18,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tr('onboarding.language'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.wb_sunny_outlined,
                          size: 18,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        onPressed: () {
                          context.read<ThemeProvider>().toggleTheme(false);
                        },
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(
                          Icons.dark_mode_outlined,
                          size: 18,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        onPressed: () {
                          context.read<ThemeProvider>().toggleTheme(true);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.dashboardRoute);
                  },
                  child: Text('onboarding.start_button'.tr()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
