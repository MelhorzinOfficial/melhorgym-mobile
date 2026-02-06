import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/training_repository.dart';
import 'training_detail_state.dart';

class TrainingDetailCubit extends Cubit<TrainingDetailState> {
  final TrainingRepository _trainingRepository;

  TrainingDetailCubit(this._trainingRepository)
      : super(const TrainingDetailState());

  Future<void> loadTraining(int id) async {
    emit(state.copyWith(status: TrainingDetailStatus.loading));

    final result = await _trainingRepository.getTrainingById(id);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TrainingDetailStatus.error,
          errorMessage: failure.message,
        ));
      },
      (plan) {
        emit(state.copyWith(
          status: TrainingDetailStatus.loaded,
          plan: plan,
        ));
      },
    );
  }

  Future<void> deleteTraining(int id) async {
    final result = await _trainingRepository.deleteTraining(id);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TrainingDetailStatus.error,
          errorMessage: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(status: TrainingDetailStatus.deleted));
      },
    );
  }
}
