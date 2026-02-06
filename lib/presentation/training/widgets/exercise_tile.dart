import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/exercise.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final bool isLast;

  const ExerciseTile({
    super.key,
    required this.exercise,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.divider, width: 0.5),
              ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.circle,
            size: 6,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              exercise.name,
              style: AppTypography.bodyLarge,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.input,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${exercise.sets}x${exercise.reps}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
