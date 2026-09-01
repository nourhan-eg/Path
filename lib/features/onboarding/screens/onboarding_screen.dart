import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_app/core/constants/app_images.dart';
import 'package:path_app/core/router/app_router.dart';
import 'package:path_app/core/theme/app_color.dart';
import 'package:path_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors =
        Theme.of(context).extension<AppColorScheme>() ?? AppColorScheme.light;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 48),

              // ── Title ──
              Text(
                'onboarding.title'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),

              // ── Illustration ──
              Flexible(
                child: Image.asset(
                  isDark
                      ? AppImages.onboardingPathDark
                      : AppImages.onboardingPathLight,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),

              // ── Description ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'onboarding.description'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 24),

              // ── Language & Theme Controls ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLanguageToggle(context, colors),
                    _buildThemeToggle(context, colors, isDark),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Get Started Button ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.loginRoute);
                    },
                    child: Text('onboarding.start_button'.tr()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageToggle(BuildContext context, AppColorScheme colors) {
    return GestureDetector(
      onTap: () {
        final currentLocale = context.locale;
        final newLocale = currentLocale.languageCode == 'en'
            ? const Locale('ar')
            : const Locale('en');
        context.setLocale(newLocale);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, size: 18, color: colors.textSecondary),
            const SizedBox(width: 6),
            Text(
              tr('onboarding.language'),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  /// A segmented-style toggle that clearly indicates the active theme mode.
  Widget _buildThemeToggle(
    BuildContext context,
    AppColorScheme colors,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThemeOption(
            context: context,
            colors: colors,
            icon: Icons.wb_sunny_outlined,
            isActive: !isDark,
            onTap: () => context.read<ThemeProvider>().toggleTheme(false),
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(7),
            ),
          ),
          _buildThemeOption(
            context: context,
            colors: colors,
            icon: Icons.dark_mode_outlined,
            isActive: isDark,
            onTap: () => context.read<ThemeProvider>().toggleTheme(true),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required AppColorScheme colors,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required BorderRadius borderRadius,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? colors.primaryGreen : Colors.transparent,
          borderRadius: borderRadius,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? colors.onPrimary : colors.textSecondary,
        ),
      ),
    );
  }
}
