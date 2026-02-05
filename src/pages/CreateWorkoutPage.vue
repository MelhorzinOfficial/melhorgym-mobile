<template>
  <Page>
    <div class="max-w-5xl mx-auto">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">
          {{ isEditing ? 'Editar Treino' : 'Criar Novo Treino' }}
        </h1>
        <p class="text-gray-600 dark:text-gray-300">
          {{
            isEditing
              ? 'Atualize as informações do seu plano'
              : 'Crie um plano de treino completo com dias e exercícios'
          }}
        </p>
      </div>

      <!-- Form -->
      <AppForm
        title="Informações do Plano"
        layout="single"
        gap="lg"
        :loading="loading"
        @submit="handleSubmit"
      >
        <!-- Nome do Plano -->
        <AppFormField span="full">
          <AppInput
            v-model="form.name"
            label="Nome do Plano"
            placeholder="Ex: Treino ABC, Hipertrofia 4x"
            required
            :error="errors.name"
          />
        </AppFormField>

        <!-- Dias de Treino -->
        <AppFormField span="full">
          <div class="space-y-4">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
              Dias de Treino
              <span class="text-red-500 ml-0.5">*</span>
            </label>

            <!-- Empty State with Add Button -->
            <div
              v-if="form.dailyWorkouts.length === 0"
              class="text-center py-8 bg-gray-50 dark:bg-gray-800 rounded-lg border-2 border-dashed border-gray-300 dark:border-gray-600"
            >
              <p class="text-gray-500 dark:text-gray-400">Nenhum dia de treino adicionado</p>
              <p class="text-sm text-gray-400 dark:text-gray-500 mt-1">
                Clique no botão abaixo para começar
              </p>
              <AppButton type="button" variant="primary" class="mt-4" @click="addDailyWorkout">
                + Adicionar Dia de Treino
              </AppButton>
            </div>

            <!-- Daily Workouts List with Accordion -->
            <div v-else class="space-y-4">
              <AppAccordion
                v-for="(workout, workoutIndex) in form.dailyWorkouts"
                :key="workoutIndex"
                :title="workout.dayName || `Dia ${workoutIndex + 1}`"
                :badge="`${workout.exercises.length} exercícios`"
                :default-expanded="workoutIndex === form.dailyWorkouts.length - 1"
              >
                <template #actions>
                  <button
                    type="button"
                    @click.stop="removeDailyWorkout(workoutIndex)"
                    class="p-2 text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
                    title="Remover dia"
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

                <div class="space-y-4">
                  <!-- Day Name -->
                  <AppInput
                    v-model="workout.dayName"
                    label="Nome do Dia"
                    placeholder="Ex: A - Peito e Tríceps"
                    required
                  />

                  <!-- Exercises Section -->
                  <div class="pl-4 border-l-2 border-primary-200 dark:border-primary-700">
                    <label class="text-sm font-medium text-gray-700 dark:text-gray-300 block mb-3"
                      >Exercícios</label
                    >

                    <div
                      v-if="workout.exercises.length === 0"
                      class="text-sm text-gray-400 italic py-2"
                    >
                      Nenhum exercício adicionado
                    </div>

                    <!-- Exercises List -->
                    <div class="space-y-3">
                      <div
                        v-for="(exercise, exerciseIndex) in workout.exercises"
                        :key="exerciseIndex"
                        class="relative bg-gray-50 dark:bg-gray-700 rounded-lg p-3 space-y-3"
                      >
                        <!-- Remove Exercise Button -->
                        <button
                          type="button"
                          @click="removeExercise(workoutIndex, exerciseIndex)"
                          class="absolute top-2 right-2 p-1 text-red-600 dark:text-red-400 hover:text-red-800 dark:hover:text-red-300 hover:bg-red-100 dark:hover:bg-red-900/20 rounded transition-colors"
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
                              d="M6 18L18 6M6 6l12 12"
                            />
                          </svg>
                        </button>

                        <div class="space-y-3 pr-8">
                          <!-- Grupo Muscular (filtro) -->
                          <div>
                            <AppSelect
                              v-model="exercise.muscleGroupFilter"
                              placeholder="Filtrar por grupo"
                              :options="muscleGroupOptions"
                              size="sm"
                            />
                          </div>

                          <!-- Nome do Exercício (Autocomplete) -->
                          <div>
                            <AppAutocomplete
                              v-model="exercise.name"
                              placeholder="Digite ou selecione o exercício"
                              :options="getExerciseOptions(exercise.muscleGroupFilter)"
                              size="sm"
                              required
                              allow-custom-value
                            />
                          </div>

                          <!-- Séries e Reps -->
                          <div class="space-y-3">
                            <AppInput
                              v-model.number="exercise.sets"
                              type="number"
                              label="Séries"
                              placeholder="Ex: 3"
                              size="sm"
                              required
                            />
                            <AppInput
                              v-model="exercise.reps"
                              label="Repetições"
                              placeholder="Ex: 8-12"
                              size="sm"
                              required
                            />
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Add Exercise Button -->
                    <div class="mt-4">
                      <AppButton
                        type="button"
                        variant="outline"
                        size="sm"
                        class="p-2"
                        @click="addExercise(workoutIndex)"
                      >
                        + Exercício
                      </AppButton>
                    </div>
                  </div>
                </div>
              </AppAccordion>

              <!-- Add Day Button (at the end of the list) -->
              <div class="flex justify-center pt-2">
                <AppButton type="button" variant="outline" @click="addDailyWorkout">
                  + Adicionar Dia de Treino
                </AppButton>
              </div>
            </div>
          </div>
        </AppFormField>

        <!-- Actions -->
        <template #actions>
          <AppButton type="button" variant="outline" @click="handleCancel" :disabled="loading">
            Cancelar
          </AppButton>
          <AppButton type="submit" variant="primary" :disabled="loading || !isFormValid">
            {{ loading ? 'Salvando...' : isEditing ? 'Atualizar Treino' : 'Criar Treino' }}
          </AppButton>
        </template>
      </AppForm>
    </div>
  </Page>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { Page } from 'components/layout';
