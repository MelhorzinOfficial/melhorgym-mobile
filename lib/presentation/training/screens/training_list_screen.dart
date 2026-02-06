import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../navigation/route_names.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../../shared/widgets/error_display.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../cubits/training_list_cubit.dart';
import '../cubits/training_list_state.dart';
import '../widgets/training_card.dart';
import '../widgets/empty_training_state.dart';

class TrainingListScreen extends StatelessWidget {
  const TrainingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Treinos', style: AppTypography.heading2),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () async {
              final result = await context.push(RouteNames.trainingNew);
              if (result == true && context.mounted) {
                context.read<TrainingListCubit>().loadTrainings();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<TrainingListCubit, TrainingListState>(
        builder: (context, state) {
          if (state.status == TrainingListStatus.loading) {
            return const LoadingIndicator(message: 'Carregando treinos...');
          }

          if (state.status == TrainingListStatus.error) {
            return ErrorDisplay(
              message: state.errorMessage ?? 'Erro ao carregar treinos',
              onRetry: () => context.read<TrainingListCubit>().loadTrainings(),
            );
          }

          if (state.plans.isEmpty) {
            return EmptyTrainingState(
              onCreatePressed: () async {
                final result = await context.push(RouteNames.trainingNew);
                if (result == true && context.mounted) {
                  context.read<TrainingListCubit>().loadTrainings();
                }
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<TrainingListCubit>().loadTrainings(),
            color: AppColors.primary,
            backgroundColor: AppColors.card,
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: state.plans.length,
              separatorBuilder: (context2, index2) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final plan = state.plans[index];
                return TrainingCard(
                  plan: plan,
                  onTap: () async {
                    final result = await context.push(
                      RouteNames.trainingDetailPath(plan.id!),
                    );
                    if (result == true && context.mounted) {
                      context.read<TrainingListCubit>().loadTrainings();
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
                      context.read<TrainingListCubit>().deleteTraining(plan.id!);
                      Flushbar(
                        message: 'Plano excluído com sucesso',
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.primary,
                        margin: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(12),
                        flushbarPosition: FlushbarPosition.TOP,
                      ).show(context);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
