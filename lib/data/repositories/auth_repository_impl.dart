import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/user_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;
  final UserRemoteDatasource _userRemoteDatasource;

  AuthRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._userRemoteDatasource,
  );

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDatasource.login(
        email: email,
        password: password,
      );
      await _localDatasource.saveToken(response.token);
      return Right(response.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    String? name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDatasource.register(
        name: name,
        email: email,
        password: password,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await _userRemoteDatasource.getMe();
      return Right(user);
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<void> logout() async {
    await _localDatasource.deleteToken();
  }

  @override
  bool isLoggedIn() {
    return _localDatasource.hasToken();
  }
}
