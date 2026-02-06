import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/network/api_client.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/user_remote_datasource.dart';
import 'data/datasources/training_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/training_repository_impl.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/auth/bloc/auth_event.dart';
import 'presentation/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local storage
  final prefs = await SharedPreferences.getInstance();
  final authLocalDatasource = AuthLocalDatasource(prefs);

  // Network
  final apiClient = ApiClient(authLocalDatasource);
  final dio = apiClient.dio;

  // Remote datasources
  final authRemoteDatasource = AuthRemoteDatasource(dio);
  final userRemoteDatasource = UserRemoteDatasource(dio);
  final trainingRemoteDatasource = TrainingRemoteDatasource(dio);

  // Repositories
  final authRepository = AuthRepositoryImpl(
    authRemoteDatasource,
    authLocalDatasource,
    userRemoteDatasource,
  );
  final userRepository = UserRepositoryImpl(userRemoteDatasource);
  final trainingRepository = TrainingRepositoryImpl(trainingRemoteDatasource);

  // BLoC
  final authBloc = AuthBloc(authRepository)..add(const AuthCheckRequested());

  // Router
  final appRouter = AppRouter(
    authRepository: authRepository,
    trainingRepository: trainingRepository,
    userRepository: userRepository,
    authBloc: authBloc,
  );

  runApp(App(appRouter: appRouter, authBloc: authBloc));
}
