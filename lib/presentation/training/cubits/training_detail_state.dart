import 'package:equatable/equatable.dart';
import '../../../domain/entities/training_plan.dart';

enum TrainingDetailStatus { initial, loading, loaded, error, deleted }

class TrainingDetailState extends Equatable {
  final TrainingDetailStatus status;
  final TrainingPlan? plan;
  final String? errorMessage;

  const TrainingDetailState({
    this.status = TrainingDetailStatus.initial,
    this.plan,
    this.errorMessage,
  });

  TrainingDetailState copyWith({
    TrainingDetailStatus? status,
    TrainingPlan? plan,
    String? errorMessage,
  }) {
    return TrainingDetailState(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, plan, errorMessage];
}
