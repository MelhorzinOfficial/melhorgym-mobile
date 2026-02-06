import '../../domain/entities/daily_workout.dart';
import 'exercise_model.dart';

class DailyWorkoutModel extends DailyWorkout {
  const DailyWorkoutModel({
    super.id,
    required super.dayName,
    required List<ExerciseModel> super.exercises,
  });

  factory DailyWorkoutModel.fromJson(Map<String, dynamic> json) {
    return DailyWorkoutModel(
      id: json['id'] as int?,
      dayName: json['dayName'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayName': dayName,
      'exercises': exercises
          .map((e) => ExerciseModel(
                id: e.id,
                name: e.name,
                sets: e.sets,
                reps: e.reps,
              ).toJson())
          .toList(),
    };
  }
}
