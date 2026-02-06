import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/training_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';
import '../auth/cubits/login_cubit.dart';
import '../auth/cubits/register_cubit.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/register_screen.dart';
import '../home/screens/home_screen.dart';
import '../training/cubits/training_list_cubit.dart';
import '../training/cubits/training_detail_cubit.dart';
import '../training/cubits/training_form_cubit.dart';
import '../training/screens/training_list_screen.dart';
import '../training/screens/training_detail_screen.dart';
import '../training/screens/training_form_screen.dart';
import '../profile/cubits/profile_cubit.dart';
import '../profile/screens/profile_screen.dart';
import '../shared/widgets/app_bottom_nav_bar.dart';
import 'route_names.dart';

class AppRouter {
  final AuthRepository authRepository;
  final TrainingRepository trainingRepository;
  final UserRepository userRepository;
  final AuthBloc authBloc;

  AppRouter({
    required this.authRepository,
    required this.trainingRepository,
    required this.userRepository,
    required this.authBloc,
  });

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuth = authState is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation == RouteNames.login ||
          state.matchedLocation == RouteNames.register;

      if (authState is AuthInitial || authState is AuthLoading) {
        return null;
      }

      if (!isAuth && !isAuthRoute) {
        return RouteNames.login;
      }

      if (isAuth && isAuthRoute) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => BlocProvider(
          create: (_) => LoginCubit(authRepository),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => BlocProvider(
          create: (_) => RegisterCubit(authRepository),
          child: const RegisterScreen(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => TrainingListCubit(trainingRepository)..loadTrainings(),
              ),
            ],
            child: AppBottomNavBar(child: child),
          );
        },
        routes: [
          GoRoute(
            path: RouteNames.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.trainings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TrainingListScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.profile,
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider(
                create: (_) => ProfileCubit(userRepository)..loadProfile(),
                child: const ProfileScreen(),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.trainingNew,
        builder: (context, state) => BlocProvider(
          create: (_) => TrainingFormCubit(trainingRepository),
          child: const TrainingFormScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.trainingDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (_) => TrainingDetailCubit(trainingRepository)..loadTraining(id),
            child: TrainingDetailScreen(trainingId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.trainingEdit,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (_) => TrainingFormCubit(trainingRepository)..loadForEdit(id),
            child: TrainingFormScreen(trainingId: id),
          );
        },
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
