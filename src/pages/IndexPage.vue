<template>
  <Page>
    <div class="max-w-3xl mx-auto">
      <!-- Welcome Section -->
      <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white mb-1">
          Olá, {{ userName }}! 👋
        </h1>
        <p class="text-gray-600 dark:text-gray-400">Pronto para treinar hoje?</p>
      </div>

      <!-- Stats -->
      <WorkoutStats
        :sessions-this-month="stats.sessionsThisMonth"
        :current-streak="stats.currentStreak"
        :total-exercises="stats.totalExercises"
        class="mb-6"
      />

      <!-- Plan Selection - só mostra se tem planos -->
      <div v-if="trainingPlans.length > 0" class="mb-6">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          Selecione um plano de treino
        </label>
        <AppSelect
          :model-value="activePlanId ?? ''"
          :options="planOptions"
          placeholder="Escolha seu plano..."
          @update:model-value="handleSelectPlan"
        />
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <q-spinner-dots size="40px" color="primary" />
        <p class="text-gray-500 dark:text-gray-400 mt-2">Carregando planos...</p>
      </div>

      <!-- No Plans -->
      <div
        v-else-if="trainingPlans.length === 0"
        :class="[$q.dark.isActive ? 'bg-gray-800' : 'bg-white']"
        class="text-center py-12 rounded-xl"
      >
        <q-icon name="fitness_center" size="48px" color="grey-5" />
        <h3
          :class="[$q.dark.isActive ? 'text-white' : 'text-gray-900']"
          class="text-lg font-semibold mt-4"
        >
          Nenhum plano cadastrado
        </h3>
        <p :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-500']" class="mt-1 mb-4">
          Crie seu primeiro plano de treino para começar
        </p>
        <AppButton variant="primary" @click="goToCreateWorkout"> Criar Plano </AppButton>
      </div>

      <!-- Active Plan Days -->
      <div v-else-if="activePlan" class="space-y-3">
        <div class="flex items-center justify-between mb-2">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white">
            {{ activePlan.name }}
          </h2>
          <span class="text-sm text-gray-500 dark:text-gray-400">
            {{ activePlan.dailyWorkouts.length }} dias
          </span>
        </div>

        <WorkoutDayAccordion
          v-for="day in activePlan.dailyWorkouts"
          :key="day.id"
          :plan="activePlan"
          :day="day"
        />
      </div>

      <!-- No Active Plan Selected -->
      <div
        v-else
        :class="[$q.dark.isActive ? 'bg-gray-800' : 'bg-white']"
        class="text-center py-12 rounded-xl"
      >
        <q-icon name="touch_app" size="48px" color="grey-5" />
        <h3
          :class="[$q.dark.isActive ? 'text-white' : 'text-gray-900']"
          class="text-lg font-semibold mt-4"
        >
          Selecione um plano
        </h3>
        <p :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-500']" class="mt-1">
          Escolha um plano acima para ver os dias de treino
        </p>
      </div>
    </div>
  </Page>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { Page } from 'components/layout';
import { AppSelect, AppButton } from 'components/ui';
import { WorkoutDayAccordion, WorkoutStats } from 'src/components/workout';
import { useAuth } from 'src/composables/useAuth';
import { useWorkout } from 'src/composables/useWorkout';
import { useWorkoutProgress } from 'src/composables/useWorkoutProgress';
import type { TrainingPlanResponse } from 'src/core/interfaces/workout.interface';

const $q = useQuasar();
const router = useRouter();
const { userName } = useAuth();
const { fetchWorkouts } = useWorkout();
const { activePlanId, selectPlan, stats } = useWorkoutProgress();

const loading = ref(false);
const trainingPlans = ref<TrainingPlanResponse[]>([]);

const planOptions = computed(() =>
  trainingPlans.value.map((plan) => ({
    label: `${plan.name} (${plan.dailyWorkouts.length} dias)`,
    value: plan.id,
  })),
);

const activePlan = computed(
  () => trainingPlans.value.find((plan) => plan.id === activePlanId.value) ?? null,
);

const handleSelectPlan = (planId: string | number) => {
  selectPlan(planId ? Number(planId) : null);
};

const goToCreateWorkout = () => {
  router.push('/workouts/create');
};

const loadPlans = async () => {
  try {
    loading.value = true;
    trainingPlans.value = await fetchWorkouts();
  } catch (error) {
    console.error('Error loading plans:', error);
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  loadPlans();
});
</script>
