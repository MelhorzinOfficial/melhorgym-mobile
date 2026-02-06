import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_decorations.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../navigation/route_names.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../../shared/widgets/error_display.dart';
import '../../training/cubits/training_list_cubit.dart';
import '../../training/cubits/training_list_state.dart';
import '../../../domain/entities/training_plan.dart';
import '../../../domain/entities/user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<AuthBloc, AuthState>(
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

              return RefreshIndicator(
                onRefresh: () =>
                    context.read<TrainingListCubit>().loadTrainings(),
                color: AppColors.primary,
                backgroundColor: AppColors.card,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _GreetingSection(user: user),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: _QuickStartSection(plans: plans),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                        child: _StatsGrid(plans: plans),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Seus planos', style: AppTypography.heading3),
                            if (plans.isNotEmpty)
                              GestureDetector(
                                onTap: () => context.go(RouteNames.trainings),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Ver todos',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (state.status == TrainingListStatus.loading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: LoadingIndicator(),
                        ),
                      )
                    else if (state.status == TrainingListStatus.error)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ErrorDisplay(
                            message:
                                state.errorMessage ?? 'Erro ao carregar planos',
                            onRetry: () => context
                                .read<TrainingListCubit>()
                                .loadTrainings(),
                          ),
                        ),
                      )
                    else if (plans.isEmpty)
                      SliverToBoxAdapter(
                        child: _EmptyState(
                          onCreatePressed: () async {
                            final result = await context.push(
                              RouteNames.trainingNew,
                            );
                            if (result == true && context.mounted) {
                              context.read<TrainingListCubit>().loadTrainings();
                            }
                          },
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            if (index >= plans.take(3).length) return null;
                            final plan = plans[index];
                            return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: _PlanCard(
                                    plan: plan,
                                    index: index,
                                    onTap: () async {
                                      final result = await context.push(
                                        RouteNames.trainingDetailPath(plan.id!),
                                      );
                                      if (result == true && context.mounted) {
                                        context
                                            .read<TrainingListCubit>()
                                            .loadTrainings();
                                      }
                                    },
                                  ),
                                )
                                .animate()
                                .fadeIn(
                                  duration: 400.ms,
                                  delay: (100 * index).ms,
                                )
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  duration: 400.ms,
                                  delay: (100 * index).ms,
                                  curve: Curves.easeOutCubic,
                                );
                          }, childCount: plans.take(3).length),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ─── Greeting Section ───
class _GreetingSection extends StatelessWidget {
  final User user;
  const _GreetingSection({required this.user});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  String _getMotivation() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Hora de dar o melhor! 💪';
    if (hour < 18) return 'Continue firme, campeão!';
    return 'Feche o dia com chave de ouro!';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: primaryGlow(opacity: 0.25, blur: 16),
                  ),
                  child: Center(
                    child: Text(
                      (user.name ?? 'A')[0].toUpperCase(),
                      style: AppTypography.heading2.copyWith(
                        color: AppColors.scaffold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_getGreeting(), style: AppTypography.bodyMedium),
                      const SizedBox(height: 2),
                      Text(
                        user.name ?? 'Atleta',
                        style: AppTypography.heading2.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.secondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getMotivation(),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(
          begin: -0.05,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

// ─── Quick Start Section ───
class _QuickStartSection extends StatelessWidget {
  final List<TrainingPlan> plans;
  const _QuickStartSection({required this.plans});

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) return const SizedBox.shrink();

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A2E1A), Color(0xFF0F1F15)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 24,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Iniciar treino',
                          style: AppTypography.heading3.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Escolha um dia e comece agora',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _getQuickWorkouts().length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final workout = _getQuickWorkouts()[index];
                    return GestureDetector(
                      onTap: () {
                        lightHaptic();
                        context.push(
                          RouteNames.trainingDetailPath(
                            workout['planId'] as int,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: (workout['color'] as Color).withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (workout['color'] as Color).withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 16,
                              color: workout['color'] as Color,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              workout['name'] as String,
                              style: AppTypography.labelSmall.copyWith(
                                color: workout['color'] as Color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 200.ms)
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 500.ms,
          delay: 200.ms,
          curve: Curves.easeOutCubic,
        );
  }

  List<Map<String, dynamic>> _getQuickWorkouts() {
    final workouts = <Map<String, dynamic>>[];
    for (final plan in plans) {
      for (int i = 0; i < plan.dailyWorkouts.length; i++) {
        workouts.add({
          'name': plan.dailyWorkouts[i].dayName,
          'planId': plan.id,
          'color': AppColors.getDayColor(workouts.length),
        });
      }
    }
    return workouts.take(6).toList();
  }
}

// ─── Stats Grid ───
class _StatsGrid extends StatelessWidget {
  final List<TrainingPlan> plans;
  const _StatsGrid({required this.plans});

  @override
  Widget build(BuildContext context) {
    final totalWorkouts = plans.fold<int>(
      0,
      (sum, p) => sum + p.dailyWorkouts.length,
    );
    final totalExercises = plans.fold<int>(
      0,
      (sum, p) =>
          sum +
          p.dailyWorkouts.fold<int>(0, (s, dw) => s + dw.exercises.length),
    );

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.description_outlined,
            value: plans.length.toString(),
            label: 'Planos',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.calendar_today_rounded,
            value: totalWorkouts.toString(),
            label: 'Treinos',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.fitness_center_rounded,
            value: totalExercises.toString(),
            label: 'Exercícios',
            color: AppColors.secondary,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(value, style: AppTypography.heading2.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}

// ─── Plan Card ───
class _PlanCard extends StatelessWidget {
  final TrainingPlan plan;
  final int index;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getDayColor(index);
    final workoutCount = plan.dailyWorkouts.length;
    final exerciseCount = plan.dailyWorkouts.fold<int>(
      0,
      (sum, dw) => sum + dw.exercises.length,
    );

    return GestureDetector(
      onTap: () {
        lightHaptic();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.2),
                    color.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Icon(Icons.fitness_center_rounded, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: AppTypography.label.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _MiniTag(label: '$workoutCount dias', color: color),
                      const SizedBox(width: 8),
                      _MiniTag(
                        label: '$exerciseCount exercícios',
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(fontSize: 11, color: color),
      ),
    );
  }
}

// ─── Empty State ───
class _EmptyState extends StatelessWidget {
  final VoidCallback onCreatePressed;
  const _EmptyState({required this.onCreatePressed});

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: const Icon(
                    Icons.fitness_center_outlined,
                    size: 40,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Nenhum plano ainda', style: AppTypography.heading3),
                const SizedBox(height: 8),
                Text(
                  'Crie seu primeiro plano de treino\ne comece sua evolução!',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    lightHaptic();
                    onCreatePressed();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: primaryGlow(opacity: 0.3, blur: 20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text('Criar plano', style: AppTypography.button),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
