import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

// Types
export interface ExerciseProgress {
  exerciseId: number;
  name: string;
  sets: number;
  reps: string;
  completed: boolean;
  completedAt?: string | undefined;
}

export interface WorkoutSession {
  id: string;
  planId: number;
  planName: string;
  dayId: number;
  dayName: string;
  startedAt: string;
  completedAt?: string;
  exercises: ExerciseProgress[];
}

export interface WorkoutProgressState {
  activePlanId: number | null;
  currentSession: WorkoutSession | null;
  history: WorkoutSession[];
}

const STORAGE_KEY = 'melhorgym-progress';

// Helper functions
const generateSessionId = (): string => {
  return `session-${Date.now()}-${Math.random().toString(36).substring(7)}`;
};

const loadFromStorage = (): WorkoutProgressState => {
  try {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) {
      return JSON.parse(stored);
    }
  } catch (e) {
    console.error('Error loading workout progress:', e);
  }
  return {
    activePlanId: null,
    currentSession: null,
    history: [],
  };
};

const saveToStorage = (state: WorkoutProgressState) => {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
  } catch (e) {
    console.error('Error saving workout progress:', e);
  }
};

export const useWorkoutProgressStore = defineStore('workout-progress', () => {
  // State
  const initialState = loadFromStorage();
  const activePlanId = ref<number | null>(initialState.activePlanId);
  const currentSession = ref<WorkoutSession | null>(initialState.currentSession);
  const history = ref<WorkoutSession[]>(initialState.history);

  // Computed
  const hasActivePlan = computed(() => activePlanId.value !== null);
  const hasActiveSession = computed(() => currentSession.value !== null);

  const currentSessionProgress = computed(() => {
    if (!currentSession.value) return { completed: 0, total: 0, percentage: 0 };
    const completed = currentSession.value.exercises.filter((e) => e.completed).length;
    const total = currentSession.value.exercises.length;
    return {
      completed,
      total,
      percentage: total > 0 ? Math.round((completed / total) * 100) : 0,
    };
  });

  const sessionsThisMonth = computed(() => {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    return history.value.filter((s) => {
      if (!s.completedAt) return false;
      return new Date(s.completedAt) >= startOfMonth;
    });
  });

  const totalExercisesCompleted = computed(() => {
    return history.value.reduce((acc, session) => {
      return acc + session.exercises.filter((e) => e.completed).length;
    }, 0);
  });

  const currentStreak = computed(() => {
    if (history.value.length === 0) return 0;

    // Sort by date descending
    const sortedHistory = [...history.value]
      .filter((s) => s.completedAt)
      .sort((a, b) => new Date(b.completedAt!).getTime() - new Date(a.completedAt!).getTime());

    if (sortedHistory.length === 0) return 0;

    let streak = 0;
    const currentDate = new Date();
    currentDate.setHours(0, 0, 0, 0);

    // Check if there's a workout today or yesterday to start the streak
    const lastSession = sortedHistory[0];
    if (!lastSession || !lastSession.completedAt) return 0;

    const lastWorkoutDate = new Date(lastSession.completedAt);
    lastWorkoutDate.setHours(0, 0, 0, 0);

    const diffDays = Math.floor(
      (currentDate.getTime() - lastWorkoutDate.getTime()) / (1000 * 60 * 60 * 24),
    );
    if (diffDays > 1) return 0; // Streak broken

    // Count consecutive days
    const workoutDates = new Set<string>();
    sortedHistory.forEach((s) => {
      const date = new Date(s.completedAt!);
      workoutDates.add(date.toDateString());
    });

    const checkDate = new Date(lastWorkoutDate);
    while (workoutDates.has(checkDate.toDateString())) {
      streak++;
      checkDate.setDate(checkDate.getDate() - 1);
    }

    return streak;
  });

  const getCompletedDaysForPlan = (planId: number) => {
    const uniqueDays = new Set(
      history.value.filter((s) => s.planId === planId && s.completedAt).map((s) => s.dayId),
    );
    return uniqueDays.size;
  };

  // Actions
  const setActivePlan = (planId: number | null) => {
    activePlanId.value = planId;
    // If changing plan, clear current session
    if (currentSession.value && currentSession.value.planId !== planId) {
      currentSession.value = null;
    }
    persist();
  };

  const startSession = (
    planId: number,
    planName: string,
    dayId: number,
    dayName: string,
    exercises: Array<{ id: number; name: string; sets: number; reps: string }>,
  ) => {
    // If there's an existing session for same day, resume it
    if (
      currentSession.value &&
      currentSession.value.planId === planId &&
      currentSession.value.dayId === dayId
    ) {
      return currentSession.value;
    }

    currentSession.value = {
      id: generateSessionId(),
      planId,
      planName,
      dayId,
      dayName,
      startedAt: new Date().toISOString(),
      exercises: exercises.map((ex) => ({
        exerciseId: ex.id,
        name: ex.name,
        sets: ex.sets,
        reps: ex.reps,
        completed: false,
      })),
    };
    persist();
    return currentSession.value;
  };

  const toggleExercise = (exerciseId: number) => {
    if (!currentSession.value) return;

    const exercise = currentSession.value.exercises.find((e) => e.exerciseId === exerciseId);
    if (exercise) {
      exercise.completed = !exercise.completed;
      exercise.completedAt = exercise.completed ? new Date().toISOString() : undefined;
      persist();
    }
  };

  const finishSession = () => {
    if (!currentSession.value) return;

    currentSession.value.completedAt = new Date().toISOString();
    history.value.unshift({ ...currentSession.value });
    currentSession.value = null;
    persist();
  };

  const cancelSession = () => {
    currentSession.value = null;
    persist();
  };

  const isSessionForDay = (planId: number, dayId: number) => {
    return (
      currentSession.value &&
      currentSession.value.planId === planId &&
      currentSession.value.dayId === dayId
    );
  };

  const persist = () => {
    saveToStorage({
      activePlanId: activePlanId.value,
      currentSession: currentSession.value,
      history: history.value,
    });
  };

  const clearHistory = () => {
    history.value = [];
    persist();
  };

  const resetState = () => {
    activePlanId.value = null;
    currentSession.value = null;
    history.value = [];
    localStorage.removeItem(STORAGE_KEY);
  };

  return {
    // State
    activePlanId,
    currentSession,
    history,
    // Computed
    hasActivePlan,
    hasActiveSession,
    currentSessionProgress,
    sessionsThisMonth,
    totalExercisesCompleted,
    currentStreak,
    // Actions
    setActivePlan,
    startSession,
    toggleExercise,
    finishSession,
    cancelSession,
    isSessionForDay,
    getCompletedDaysForPlan,
    clearHistory,
    resetState,
  };
});
