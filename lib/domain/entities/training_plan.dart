import 'package:equatable/equatable.dart';
import 'daily_workout.dart';

class TrainingPlan extends Equatable {
  final int? id;
  final String name;
  final int? userId;
  final List<DailyWorkout> dailyWorkouts;

  const TrainingPlan({
    this.id,
    required this.name,
    this.userId,
    required this.dailyWorkouts,
  });

  @override
  List<Object?> get props => [id, name, userId, dailyWorkouts];
}
