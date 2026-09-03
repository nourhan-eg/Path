import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/goal_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/user_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_medals_section.dart';
import '../widgets/profile_settings_group.dart';
import '../widgets/profile_stats_grid.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final userProvider = context.read<UserProvider>();
      if (userProvider.user == null && authProvider.currentUser != null) {
        userProvider.loadUser(authProvider.currentUser!.uid);
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        final message =
            e.code == 'channel-error' ||
                e.message?.contains('channel-error') == true
            ? 'Plugin channel added. Please STOP and RESTART the Flutter app completely.'
            : 'Could not select image: ${e.message}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not select image: $e')));
      }
    }
  }

  void _showImagePickerModal(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: colors.primaryGreen,
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: TextStyle(color: colors.textPrimary),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: colors.primaryGreen,
                  ),
                  title: Text(
                    'Take a Photo',
                    style: TextStyle(color: colors.textPrimary),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                if (_profileImage != null)
                  ListTile(
                    leading: Icon(Icons.delete_outline, color: colors.error),
                    title: Text(
                      'Remove Photo',
                      style: TextStyle(color: colors.error),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _profileImage = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final userName = userProvider.displayName;

    return Scaffold(
      appBar: const CustomAppBar(title: "Profile"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              ProfileHeader(
                profileImage: _profileImage,
                userName: userName,
                onAvatarTap: () => _showImagePickerModal(context),
              ),

              const SizedBox(height: 24),

              const ProfileStatsGrid(
                hoursFocused: 124,
                milestonesCount: 15,
                dayStreak: 12,
              ),

              const SizedBox(height: 28),

              ProfileMedalsSection(onViewAllTap: () {}),

              const SizedBox(height: 28),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              ProfileSettingsGroup(
                onAccountDetailsTap: () {},
                onNotificationsTap: () {},
                onLanguageTap: () {
                  final newLocale = context.locale.languageCode == 'en'
                      ? const Locale('ar')
                      : const Locale('en');
                  context.setLocale(newLocale);
                },
                onThemeTap: () {
                  final isDark = themeProvider.themeMode == ThemeMode.dark;
                  themeProvider.toggleTheme(!isDark);
                },
                onSignOutTap: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    context.read<UserProvider>().clearUser();
                    context.read<GoalProvider>().resetDraft();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.loginRoute,
                      (route) => false,
                    );
                  }
                },
                languageText: context.locale.languageCode == 'ar'
                    ? 'العربية'
                    : 'English',
                themeText: themeProvider.themeMode == ThemeMode.dark
                    ? 'Dark'
                    : 'Light',
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
