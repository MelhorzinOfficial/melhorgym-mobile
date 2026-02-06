import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class QuickStatsCard extends StatelessWidget {
  final int totalPlans;
  final int totalWorkouts;
  final int totalExercises;

  const QuickStatsCard({
    super.key,
    required this.totalPlans,
    required this.totalWorkouts,
    required this.totalExercises,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.list_alt,
            value: totalPlans.toString(),
            label: 'Planos',
          ),
          Container(
            height: 40,
            width: 1,
            color: AppColors.divider,
          ),
          _StatItem(
            icon: Icons.calendar_today,
            value: totalWorkouts.toString(),
            label: 'Treinos',
          ),
          Container(
            height: 40,
            width: 1,
            color: AppColors.divider,
          ),
          _StatItem(
            icon: Icons.fitness_center,
            value: totalExercises.toString(),
            label: 'Exercícios',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(value, style: AppTypography.heading2),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}
