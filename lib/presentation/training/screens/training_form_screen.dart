import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_decorations.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../cubits/training_form_cubit.dart';
import '../cubits/training_form_state.dart';

class TrainingFormScreen extends StatefulWidget {
  final int? trainingId;

  const TrainingFormScreen({super.key, this.trainingId});

  @override
  State<TrainingFormScreen> createState() => _TrainingFormScreenState();
}

class _TrainingFormScreenState extends State<TrainingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<_DayFormData> _days = [];

  bool get isEditing => widget.trainingId != null;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (!isEditing) {
      _addDay();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final day in _days) {
      day.dispose();
    }
    super.dispose();
  }

  void _addDay() {
    setState(() {
      _days.add(_DayFormData());
    });
  }

  void _removeDay(int index) {
    if (_days.length <= 1) return;
    setState(() {
      _days[index].dispose();
      _days.removeAt(index);
    });
  }

  void _addExercise(int dayIndex) {
    setState(() {
      _days[dayIndex].exercises.add(_ExerciseControllers());
    });
  }

  void _removeExercise(int dayIndex, int exerciseIndex) {
    setState(() {
      _days[dayIndex].exercises[exerciseIndex].dispose();
      _days[dayIndex].exercises.removeAt(exerciseIndex);
    });
  }

  void _initFromPlan(TrainingFormState state) {
    if (_initialized || state.existingPlan == null) return;
    _initialized = true;

    final plan = state.existingPlan!;
    _nameController.text = plan.name;

    for (final dw in plan.dailyWorkouts) {
      final dayData = _DayFormData();
      dayData.dayName.text = dw.dayName;
      for (final ex in dw.exercises) {
        dayData.exercises.add(_ExerciseControllers(
          name: ex.name,
          sets: ex.sets.toString(),
          reps: ex.reps,
        ));
      }
      _days.add(dayData);
    }

    if (_days.isEmpty) _addDay();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    for (int i = 0; i < _days.length; i++) {
      if (_days[i].exercises.isEmpty) {
        Flushbar(
          message: 'Dia ${i + 1} precisa de pelo menos um exercício',
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.card,
          messageColor: AppColors.error,
          icon: const Icon(Icons.warning_rounded, color: AppColors.error),
          margin: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(16),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
        return;
      }
    }

    final dailyWorkouts = _days.map((day) {
      return DailyWorkoutFormData(
        dayName: day.dayName.text.trim(),
        exercises: day.exercises.map((ex) {
          return ExerciseFormData(
            name: ex.name.text.trim(),
            sets: int.parse(ex.sets.text.trim()),
            reps: ex.reps.text.trim(),
          );
        }).toList(),
      );
    }).toList();

    context.read<TrainingFormCubit>().saveTraining(
          name: _nameController.text.trim(),
          dailyWorkouts: dailyWorkouts,
          editId: widget.trainingId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrainingFormCubit, TrainingFormState>(
      listener: (context, state) {
        if (state.status == TrainingFormStatus.saved) {
          context.pop(true);
        } else if (state.status == TrainingFormStatus.error) {
          Flushbar(
            message: state.errorMessage ?? 'Erro ao salvar plano',
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.card,
            messageColor: AppColors.error,
            icon: const Icon(Icons.error_outline, color: AppColors.error),
            margin: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(16),
            flushbarPosition: FlushbarPosition.TOP,
          ).show(context);
        } else if (state.existingPlan != null && !_initialized) {
          _initFromPlan(state);
          setState(() {});
        }
      },
      builder: (context, state) {
        if (state.status == TrainingFormStatus.loadingForEdit) {
          return Scaffold(
            backgroundColor: AppColors.scaffold,
            body: const LoadingIndicator(message: 'Carregando plano...'),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.scaffold,
          body: SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                _buildAppBar(state),
                // Content
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                      children: [
                        // Plan name field
                        _buildPlanNameField(),
                        const SizedBox(height: 28),
                        // Section header
                        Row(
                          children: [
                            Text('Dias de treino',
                                style: AppTypography.heading3),
                            const Spacer(),
                            Text(
                              '${_days.length} dia${_days.length > 1 ? 's' : ''}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Day cards
                        ..._days.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _DayCard(
                              index: entry.key,
                              dayData: entry.value,
                              onRemoveDay: () => _removeDay(entry.key),
                              onAddExercise: () =>
                                  _addExercise(entry.key),
                              onRemoveExercise: (exIndex) =>
                                  _removeExercise(entry.key, exIndex),
                            ),
                          ).animate().fadeIn(
                                duration: 300.ms,
                                delay: (50 * entry.key).ms,
                              );
                        }),
                        const SizedBox(height: 8),
                        // Add day button
                        GestureDetector(
                          onTap: () {
                            lightHaptic();
                            _addDay();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              color:
                                  AppColors.primary.withValues(alpha: 0.04),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_rounded,
                                    color: AppColors.primary, size: 22),
                                const SizedBox(width: 8),
                                Text(
                                  'Adicionar dia de treino',
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Save button
                        _buildSaveButton(state),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(TrainingFormState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              isEditing ? 'Editar plano' : 'Novo plano',
              style: AppTypography.heading2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanNameField() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.edit_rounded,
                    color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Nome do plano',
                  style: AppTypography.heading3.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Ex: Treino de Hipertrofia',
              hintStyle: TextStyle(color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.input,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nome é obrigatório' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(TrainingFormState state) {
    final isSaving = state.status == TrainingFormStatus.saving;

    return GestureDetector(
      onTap: isSaving ? null : () {
        mediumHaptic();
        _onSave();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: isSaving ? null : AppColors.primaryGradient,
          color: isSaving ? AppColors.card : null,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isSaving ? null : primaryGlow(opacity: 0.3, blur: 16),
        ),
        child: Center(
          child: isSaving
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                  ),
                )
              : Text(
                  isEditing ? 'Salvar alterações' : 'Criar plano de treino',
                  style: AppTypography.button.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}

// ─── Day Card ───
class _DayCard extends StatelessWidget {
  final int index;
  final _DayFormData dayData;
  final VoidCallback onRemoveDay;
  final VoidCallback onAddExercise;
  final void Function(int) onRemoveExercise;

  const _DayCard({
    required this.index,
    required this.dayData,
    required this.onRemoveDay,
    required this.onAddExercise,
    required this.onRemoveExercise,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getDayColor(index);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          // Day header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 12, 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.25),
                        color.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTypography.heading3.copyWith(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: dayData.dayName,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Nome do dia (ex: Treino A)',
                      hintStyle: TextStyle(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.input,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: color.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: AppColors.error.withValues(alpha: 0.7), size: 20),
                  onPressed: onRemoveDay,
                ),
              ],
            ),
          ),
          // Exercises
          if (dayData.exercises.isNotEmpty)
            Divider(
                height: 1,
                color: color.withValues(alpha: 0.08)),
          ...dayData.exercises.asMap().entries.map((entry) {
            return _ExerciseFormCard(
              index: entry.key,
              controllers: entry.value,
              color: color,
              onRemove: () => onRemoveExercise(entry.key),
            );
          }),
          // Add exercise button
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
            child: GestureDetector(
              onTap: () {
                lightHaptic();
                onAddExercise();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                  ),
                  borderRadius: BorderRadius.circular(14),
                  color: color.withValues(alpha: 0.04),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, size: 18, color: color),
                    const SizedBox(width: 6),
                    Text(
                      'Adicionar exercício',
                      style: AppTypography.labelSmall.copyWith(color: color),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Exercise Form Card ───
class _ExerciseFormCard extends StatelessWidget {
  final int index;
  final _ExerciseControllers controllers;
  final Color color;
  final VoidCallback onRemove;

  const _ExerciseFormCard({
    required this.index,
    required this.controllers,
    required this.color,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.input,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTypography.bodySmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Exercício ${index + 1}',
                    style: AppTypography.labelSmall),
                const Spacer(),
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: AppColors.error),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Name
            TextFormField(
              controller: controllers.name,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Nome do exercício',
                hintStyle: TextStyle(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.card,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: color.withValues(alpha: 0.4),
                  ),
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Obrigatório'
                  : null,
            ),
            const SizedBox(height: 10),
            // Sets & Reps
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controllers.sets,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Séries',
                      hintStyle:
                          TextStyle(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.card,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.repeat_rounded,
                          size: 18, color: color.withValues(alpha: 0.5)),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Obrigatório';
                      }
                      if (int.tryParse(v.trim()) == null) {
                        return 'Inválido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: controllers.reps,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Repetições',
                      hintStyle:
                          TextStyle(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.card,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.tag_rounded,
                          size: 18, color: color.withValues(alpha: 0.5)),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data Models ───
class _DayFormData {
  final TextEditingController dayName = TextEditingController();
  final List<_ExerciseControllers> exercises = [];

  void dispose() {
    dayName.dispose();
    for (final e in exercises) {
      e.dispose();
    }
  }
}

class _ExerciseControllers {
  final TextEditingController name;
  final TextEditingController sets;
  final TextEditingController reps;

  _ExerciseControllers({String? name, String? sets, String? reps})
      : name = TextEditingController(text: name),
        sets = TextEditingController(text: sets),
        reps = TextEditingController(text: reps);

  void dispose() {
    name.dispose();
    sets.dispose();
    reps.dispose();
  }
}
