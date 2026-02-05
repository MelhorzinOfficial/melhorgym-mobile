import { computed } from 'vue';
import { useWorkoutProgressStore } from 'src/stores/workout-progress.store';
import type {
  TrainingPlanResponse,
  DailyWorkoutResponse,
} from 'src/core/interfaces/workout.interface';

export const useWorkoutProgress = () => {
  const store = useWorkoutProgressStore();

  // Select a plan as active
  const selectPlan = (planId: number | null) => {
    store.setActivePlan(planId);
  };

  // Start a workout session for a specific day
  const startDaySession = (plan: TrainingPlanResponse, day: DailyWorkoutResponse) => {
    const exercises = day.exercises.map((ex) => ({
      id: ex.id,
      name: ex.name,
      sets: ex.sets,
      reps: ex.reps,
    }));
    return store.startSession(plan.id, plan.name, day.id, day.dayName, exercises);
  };

  // Check if a day has an active session
  const isDayInProgress = (planId: number, dayId: number) => {
    return store.isSessionForDay(planId, dayId);
  };

  // Toggle exercise completion
  const toggleExercise = (exerciseId: number) => {
    store.toggleExercise(exerciseId);
  };

  // Finish current session
  const finishSession = () => {
    store.finishSession();
  };

  // Cancel current session
  const cancelSession = () => {
    store.cancelSession();
  };

  // Get exercise completion status from current session
  const isExerciseCompleted = (exerciseId: number): boolean => {
    if (!store.currentSession) return false;
    const exercise = store.currentSession.exercises.find((e) => e.exerciseId === exerciseId);
    return exercise?.completed ?? false;
  };

  // Stats
  const stats = computed(() => ({
    sessionsThisMonth: store.sessionsThisMonth.length,
    currentStreak: store.currentStreak,
    totalExercises: store.totalExercisesCompleted,
  }));

  return {
    // State
    activePlanId: computed(() => store.activePlanId),
    currentSession: computed(() => store.currentSession),
    sessionProgress: computed(() => store.currentSessionProgress),
    hasActiveSession: computed(() => store.hasActiveSession),

    // Actions
    selectPlan,
    startDaySession,
    isDayInProgress,
    toggleExercise,
    finishSession,
    cancelSession,
    isExerciseCompleted,
    getCompletedDaysForPlan: store.getCompletedDaysForPlan,

    // Stats
    stats,
  };
};
