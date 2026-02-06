import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../navigation/route_names.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../../shared/widgets/error_display.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../cubits/training_detail_cubit.dart';
import '../cubits/training_detail_state.dart';
import '../widgets/daily_workout_card.dart';

class TrainingDetailScreen extends StatelessWidget {
  final int trainingId;

  const TrainingDetailScreen({super.key, required this.trainingId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrainingDetailCubit, TrainingDetailState>(
      listener: (context, state) {
        if (state.status == TrainingDetailStatus.deleted) {
          context.pop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
            ),
            title: Text(
              state.plan?.name ?? 'Detalhes',
              style: AppTypography.heading2,
            ),
            actions: [
              if (state.plan != null) ...[
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                  onPressed: () async {
                    final result = await context.push(
                      RouteNames.trainingEditPath(trainingId),
                    );
                    if (result == true && context.mounted) {
                      context
                          .read<TrainingDetailCubit>()
                          .loadTraining(trainingId);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: () async {
                    final confirmed = await ConfirmationDialog.show(
                      context,
                      title: 'Excluir plano',
                      message:
                          'Tem certeza que deseja excluir "${state.plan!.name}"?',
                      confirmText: 'Excluir',
                    );
                    if (confirmed == true && context.mounted) {
                      context
                          .read<TrainingDetailCubit>()
                          .deleteTraining(trainingId);
                    }
                  },
                ),
              ],
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TrainingDetailState state) {
    if (state.status == TrainingDetailStatus.loading) {
      return const LoadingIndicator(message: 'Carregando treino...');
    }

    if (state.status == TrainingDetailStatus.error) {
      return ErrorDisplay(
        message: state.errorMessage ?? 'Erro ao carregar treino',
        onRetry: () =>
            context.read<TrainingDetailCubit>().loadTraining(trainingId),
      );
    }

    final plan = state.plan;
    if (plan == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name, style: AppTypography.heading3),
                    const SizedBox(height: 4),
                    Text(
                      '${plan.dailyWorkouts.length} dias de treino',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...plan.dailyWorkouts.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DailyWorkoutCard(
              workout: entry.value,
              index: entry.key,
            ),
          );
        }),
      ],
    );
  }
}
