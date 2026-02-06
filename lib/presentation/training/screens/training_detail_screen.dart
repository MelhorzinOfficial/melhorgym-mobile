import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_decorations.dart';
import '../../navigation/route_names.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../../shared/widgets/error_display.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../cubits/training_detail_cubit.dart';
import '../cubits/training_detail_state.dart';
import '../../../domain/entities/daily_workout.dart';
import '../../../domain/entities/exercise.dart';

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
          backgroundColor: AppColors.scaffold,
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
      return SafeArea(
        child: Column(
          children: [
            _buildBackButton(context),
            Expanded(
              child: ErrorDisplay(
                message: state.errorMessage ?? 'Erro ao carregar treino',
                onRetry: () => context.read<TrainingDetailCubit>().loadTraining(
                  trainingId,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final plan = state.plan;
    if (plan == null) return const SizedBox.shrink();

    return CustomScrollView(
      slivers: [
        // Custom App Bar
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  _buildBackButton(context),
                  const Spacer(),
                  _ActionButton(
                    icon: Icons.edit_outlined,
                    color: AppColors.primary,
                    onTap: () async {
                      final result = await context.push(
                        RouteNames.trainingEditPath(trainingId),
                      );
                      if (result == true && context.mounted) {
                        context.read<TrainingDetailCubit>().loadTraining(
                          trainingId,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.delete_outline,
                    color: AppColors.error,
                    onTap: () async {
                      final confirmed = await ConfirmationDialog.show(
                        context,
                        title: 'Excluir plano',
                        message:
                            'Tem certeza que deseja excluir "${plan.name}"?',
                        confirmText: 'Excluir',
                      );
                      if (confirmed == true && context.mounted) {
                        context.read<TrainingDetailCubit>().deleteTraining(
                          trainingId,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // Plan Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _PlanHeader(
              name: plan.name,
              workoutCount: plan.dailyWorkouts.length,
              exerciseCount: plan.dailyWorkouts.fold<int>(
                0,
                (s, dw) => s + dw.exercises.length,
              ),
            ),
          ),
        ),

        // Start workout button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _StartWorkoutButton(
              onTap: () {
                mediumHaptic();
                // Navigate to workout execution
                _showWorkoutPicker(context, plan.dailyWorkouts);
              },
            ),
          ),
        ),

        // Section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
            child: Text('Dias de treino', style: AppTypography.heading3),
          ),
        ),

        // Workout cards
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final workout = plan.dailyWorkouts[index];
              return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _DailyWorkoutCard(
                      workout: workout,
                      index: index,
                      onStartWorkout: () {
                        mediumHaptic();
                        Navigator.push(
                          context,
                          FadeSlideTransition(
                            page: _WorkoutExecutionSheet(
                              workout: workout,
                              dayIndex: index,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                  .slideY(
                    begin: 0.08,
                    end: 0,
                    duration: 400.ms,
                    delay: (100 * index).ms,
                    curve: Curves.easeOutCubic,
                  );
            }, childCount: plan.dailyWorkouts.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: 42,
        height: 42,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  void _showWorkoutPicker(BuildContext context, List<DailyWorkout> workouts) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text('Escolha o treino', style: AppTypography.heading2),
            const SizedBox(height: 8),
            Text(
              'Qual treino você vai fazer hoje?',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 24),
            ...workouts.asMap().entries.map((entry) {
              final color = AppColors.getDayColor(entry.key);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      FadeSlideTransition(
                        page: _WorkoutExecutionSheet(
                          workout: entry.value,
                          dayIndex: entry.key,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: AppTypography.heading3.copyWith(
                                color: color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.value.dayName,
                                style: AppTypography.label,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${entry.value.exercises.length} exercícios',
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.play_circle_filled_rounded,
                          color: color,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: MediaQuery.of(ctx).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}

// ─── Action Button ───
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        lightHaptic();
        onTap();
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

// ─── Plan Header ───
class _PlanHeader extends StatelessWidget {
  final String name;
  final int workoutCount;
  final int exerciseCount;

  const _PlanHeader({
    required this.name,
    required this.workoutCount,
    required this.exerciseCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.card,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: primaryGlow(opacity: 0.2, blur: 12),
                    ),
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: AppTypography.heading2),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _InfoTag(
                              icon: Icons.calendar_today_rounded,
                              label: '$workoutCount dias',
                            ),
                            const SizedBox(width: 10),
                            _InfoTag(
                              icon: Icons.fitness_center,
                              label: '$exerciseCount exercícios',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(
          begin: 0.05,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(label, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}

// ─── Start Workout Button ───
class _StartWorkoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StartWorkoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: primaryGlow(opacity: 0.3, blur: 20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.black,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  'Iniciar Treino',
                  style: AppTypography.heading3.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
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
}

// ─── Daily Workout Card ───
class _DailyWorkoutCard extends StatefulWidget {
  final DailyWorkout workout;
  final int index;
  final VoidCallback onStartWorkout;

  const _DailyWorkoutCard({
    required this.workout,
    required this.index,
    required this.onStartWorkout,
  });

  @override
  State<_DailyWorkoutCard> createState() => _DailyWorkoutCardState();
}

class _DailyWorkoutCardState extends State<_DailyWorkoutCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getDayColor(widget.index);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _isExpanded
              ? color.withValues(alpha: 0.25)
              : color.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          // Header - always visible
          GestureDetector(
            onTap: () {
              lightHaptic();
              setState(() => _isExpanded = !_isExpanded);
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.25),
                          color.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index + 1}',
                        style: AppTypography.heading3.copyWith(
                          color: color,
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
                        Text(
                          widget.workout.dayName,
                          style: AppTypography.label.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.workout.exercises.length} exercícios',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // Play button
                  GestureDetector(
                    onTap: widget.onStartWorkout,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: color,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: AppColors.textTertiary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded exercises
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _ExerciseList(
              exercises: widget.workout.exercises,
              color: color,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
            sizeCurve: Curves.easeOutCubic,
          ),
        ],
      ),
    );
  }
}

// ─── Exercise List ───
class _ExerciseList extends StatelessWidget {
  final List<Exercise> exercises;
  final Color color;

  const _ExerciseList({required this.exercises, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: color.withValues(alpha: 0.1)),
        ...exercises.asMap().entries.map((entry) {
          final exercise = entry.value;
          final isLast = entry.key == exercises.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: AppColors.divider.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    exercise.name,
                    style: AppTypography.bodyLarge.copyWith(fontSize: 14),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.15)),
                  ),
                  child: Text(
                    '${exercise.sets}x${exercise.reps}',
                    style: AppTypography.labelSmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ─── Workout Execution Sheet (Full Screen) ───
class _WorkoutExecutionSheet extends StatefulWidget {
  final DailyWorkout workout;
  final int dayIndex;

  const _WorkoutExecutionSheet({required this.workout, required this.dayIndex});

  @override
  State<_WorkoutExecutionSheet> createState() => _WorkoutExecutionSheetState();
}

class _WorkoutExecutionSheetState extends State<_WorkoutExecutionSheet> {
  late int _currentExerciseIndex;
  late List<List<bool>> _setCompleted;
  final Stopwatch _stopwatch = Stopwatch();
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _currentExerciseIndex = 0;
    _setCompleted = widget.workout.exercises.map((e) {
      return List.filled(e.sets, false);
    }).toList();
    _startTimer();
  }

  void _startTimer() {
    _stopwatch.start();
    _isRunning = true;
    _tick();
  }

  void _tick() {
    if (!_isRunning || !mounted) return;
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {});
        _tick();
      }
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _isRunning = false;
    super.dispose();
  }

  String get _formattedTime {
    final duration = _stopwatch.elapsed;
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get _progress {
    int total = 0;
    int completed = 0;
    for (final sets in _setCompleted) {
      total += sets.length;
      completed += sets.where((s) => s).length;
    }
    return total == 0 ? 0 : completed / total;
  }

  bool get _allCompleted {
    return _setCompleted.every((sets) => sets.every((s) => s));
  }

  void _toggleSet(int exerciseIndex, int setIndex) {
    lightHaptic();
    setState(() {
      _setCompleted[exerciseIndex][setIndex] =
          !_setCompleted[exerciseIndex][setIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getDayColor(widget.dayIndex);
    final currentExercise = widget.workout.exercises[_currentExerciseIndex];
    final totalExercises = widget.workout.exercises.length;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showExitConfirmation(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Timer
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 18, color: color),
                        const SizedBox(width: 8),
                        Text(
                          _formattedTime,
                          style: AppTypography.label.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 42), // Balance
                ],
              ),
            ),

            // Workout name
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                children: [
                  Text(
                    widget.workout.dayName,
                    style: AppTypography.heading2.copyWith(color: color),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$totalExercises exercícios',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Progresso', style: AppTypography.labelSmall),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: AppTypography.labelSmall.copyWith(color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Exercise navigation
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: totalExercises,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isActive = index == _currentExerciseIndex;
                    final allSetsComplete = _setCompleted[index].every(
                      (s) => s,
                    );

                    return GestureDetector(
                      onTap: () {
                        lightHaptic();
                        setState(() => _currentExerciseIndex = index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? color.withValues(alpha: 0.15)
                              : allSetsComplete
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isActive
                                ? color.withValues(alpha: 0.4)
                                : allSetsComplete
                                ? AppColors.success.withValues(alpha: 0.3)
                                : AppColors.divider,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (allSetsComplete)
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: AppColors.success,
                              )
                            else
                              Text(
                                '${index + 1}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: isActive
                                      ? color
                                      : AppColors.textTertiary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Current exercise detail
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: color.withValues(alpha: 0.12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exercise name
                      Text(currentExercise.name, style: AppTypography.heading2),
                      const SizedBox(height: 8),
                      Text(
                        '${currentExercise.sets} séries · ${currentExercise.reps} repetições',
                        style: AppTypography.bodyMedium.copyWith(color: color),
                      ),
                      const SizedBox(height: 24),

                      // Sets
                      Text('Séries', style: AppTypography.label),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          itemCount: currentExercise.sets,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, setIndex) {
                            final completed =
                                _setCompleted[_currentExerciseIndex][setIndex];

                            return GestureDetector(
                              onTap: () =>
                                  _toggleSet(_currentExerciseIndex, setIndex),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: completed
                                      ? color.withValues(alpha: 0.12)
                                      : AppColors.input,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: completed
                                        ? color.withValues(alpha: 0.3)
                                        : AppColors.divider,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: completed
                                            ? color
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: completed
                                              ? color
                                              : AppColors.textTertiary,
                                          width: 2,
                                        ),
                                      ),
                                      child: completed
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 18,
                                              color: Colors.black,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        'Série ${setIndex + 1}',
                                        style: AppTypography.label.copyWith(
                                          color: completed
                                              ? color
                                              : AppColors.textPrimary,
                                          decoration: completed
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${currentExercise.reps} reps',
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: completed
                                            ? color
                                            : AppColors.textSecondary,
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
                ),
              ),
            ),

            // Bottom navigation
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_currentExerciseIndex > 0)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          lightHaptic();
                          setState(() => _currentExerciseIndex--);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text('Anterior', style: AppTypography.label),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_currentExerciseIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        mediumHaptic();
                        if (_currentExerciseIndex < totalExercises - 1) {
                          setState(() => _currentExerciseIndex++);
                        } else if (_allCompleted) {
                          _showCompletionDialog(context, color);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient:
                              _allCompleted &&
                                  _currentExerciseIndex == totalExercises - 1
                              ? AppColors.primaryGradient
                              : null,
                          color:
                              _allCompleted &&
                                  _currentExerciseIndex == totalExercises - 1
                              ? null
                              : color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              _allCompleted &&
                                  _currentExerciseIndex == totalExercises - 1
                              ? null
                              : Border.all(color: color.withValues(alpha: 0.3)),
                        ),
                        child: Center(
                          child: Text(
                            _currentExerciseIndex < totalExercises - 1
                                ? 'Próximo exercício'
                                : _allCompleted
                                ? 'Finalizar treino! 🎉'
                                : 'Complete as séries',
                            style: AppTypography.label.copyWith(
                              color:
                                  _allCompleted &&
                                      _currentExerciseIndex ==
                                          totalExercises - 1
                                  ? Colors.black
                                  : color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sair do treino?', style: AppTypography.heading3),
        content: Text(
          'Seu progresso neste treino será perdido.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Continuar',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text('Sair', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, Color color) {
    _stopwatch.stop();
    _isRunning = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: primaryGlow(opacity: 0.4, blur: 20),
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.black,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Treino concluído! 🎉',
              style: AppTypography.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Parabéns! Você completou o treino em $_formattedTime',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                heavyHaptic();
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Concluir',
                    style: AppTypography.button.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
