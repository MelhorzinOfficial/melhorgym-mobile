import 'package:equatable/equatable.dart';
import '../../../domain/entities/training_plan.dart';

enum TrainingFormStatus { initial, loading, loadingForEdit, saving, saved, error }

class TrainingFormState extends Equatable {
  final TrainingFormStatus status;
  final TrainingPlan? existingPlan;
  final String? errorMessage;

  const TrainingFormState({
    this.status = TrainingFormStatus.initial,
    this.existingPlan,
    this.errorMessage,
  });

  TrainingFormState copyWith({
    TrainingFormStatus? status,
    TrainingPlan? existingPlan,
    String? errorMessage,
  }) {
    return TrainingFormState(
      status: status ?? this.status,
      existingPlan: existingPlan ?? this.existingPlan,
      errorMessage: errorMessage,
    );
  }

  bool get isEditing => existingPlan != null;

  @override
  List<Object?> get props => [status, existingPlan, errorMessage];
}
