<template>
  <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
    <!-- Header -->
    <div class="bg-gradient-to-r from-primary-500 to-primary-600 px-6 py-4">
      <div class="flex items-center justify-between">
        <div>
          <p class="text-primary-50 text-sm font-medium">Treino de Hoje</p>
          <h2 class="text-white text-2xl font-bold mt-1">{{ workout.dayName }}</h2>
        </div>
        <div class="bg-white/20 backdrop-blur-sm rounded-xl px-4 py-2">
          <p class="text-white text-sm font-medium">{{ totalExercises }} exercícios</p>
        </div>
      </div>
    </div>

    <!-- Exercises List -->
    <div class="p-6 space-y-3">
      <div
        v-for="(exercise, index) in workout.exercises"
        :key="exercise.id"
        class="bg-gray-50 rounded-xl p-4 hover:bg-gray-100 transition-colors border border-gray-200"
      >
        <div class="flex items-start gap-4">
          <!-- Exercise Number -->
          <div
            class="flex-shrink-0 w-10 h-10 rounded-full bg-primary-100 text-primary-600 flex items-center justify-center font-bold text-sm"
          >
            {{ index + 1 }}
          </div>

          <!-- Exercise Info -->
          <div class="flex-1 min-w-0">
            <h3 class="text-gray-900 font-semibold text-base mb-1">
              {{ exercise.name }}
            </h3>
            <div class="flex items-center gap-4 text-sm">
              <div class="flex items-center gap-1.5 text-gray-600">
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
                    d="M4 6h16M4 12h16m-7 6h7"
                  />
                </svg>
                <span class="font-medium">{{ exercise.sets }} séries</span>
              </div>
              <div class="flex items-center gap-1.5 text-gray-600">
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
                    d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                  />
                </svg>
                <span class="font-medium">{{ exercise.reps }} reps</span>
              </div>
            </div>
          </div>

          <!-- Checkbox -->
          <div class="flex-shrink-0">
            <label class="flex items-center cursor-pointer">
              <input
                type="checkbox"
                class="w-6 h-6 text-primary-600 border-gray-300 rounded-lg focus:ring-primary-500 focus:ring-offset-0 cursor-pointer"
                @change="toggleExercise(exercise.id)"
              />
            </label>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <div class="px-6 pb-6">
      <button
        class="w-full bg-primary-600 hover:bg-primary-700 text-white font-semibold py-3.5 px-6 rounded-xl transition-colors shadow-sm"
      >
        Começar Treino
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import type { DailyWorkoutResponse } from 'src/core/interfaces/workout.interface';

interface Props {
  workout: DailyWorkoutResponse;
}

const props = defineProps<Props>();

const totalExercises = computed(() => props.workout.exercises.length);

const toggleExercise = (exerciseId: number) => {
  console.log('Exercise toggled:', exerciseId);
  // Implementar lógica de marcar exercício como concluído
};
</script>
