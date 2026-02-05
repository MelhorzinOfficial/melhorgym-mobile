<template>
  <AppAccordion :title="day.dayName" :badge="progressBadge" :default-expanded="!!isInProgress">
    <template #actions>
      <q-icon v-if="isInProgress" name="pending" color="warning" size="20px" />
      <q-icon v-else-if="hasCompletedToday" name="check_circle" color="positive" size="20px" />
    </template>

    <div class="space-y-2">
      <!-- Session not started -->
      <div v-if="!isInProgress" class="text-center py-4">
        <p class="text-gray-500 dark:text-gray-400 mb-4">
          {{ day.exercises.length }} exercícios neste dia
        </p>
        <AppButton variant="primary" @click="handleStartSession"> Iniciar Treino </AppButton>
      </div>

      <!-- Session in progress -->
      <div v-else>
        <!-- Progress bar -->
        <div class="mb-4">
          <div class="flex justify-between text-sm mb-1">
            <span class="text-gray-600 dark:text-gray-400">Progresso</span>
            <span class="font-medium">{{ progress.completed }}/{{ progress.total }}</span>
          </div>
          <q-linear-progress
            :value="progress.percentage / 100"
            color="primary"
            track-color="grey-3"
            rounded
            size="8px"
          />
        </div>

        <!-- Exercises list -->
        <div class="space-y-1 divide-y divide-gray-100 dark:divide-gray-700">
          <ExerciseCheckbox
            v-for="exercise in sessionExercises"
            :key="exercise.exerciseId"
            :name="exercise.name"
            :sets="exercise.sets"
            :reps="exercise.reps"
            :completed="exercise.completed"
            @toggle="handleToggleExercise(exercise.exerciseId)"
          />
        </div>

        <!-- Actions -->
        <div class="flex gap-3 mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
          <AppButton variant="outline" size="sm" @click="handleCancelSession"> Cancelar </AppButton>
          <AppButton
            variant="primary"
            size="sm"
            :disabled="progress.completed === 0"
            @click="handleFinishSession"
          >
            Finalizar Treino
          </AppButton>
        </div>
      </div>
    </div>
  </AppAccordion>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { AppAccordion, AppButton } from 'components/ui';
import ExerciseCheckbox from './ExerciseCheckbox.vue';
import { useWorkoutProgress } from 'src/composables/useWorkoutProgress';
import type {
  TrainingPlanResponse,
  DailyWorkoutResponse,
} from 'src/core/interfaces/workout.interface';

interface Props {
  plan: TrainingPlanResponse;
  day: DailyWorkoutResponse;
}

const props = defineProps<Props>();

const {
  currentSession,
  sessionProgress,
  startDaySession,
  toggleExercise,
  finishSession,
  cancelSession,
  isDayInProgress,
} = useWorkoutProgress();

const isInProgress = computed(() => isDayInProgress(props.plan.id, props.day.id));

const sessionExercises = computed(() => {
  if (!currentSession.value || !isInProgress.value) return [];
  return currentSession.value.exercises;
});

const progress = computed(() => {
  if (!isInProgress.value)
    return { completed: 0, total: props.day.exercises.length, percentage: 0 };
  return sessionProgress.value;
});

const progressBadge = computed(() => {
  if (isInProgress.value) {
    return `${progress.value.completed}/${progress.value.total}`;
  }
  return `${props.day.exercises.length} exercícios`;
});

const hasCompletedToday = computed(() => {
  // TODO: Check if completed today from history
  return false;
});

const handleStartSession = () => {
  startDaySession(props.plan, props.day);
};

const handleToggleExercise = (exerciseId: number) => {
  toggleExercise(exerciseId);
};

const handleFinishSession = () => {
  finishSession();
};

const handleCancelSession = () => {
  cancelSession();
};
</script>