import {
  AppForm,
  AppFormField,
  AppInput,
  AppButton,
  AppAccordion,
  AppAutocomplete,
  AppSelect,
} from 'components/ui';
import { useWorkout } from 'src/composables/useWorkout';
import { useToast } from 'src/composables/useToast';
import type { CreateWorkoutInput, Exercise } from 'src/core/interfaces/workout.interface';
import {
  muscleGroups,
  searchExercises,
  getMuscleGroupByExerciseName,
  type MuscleGroup,
} from 'src/mock/exercises-library.mock';
import type { AutocompleteOption } from 'src/components/ui/AppAutocomplete/AppAutocomplete.types';

// Extended exercise type for form with local filter property
interface FormExercise extends Exercise {
  muscleGroupFilter: string;
}

interface FormDailyWorkout {
  dayName: string;
  exercises: FormExercise[];
}

interface FormData {
  name: string;
  dailyWorkouts: FormDailyWorkout[];
}

const router = useRouter();
const route = useRoute();
const toast = useToast();

const loading = ref(false);
const isEditing = computed(() => !!route.params.id);

// Initialize composable with workoutId if editing
const workoutComposable = computed(() => {
  return useWorkout(isEditing.value ? { workoutId: route.params.id as string } : undefined);
});

// Form state
const form = ref<FormData>({
  name: '',
  dailyWorkouts: [],
});

const errors = ref({
  name: '',
});

// Validação
const isFormValid = computed(() => {
  return (
    form.value.name.trim() !== '' &&
    form.value.dailyWorkouts.length > 0 &&
    form.value.dailyWorkouts.every(
      (workout) =>
        workout.dayName.trim() !== '' &&
        workout.exercises.length > 0 &&
        workout.exercises.every(
          (ex) => ex.name.trim() !== '' && ex.sets > 0 && ex.reps.trim() !== '',
        ),
    )
  );
});

