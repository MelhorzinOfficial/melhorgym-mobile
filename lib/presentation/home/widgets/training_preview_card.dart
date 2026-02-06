import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/training_plan.dart';

class TrainingPreviewCard extends StatelessWidget {
  final TrainingPlan plan;
  final VoidCallback onTap;

  const TrainingPreviewCard({
    super.key,
    required this.plan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final workoutCount = plan.dailyWorkouts.length;
    final exerciseCount = plan.dailyWorkouts.fold<int>(
      0,
      (sum, dw) => sum + dw.exercises.length,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: AppTypography.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$workoutCount dias  ·  $exerciseCount exercícios',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
