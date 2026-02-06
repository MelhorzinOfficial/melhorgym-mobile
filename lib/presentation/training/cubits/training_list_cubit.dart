import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/training_repository.dart';
import 'training_list_state.dart';

class TrainingListCubit extends Cubit<TrainingListState> {
  final TrainingRepository _trainingRepository;

  TrainingListCubit(this._trainingRepository)
      : super(const TrainingListState());

  Future<void> loadTrainings() async {
    emit(state.copyWith(status: TrainingListStatus.loading));

    final result = await _trainingRepository.getTrainings();
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TrainingListStatus.error,
          errorMessage: failure.message,
        ));
      },
      (plans) {
        emit(state.copyWith(
          status: TrainingListStatus.loaded,
          plans: plans,
        ));
      },
    );
  }

  Future<void> deleteTraining(int id) async {
    final result = await _trainingRepository.deleteTraining(id);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TrainingListStatus.error,
          errorMessage: failure.message,
        ));
      },
      (_) {
        final updatedPlans =
            state.plans.where((p) => p.id != id).toList();
        emit(state.copyWith(
          status: TrainingListStatus.loaded,
          plans: updatedPlans,
        ));
      },
    );
  }
}
