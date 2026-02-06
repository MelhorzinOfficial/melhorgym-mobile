import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/user.dart';

class GreetingHeader extends StatelessWidget {
  final User user;

  const GreetingHeader({super.key, required this.user});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getGreeting()},',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          user.name ?? 'Atleta',
          style: AppTypography.heading1.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
