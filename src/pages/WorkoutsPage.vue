<template>
  <Page>
    <div class="max-w-4xl mx-auto">
      <!-- Header -->
      <div class="mb-6 flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">Meus Treinos</h1>
          <p class="text-gray-600 dark:text-gray-400">Gerencie seus planos de treino</p>
        </div>
        <AppButton variant="primary" @click="createNewWorkout"> + Novo Treino </AppButton>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <p class="text-gray-500">Carregando treinos...</p>
      </div>

      <!-- Training Plans List -->
      <div v-else-if="trainingPlans.length > 0" class="space-y-4">
        <AppAccordion
          v-for="plan in trainingPlans"
          :key="plan.id"
          :title="plan.name"
          :badge="`${plan.dailyWorkouts.length} dias`"
          :default-expanded="false"
        >
          <template #actions>
            <button
              @click.stop="editPlan(plan.id)"
              class="p-2 text-primary-600 hover:bg-primary-50 rounded-lg transition-colors"
              title="Editar plano"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-4 w-4"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                />
              </svg>
            </button>
            <button
              @click.stop="confirmDelete(plan.id, plan.name)"
              class="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
              title="Deletar plano"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-4 w-4"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                />
              </svg>
            </button>
          </template>

          <!-- Daily Workouts -->
          <div class="space-y-3">
            <AppCard v-for="workout in plan.dailyWorkouts" :key="workout.id">
              <template #header>
                <div class="flex items-center justify-between w-full">
                  <h4 class="font-semibold">{{ workout.dayName }}</h4>
                  <span class="text-sm text-grey-6">
                    {{ workout.exercises.length }} exercícios
                  </span>
                </div>
              </template>

              <!-- Exercises -->
              <div class="space-y-2">
                <div
                  v-for="(exercise, index) in workout.exercises"
                  :key="exercise.id"
                  class="flex items-center gap-3 py-2 border-t border-gray-100 dark:border-gray-700 first:border-t-0 first:pt-0"
                >
                  <span
                    class="flex-shrink-0 w-6 h-6 rounded-full bg-primary-100 dark:bg-primary-900 text-primary-600 dark:text-primary-400 flex items-center justify-center text-xs font-bold"
                  >
                    {{ index + 1 }}
                  </span>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium">
                      {{ exercise.name }}
                    </p>
                  </div>
                  <div class="flex items-center gap-3 text-xs text-grey-6">
                    <span>{{ exercise.sets }}x</span>
                    <span>{{ exercise.reps }}</span>
                  </div>
                </div>
              </div>
            </AppCard>
          </div>
        </AppAccordion>
      </div>

      <!-- Empty State -->
      <div
        v-else
        :class="[$q.dark.isActive ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200']"
        class="text-center py-12 rounded-xl border"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-16 w-16 text-gray-400 mx-auto mb-4"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
          />
        </svg>
        <h3
          :class="[$q.dark.isActive ? 'text-white' : 'text-gray-900']"
          class="text-lg font-semibold mb-2"
        >
          Nenhum treino cadastrado
        </h3>
        <p :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-600']" class="mb-4">
          Comece criando seu primeiro plano de treino
        </p>
        <AppButton variant="primary" @click="createNewWorkout"> Criar Treino </AppButton>
      </div>

      <!-- Delete Confirmation Modal -->
      <div
        v-if="showDeleteModal"
        class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
        @click.self="cancelDelete"
      >
        <div
          :class="[$q.dark.isActive ? 'bg-gray-800' : 'bg-white']"
          class="rounded-xl p-6 max-w-md w-full"
        >
          <h3
            :class="[$q.dark.isActive ? 'text-white' : 'text-gray-900']"
            class="text-lg font-bold mb-2"
          >
            Confirmar Exclusão
          </h3>
          <p :class="[$q.dark.isActive ? 'text-gray-300' : 'text-gray-600']" class="mb-6">
            Tem certeza que deseja deletar o treino <strong>"{{ planToDelete.name }}"</strong>? Esta
            ação não pode ser desfeita.
          </p>
          <div class="flex gap-3 justify-end">
            <AppButton variant="outline" @click="cancelDelete" :disabled="deleting">
              Cancelar
            </AppButton>
            <AppButton variant="danger" @click="handleDelete" :disabled="deleting">
              {{ deleting ? 'Deletando...' : 'Deletar' }}
            </AppButton>
          </div>
        </div>
      </div>
    </div>
  </Page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { Page } from 'components/layout';
import { AppAccordion, AppButton, AppCard } from 'components/ui';
import { useWorkout } from 'src/composables/useWorkout';
import { useToast } from 'src/composables/useToast';
import type { TrainingPlanResponse } from 'src/core/interfaces/workout.interface';

const $q = useQuasar();
const router = useRouter();
const { fetchWorkouts, deleteWorkout } = useWorkout();
const toast = useToast();

const trainingPlans = ref<TrainingPlanResponse[]>([]);
const loading = ref(false);
const showDeleteModal = ref(false);
const deleting = ref(false);
const planToDelete = ref({ id: 0, name: '' });

const loadWorkouts = async () => {
  try {
    loading.value = true;
    trainingPlans.value = await fetchWorkouts();
  } catch (error) {
    console.error('Erro ao carregar treinos:', error);
    toast.error('Erro ao carregar treinos');
  } finally {
    loading.value = false;
  }
};

const createNewWorkout = () => {
  void router.push('/workouts/create');
};

const editPlan = (planId: number) => {
  void router.push(`/workouts/${planId}/edit`);
};

const confirmDelete = (planId: number, planName: string) => {
  planToDelete.value = { id: planId, name: planName };
  showDeleteModal.value = true;
};

const cancelDelete = () => {
  showDeleteModal.value = false;
  planToDelete.value = { id: 0, name: '' };
};

const handleDelete = async () => {
  try {
    deleting.value = true;
    await deleteWorkout(planToDelete.value.id.toString());
    toast.success('Treino deletado com sucesso');
    showDeleteModal.value = false;
    await loadWorkouts();
  } catch (error) {
    console.error('Erro ao deletar treino:', error);
    toast.error('Erro ao deletar treino');
  } finally {
    deleting.value = false;
  }
};

onMounted(() => {
  void loadWorkouts();
});
</script>
