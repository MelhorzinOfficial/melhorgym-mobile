import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/user.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(user.name ?? user.email);

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: AppTypography.heading1.copyWith(
                color: AppColors.primary,
                fontSize: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name ?? 'Usuário',
          style: AppTypography.heading2,
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }

  String _getInitials(String text) {
    final parts = text.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return text.isNotEmpty ? text[0].toUpperCase() : '?';
  }
}
