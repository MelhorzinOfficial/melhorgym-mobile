import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/training_plan.dart';
import '../../domain/repositories/training_repository.dart';
import '../datasources/training_remote_datasource.dart';
import '../models/training_plan_model.dart';
import '../models/daily_workout_model.dart';
import '../models/exercise_model.dart';

class TrainingRepositoryImpl implements TrainingRepository {
  final TrainingRemoteDatasource _remoteDatasource;

  TrainingRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<TrainingPlan>>> getTrainings() async {
    try {
      final trainings = await _remoteDatasource.getTrainings();
      return Right(trainings);
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, TrainingPlan>> getTrainingById(int id) async {
    try {
      final training = await _remoteDatasource.getTrainingById(id);
      return Right(training);
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, TrainingPlan>> createTraining(TrainingPlan plan) async {
    try {
      final model = _toModel(plan);
      final created = await _remoteDatasource.createTraining(model);
      return Right(created);
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, TrainingPlan>> updateTraining(int id, TrainingPlan plan) async {
    try {
      final model = _toModel(plan);
      final updated = await _remoteDatasource.updateTraining(id, model);
      return Right(updated);
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTraining(int id) async {
    try {
      await _remoteDatasource.deleteTraining(id);
      return const Right(null);
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  TrainingPlanModel _toModel(TrainingPlan plan) {
    return TrainingPlanModel(
      id: plan.id,
      name: plan.name,
      userId: plan.userId,
      dailyWorkouts: plan.dailyWorkouts
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
              ))
          .toList(),
    );
  }
}
