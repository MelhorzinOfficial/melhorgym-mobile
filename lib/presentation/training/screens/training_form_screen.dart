import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../cubits/training_form_cubit.dart';
import '../cubits/training_form_state.dart';
import '../widgets/daily_workout_form_section.dart';

class TrainingFormScreen extends StatefulWidget {
  final int? trainingId;

  const TrainingFormScreen({super.key, this.trainingId});

  @override
  State<TrainingFormScreen> createState() => _TrainingFormScreenState();
}

class _TrainingFormScreenState extends State<TrainingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  // Each day has: dayNameController + list of ExerciseControllers
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
      _days[dayIndex].exercises.add(ExerciseControllers());
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
        dayData.exercises.add(ExerciseControllers(
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

    // Check that each day has at least one exercise
    for (int i = 0; i < _days.length; i++) {
      if (_days[i].exercises.isEmpty) {
        Flushbar(
          message: 'Dia ${i + 1} precisa de pelo menos um exercício',
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.error,
          margin: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(12),
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
            backgroundColor: AppColors.error,
            margin: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(12),
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
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => context.pop(),
              ),
            ),
            body: const LoadingIndicator(message: 'Carregando plano...'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
            ),
            title: Text(
              isEditing ? 'Editar plano' : 'Novo plano',
              style: AppTypography.heading2,
            ),
            actions: [
              TextButton(
                onPressed:
                    state.status == TrainingFormStatus.saving ? null : _onSave,
                child: state.status == TrainingFormStatus.saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : Text(
                        'Salvar',
                        style: AppTypography.label.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Nome do plano de treino',
                    labelText: 'Nome do plano',
                    prefixIcon: Icon(Icons.edit_outlined, size: 20),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nome é obrigatório' : null,
                ),
                const SizedBox(height: 24),
                Text('Dias de treino', style: AppTypography.heading3),
                const SizedBox(height: 14),
                ..._days.asMap().entries.map((entry) {
                  final dayIndex = entry.key;
                  final day = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: DailyWorkoutFormSection(
                      index: dayIndex,
                      dayNameController: day.dayName,
                      exerciseControllers: day.exercises,
                      onRemoveDay: () => _removeDay(dayIndex),
                      onAddExercise: () => _addExercise(dayIndex),
                      onRemoveExercise: (exIndex) =>
                          _removeExercise(dayIndex, exIndex),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _addDay,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar dia de treino'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed:
                      state.status == TrainingFormStatus.saving ? null : _onSave,
                  child: state.status == TrainingFormStatus.saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.scaffold,
                          ),
                        )
                      : Text(isEditing ? 'Salvar alterações' : 'Criar plano'),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DayFormData {
  final TextEditingController dayName = TextEditingController();
  final List<ExerciseControllers> exercises = [];

  void dispose() {
    dayName.dispose();
    for (final e in exercises) {
      e.dispose();
    }
  }
}
