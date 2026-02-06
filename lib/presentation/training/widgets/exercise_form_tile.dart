import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ExerciseFormTile extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController setsController;
  final TextEditingController repsController;
  final VoidCallback onRemove;
  final int index;

  const ExerciseFormTile({
    super.key,
    required this.nameController,
    required this.setsController,
    required this.repsController,
    required this.onRemove,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.input,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Exercício ${index + 1}',
                style: AppTypography.labelSmall,
              ),
              const Spacer(),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: nameController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Nome do exercício',
              filled: true,
              fillColor: AppColors.card,
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
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: setsController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Séries',
                    filled: true,
                    fillColor: AppColors.card,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Obrigatório';
                    if (int.tryParse(v) == null) return 'Número';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: repsController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Reps (ex: 8-10)',
                    filled: true,
                    fillColor: AppColors.card,
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
            ],
          ),
        ],
      ),
    );
  }
}
