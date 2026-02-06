import '../../domain/entities/training_plan.dart';
import 'daily_workout_model.dart';
import 'exercise_model.dart';

class TrainingPlanModel extends TrainingPlan {
  const TrainingPlanModel({
    super.id,
    required super.name,
    super.userId,
    required List<DailyWorkoutModel> super.dailyWorkouts,
  });

  factory TrainingPlanModel.fromJson(Map<String, dynamic> json) {
    return TrainingPlanModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      userId: json['userId'] as int?,
      dailyWorkouts: (json['dailyWorkouts'] as List<dynamic>)
          .map((e) => DailyWorkoutModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dailyWorkouts': dailyWorkouts
          .map((dw) => DailyWorkoutModel(
                id: dw.id,
                dayName: dw.dayName,
                exercises: dw.exercises
                    .map((e) => ExerciseModel(
                          id: e.id,
                          name: e.name,
                          sets: e.sets,
                          reps: e.reps,
                        ))
                    .toList(),
              ).toJson())
          .toList(),
    };
  }
}
