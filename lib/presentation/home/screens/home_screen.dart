import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../navigation/route_names.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../../shared/widgets/error_display.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_stats_card.dart';
import '../widgets/training_preview_card.dart';
import '../../training/cubits/training_list_cubit.dart';
import '../../training/cubits/training_list_state.dart';
import '../../../domain/entities/training_plan.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const LoadingIndicator();
        }

        final user = authState.user;

        return BlocBuilder<TrainingListCubit, TrainingListState>(
          builder: (context, state) {
            final plans = state.status == TrainingListStatus.loaded
                ? state.plans
                : <TrainingPlan>[];
            final totalWorkouts = plans.fold<int>(
              0,
              (sum, p) => sum + p.dailyWorkouts.length,
            );
            final totalExercises = plans.fold<int>(
              0,
              (sum, p) =>
                  sum +
                  p.dailyWorkouts.fold<int>(
                    0,
                    (s, dw) => s + dw.exercises.length,
                  ),
            );

            return RefreshIndicator(
              onRefresh: () => context.read<TrainingListCubit>().loadTrainings(),
              color: AppColors.primary,
              backgroundColor: AppColors.card,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  GreetingHeader(user: user),
                  const SizedBox(height: 24),
                  QuickStatsCard(
                    totalPlans: plans.length,
                    totalWorkouts: totalWorkouts,
                    totalExercises: totalExercises,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Seus planos', style: AppTypography.heading3),
                      if (plans.isNotEmpty)
                        TextButton(
                          onPressed: () => context.go(RouteNames.trainings),
                          child: const Text('Ver todos'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (state.status == TrainingListStatus.loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: LoadingIndicator(),
                    )
                  else if (state.status == TrainingListStatus.error)
                    ErrorDisplay(
                      message: state.errorMessage ?? 'Erro ao carregar planos',
                      onRetry: () =>
                          context.read<TrainingListCubit>().loadTrainings(),
                    )
                  else if (plans.isEmpty)
                    _buildEmptyState(context)
                  else
                    ...plans.take(3).map((plan) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TrainingPreviewCard(
                            plan: plan,
                            onTap: () async {
                              final result = await context.push(
                                RouteNames.trainingDetailPath(plan.id!),
                              );
                              if (result == true && context.mounted) {
                                context.read<TrainingListCubit>().loadTrainings();
                              }
                            },
                          ),
                        )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(
              Icons.fitness_center_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum plano de treino',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Crie seu primeiro plano para começar!',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await context.push(RouteNames.trainingNew);
                if (result == true && context.mounted) {
                  context.read<TrainingListCubit>().loadTrainings();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Criar plano'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
