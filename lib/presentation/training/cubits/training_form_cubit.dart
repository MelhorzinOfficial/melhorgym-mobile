import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/training_plan.dart';
import '../../../domain/entities/daily_workout.dart';
import '../../../domain/entities/exercise.dart';
import '../../../domain/repositories/training_repository.dart';
import 'training_form_state.dart';

class TrainingFormCubit extends Cubit<TrainingFormState> {
  final TrainingRepository _trainingRepository;

  TrainingFormCubit(this._trainingRepository)
      : super(const TrainingFormState());

  Future<void> loadForEdit(int id) async {
    emit(state.copyWith(status: TrainingFormStatus.loadingForEdit));

    final result = await _trainingRepository.getTrainingById(id);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TrainingFormStatus.error,
          errorMessage: failure.message,
        ));
      },
      (plan) {
        emit(state.copyWith(
          status: TrainingFormStatus.initial,
          existingPlan: plan,
        ));
      },
    );
  }

  Future<void> saveTraining({
    required String name,
    required List<DailyWorkoutFormData> dailyWorkouts,
    int? editId,
  }) async {
    emit(state.copyWith(status: TrainingFormStatus.saving));

    final plan = TrainingPlan(
      name: name,
      dailyWorkouts: dailyWorkouts
          .map((dw) => DailyWorkout(
                dayName: dw.dayName,
                exercises: dw.exercises
                    .map((e) => Exercise(
                          name: e.name,
                          sets: e.sets,
                          reps: e.reps,
                        ))
                    .toList(),
              ))
          .toList(),
    );

    final result = editId != null
        ? await _trainingRepository.updateTraining(editId, plan)
        : await _trainingRepository.createTraining(plan);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TrainingFormStatus.error,
          errorMessage: failure.message,
        ));
      },
      (savedPlan) {
        emit(state.copyWith(status: TrainingFormStatus.saved));
      },
    );
  }
}

class DailyWorkoutFormData {
  String dayName;
  List<ExerciseFormData> exercises;

  DailyWorkoutFormData({
    required this.dayName,
    List<ExerciseFormData>? exercises,
  }) : exercises = exercises ?? [];
}

class ExerciseFormData {
  String name;
  int sets;
  String reps;

  ExerciseFormData({
    required this.name,
    required this.sets,
    required this.reps,
  });
}
