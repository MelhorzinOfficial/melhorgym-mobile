import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final int? id;
  final String name;
  final int sets;
  final String reps;

  const Exercise({
    this.id,
    required this.name,
    required this.sets,
    required this.reps,
  });

  @override
  List<Object?> get props => [id, name, sets, reps];
}
