import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

/// Renders the profile avatar circle with edit badge, user name, and member subtitle.
class ProfileHeader extends StatelessWidget {
  final File? profileImage;
  final String userName;
  final String memberSince;
  final VoidCallback onAvatarTap;

  const ProfileHeader({
    super.key,
    required this.profileImage,
    required this.userName,
    this.memberSince = '',
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.sageLight.withValues(alpha: 0.4),
                    border: Border.all(
                      color: colors.primaryGreen,
                      width: 2.5,
                    ),
                  ),
                  child: ClipOval(
                    child: profileImage != null
                        ? Image.file(
                            profileImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.person_rounded,
                            size: 58,
                            color: colors.primaryGreen,
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: GestureDetector(
                  onTap: onAvatarTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colors.primaryGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.card, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 14,
                      color: colors.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            memberSince,
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
