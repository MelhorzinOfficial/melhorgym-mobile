import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_decorations.dart';
import '../../navigation/route_names.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../../shared/widgets/error_display.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../cubits/training_list_cubit.dart';
import '../cubits/training_list_state.dart';
import '../../../domain/entities/training_plan.dart';

class TrainingListScreen extends StatelessWidget {
  const TrainingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Meus Treinos', style: AppTypography.heading1),
                        const SizedBox(height: 4),
                        BlocBuilder<TrainingListCubit, TrainingListState>(
                          builder: (context, state) {
                            final count = state.plans.length;
                            return Text(
                              count == 0
                                  ? 'Nenhum plano criado'
                                  : '$count plano${count > 1 ? 's' : ''} de treino',
                              style: AppTypography.bodyMedium,
                            );
                          },
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        lightHaptic();
                        final result =
                            await context.push(RouteNames.trainingNew);
                        if (result == true && context.mounted) {
                          context.read<TrainingListCubit>().loadTrainings();
                        }
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: primaryGlow(opacity: 0.25, blur: 14),
                        ),
                        child: const Icon(Icons.add_rounded,
                            color: Colors.black, size: 26),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // Content
            BlocBuilder<TrainingListCubit, TrainingListState>(
              builder: (context, state) {
                if (state.status == TrainingListStatus.loading) {
                  return const SliverFillRemaining(
                    child: LoadingIndicator(message: 'Carregando treinos...'),
                  );
                }

                if (state.status == TrainingListStatus.error) {
                  return SliverFillRemaining(
                    child: ErrorDisplay(
                      message:
                          state.errorMessage ?? 'Erro ao carregar treinos',
                      onRetry: () =>
                          context.read<TrainingListCubit>().loadTrainings(),
                    ),
                  );
                }

                if (state.plans.isEmpty) {
                  return SliverFillRemaining(
                    child: _EmptyState(
                      onCreatePressed: () async {
                        final result =
                            await context.push(RouteNames.trainingNew);
                        if (result == true && context.mounted) {
                          context.read<TrainingListCubit>().loadTrainings();
                        }
                      },
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final plan = state.plans[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _TrainingCard(
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
                            onDelete: () async {
                              final confirmed = await ConfirmationDialog.show(
                                context,
                                title: 'Excluir plano',
                                message:
                                    'Tem certeza que deseja excluir "${plan.name}"? Esta ação não pode ser desfeita.',
                                confirmText: 'Excluir',
                              );
                              if (confirmed == true && context.mounted) {
                                context
                                    .read<TrainingListCubit>()
                                    .deleteTraining(plan.id!);
                                Flushbar(
                                  message: 'Plano excluído com sucesso',
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: AppColors.card,
                                  messageColor: AppColors.primary,
                                  margin: const EdgeInsets.all(16),
                                  borderRadius: BorderRadius.circular(16),
                                  flushbarPosition: FlushbarPosition.TOP,
                                  icon: const Icon(Icons.check_circle,
                                      color: AppColors.primary),
                                ).show(context);
                              }
                            },
                          ),
                        ).animate().fadeIn(
                              duration: 400.ms,
                              delay: (80 * index).ms,
                            ).slideY(
                              begin: 0.08,
                              end: 0,
                              duration: 400.ms,
                              delay: (80 * index).ms,
                              curve: Curves.easeOutCubic,
                            );
                      },
                      childCount: state.plans.length,
                    ),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ─── Training Card ───
class _TrainingCard extends StatelessWidget {
  final TrainingPlan plan;
  final int index;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _TrainingCard({
    required this.plan,
    required this.index,
    required this.onTap,
    this.onDelete,
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
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: color.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.25),
                          color.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.fitness_center_rounded,
                        color: color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  // Name + info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: AppTypography.heading3.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 13, color: AppColors.textTertiary),
                            const SizedBox(width: 4),
                            Text('$workoutCount dias',
                                style: AppTypography.bodySmall),
                            const SizedBox(width: 12),
                            Icon(Icons.fitness_center,
                                size: 13, color: AppColors.textTertiary),
                            const SizedBox(width: 4),
                            Text('$exerciseCount exercícios',
                                style: AppTypography.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert,
                        color: AppColors.textTertiary, size: 20),
                    color: AppColors.cardLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility_outlined,
                                size: 18, color: color),
                            const SizedBox(width: 10),
                            const Text('Ver detalhes'),
                          ],
                        ),
                      ),
                      if (onDelete != null)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline,
                                  size: 18, color: AppColors.error),
                              SizedBox(width: 10),
                              Text('Excluir',
                                  style: TextStyle(color: AppColors.error)),
                            ],
                          ),
                        ),
                    ],
                    onSelected: (value) {
                      if (value == 'view') onTap();
                      if (value == 'delete') onDelete?.call();
                    },
                  ),
                ],
              ),
            ),
            // Day chips
            if (plan.dailyWorkouts.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: plan.dailyWorkouts.asMap().entries.map((entry) {
                    final dayColor = AppColors.getDayColor(entry.key);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: dayColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: dayColor.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Text(
                        entry.value.dayName,
                        style: AppTypography.bodySmall.copyWith(
                          color: dayColor,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    AppColors.accent.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: const Icon(
                Icons.fitness_center_outlined,
                size: 44,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 28),
            Text('Sem planos de treino',
                style: AppTypography.heading2),
            const SizedBox(height: 10),
            Text(
              'Monte seu primeiro plano de treino\ne comece sua evolução!',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                lightHaptic();
                onCreatePressed();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 36, vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: primaryGlow(opacity: 0.3, blur: 20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_rounded,
                        color: Colors.black, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Criar plano de treino',
                      style: AppTypography.button,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
