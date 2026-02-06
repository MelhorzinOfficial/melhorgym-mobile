import 'package:equatable/equatable.dart';
import 'exercise.dart';

class DailyWorkout extends Equatable {
  final int? id;
  final String dayName;
  final List<Exercise> exercises;

  const DailyWorkout({
    this.id,
    required this.dayName,
    required this.exercises,
  });

  @override
  List<Object?> get props => [id, dayName, exercises];
}
