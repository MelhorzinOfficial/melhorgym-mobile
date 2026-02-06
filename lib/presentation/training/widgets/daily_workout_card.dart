import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/daily_workout.dart';
import 'exercise_tile.dart';

class DailyWorkoutCard extends StatelessWidget {
  final DailyWorkout workout;
  final int index;

  const DailyWorkoutCard({
    super.key,
    required this.workout,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTypography.label.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    workout.dayName,
                    style: AppTypography.heading3,
                  ),
                ),
                Text(
                  '${workout.exercises.length} exercícios',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ...workout.exercises.asMap().entries.map((entry) {
            return ExerciseTile(
              exercise: entry.value,
              isLast: entry.key == workout.exercises.length - 1,
            );
          }),
        ],
      ),
    );
  }
}