// Muscle Group Options for Select
const muscleGroupOptions = computed(() => [
  { label: 'Todos os grupos', value: 'all' },
  ...muscleGroups.map((group) => ({ label: group.label, value: group.value })),
]);

// Get exercise options filtered by muscle group
const getExerciseOptions = (muscleGroup: string = 'all'): AutocompleteOption[] => {
  const exercises = searchExercises('', muscleGroup as MuscleGroup | 'all');
  return exercises.map((ex) => ({
    label: ex.name,
    value: ex.name,
    group: muscleGroups.find((g) => g.value === ex.muscleGroup)?.label ?? '',
  }));
};

// Daily Workout operations
const addDailyWorkout = () => {
  form.value.dailyWorkouts.push({
    dayName: '',
    exercises: [],
  });
};

const removeDailyWorkout = (index: number) => {
  form.value.dailyWorkouts.splice(index, 1);
};

// Exercise operations
const addExercise = (workoutIndex: number) => {
  const workout = form.value.dailyWorkouts[workoutIndex];
  if (workout) {
    workout.exercises.push({
      name: '',
      sets: 0,
      reps: '',
      muscleGroupFilter: 'all', // Filtro local, não vai no payload
    });
  }
};

const removeExercise = (workoutIndex: number, exerciseIndex: number) => {
  const workout = form.value.dailyWorkouts[workoutIndex];
  if (workout) {
    workout.exercises.splice(exerciseIndex, 1);
  }
};

// Form handlers
const handleSubmit = async () => {
  errors.value.name = '';

  if (!form.value.name.trim()) {
    errors.value.name = 'Nome do plano é obrigatório';
    return;
  }

  if (form.value.dailyWorkouts.length === 0) {
    toast.error('Adicione pelo menos um dia de treino');
    return;
  }

  try {
    loading.value = true;

    // Convert FormData to CreateWorkoutInput (remove muscleGroupFilter)
    const payload: CreateWorkoutInput = {
      name: form.value.name,
      dailyWorkouts: form.value.dailyWorkouts.map((dw) => ({
        dayName: dw.dayName,
        exercises: dw.exercises.map(({ name, sets, reps }) => ({ name, sets, reps })),
      })),
    };

    if (isEditing.value) {
      await workoutComposable.value.updateWorkout(route.params.id as string, payload);
      toast.success('Treino atualizado com sucesso!');
    } else {
      await workoutComposable.value.createWorkout(payload);
      toast.success('Treino criado com sucesso!');
    }

    void router.push('/workouts');
  } catch (error) {
    console.error('Erro ao salvar treino:', error);
    toast.error('Erro ao salvar treino. Tente novamente.');
  } finally {
    loading.value = false;
  }
};

const handleCancel = () => {
  void router.push('/workouts');
};

// Watch para atualizar o filtro automaticamente quando o nome do exercício mudar
watch(
  () => form.value.dailyWorkouts,
  () => {
    form.value.dailyWorkouts.forEach((workout) => {
      workout.exercises.forEach((exercise) => {
        if (exercise.name) {
          const detectedGroup = getMuscleGroupByExerciseName(exercise.name);
          if (detectedGroup !== 'all') {
            exercise.muscleGroupFilter = detectedGroup;
          }
        }
      });
    });
  },
  { deep: true },
);

// Load workout data if editing
onMounted(async () => {
  if (isEditing.value) {
    try {
      loading.value = true;
      const workout = await workoutComposable.value.fetchWorkout();
      form.value = {
        name: workout.name,
        dailyWorkouts: workout.dailyWorkouts.map((dw) => ({
          dayName: dw.dayName,
          exercises: dw.exercises.map((ex) => ({
            name: ex.name,
            sets: ex.sets,
            reps: ex.reps,
            muscleGroupFilter: getMuscleGroupByExerciseName(ex.name),
          })),
        })),
      };
    } catch (error) {
      console.error('Erro ao carregar treino:', error);
      toast.error('Erro ao carregar treino');
      void router.push('/workouts');
    } finally {
      loading.value = false;
    }
  }
});
</script>
