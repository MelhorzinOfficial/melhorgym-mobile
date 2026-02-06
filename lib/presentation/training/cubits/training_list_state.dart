import 'package:equatable/equatable.dart';
import '../../../domain/entities/training_plan.dart';

enum TrainingListStatus { initial, loading, loaded, error }

class TrainingListState extends Equatable {
  final TrainingListStatus status;
  final List<TrainingPlan> plans;
  final String? errorMessage;

  const TrainingListState({
    this.status = TrainingListStatus.initial,
    this.plans = const [],
    this.errorMessage,
  });

  TrainingListState copyWith({
    TrainingListStatus? status,
    List<TrainingPlan>? plans,
    String? errorMessage,
  }) {
    return TrainingListState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, plans, errorMessage];
}
