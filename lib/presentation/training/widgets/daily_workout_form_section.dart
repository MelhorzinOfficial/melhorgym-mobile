import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'exercise_form_tile.dart';

class ExerciseControllers {
  final TextEditingController name;
  final TextEditingController sets;
  final TextEditingController reps;

  ExerciseControllers({String? name, String? sets, String? reps})
      : name = TextEditingController(text: name),
        sets = TextEditingController(text: sets),
        reps = TextEditingController(text: reps);

  void dispose() {
    name.dispose();
    sets.dispose();
    reps.dispose();
  }
}

class DailyWorkoutFormSection extends StatelessWidget {
  final int index;
  final TextEditingController dayNameController;
  final List<ExerciseControllers> exerciseControllers;
  final VoidCallback onRemoveDay;
  final VoidCallback onAddExercise;
  final void Function(int) onRemoveExercise;

  const DailyWorkoutFormSection({
    super.key,
    required this.index,
    required this.dayNameController,
    required this.exerciseControllers,
    required this.onRemoveDay,
    required this.onAddExercise,
    required this.onRemoveExercise,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
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
                child: TextFormField(
                  controller: dayNameController,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Nome do dia (ex: Treino A)',
                    filled: true,
                    fillColor: AppColors.input,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onRemoveDay,
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...exerciseControllers.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ExerciseFormTile(
                index: entry.key,
                nameController: entry.value.name,
                setsController: entry.value.sets,
                repsController: entry.value.reps,
                onRemove: () => onRemoveExercise(entry.key),
              ),
            );
          }),
          const SizedBox(height: 4),
          Center(
            child: TextButton.icon(
              onPressed: onAddExercise,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Adicionar exercício'),
            ),
          ),
        ],
      ),
    );
  }
}
