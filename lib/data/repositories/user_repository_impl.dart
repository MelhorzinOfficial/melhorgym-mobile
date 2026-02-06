import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource _remoteDatasource;

  UserRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final user = await _remoteDatasource.getMe();
      return Right(user);
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required int id,
    String? name,
    String? email,
    String? password,
  }) async {
    try {
      final user = await _remoteDatasource.updateUser(
        id: id,
        name: name,
        email: email,
        password: password,
      );
      return Right(user);
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(int id) async {
    try {
      await _remoteDatasource.deleteUser(id);
      return const Right(null);
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
