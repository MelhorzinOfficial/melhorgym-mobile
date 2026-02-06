import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/training_plan.dart';

abstract class TrainingRepository {
  Future<Either<Failure, List<TrainingPlan>>> getTrainings();

  Future<Either<Failure, TrainingPlan>> getTrainingById(int id);

  Future<Either<Failure, TrainingPlan>> createTraining(TrainingPlan plan);

  Future<Either<Failure, TrainingPlan>> updateTraining(int id, TrainingPlan plan);

  Future<Either<Failure, void>> deleteTraining(int id);
}
