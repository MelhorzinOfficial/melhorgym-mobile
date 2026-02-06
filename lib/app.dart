import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/auth/bloc/auth_state.dart';
import 'presentation/navigation/app_router.dart';
import 'presentation/shared/widgets/loading_indicator.dart';

class App extends StatelessWidget {
  final AppRouter appRouter;
  final AuthBloc authBloc;

  const App({
    super.key,
    required this.appRouter,
    required this.authBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authBloc,
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
            previous is AuthInitial || current is! AuthInitial,
        builder: (context, state) {
          if (state is AuthInitial) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme,
              home: const Scaffold(
                body: LoadingIndicator(message: 'Carregando...'),
              ),
            );
          }

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'MelhorGym',
            theme: AppTheme.darkTheme,
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}
