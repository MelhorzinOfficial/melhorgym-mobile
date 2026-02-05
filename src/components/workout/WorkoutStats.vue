<template>
  <div class="grid grid-cols-3 gap-4">
    <!-- Treinos este mês -->
    <div
      :class="[$q.dark.isActive ? 'bg-gray-800' : 'bg-white']"
      class="rounded-xl p-4 text-center shadow-sm"
    >
      <div
        :class="[$q.dark.isActive ? 'bg-primary/20' : 'bg-orange-100']"
        class="w-12 h-12 mx-auto mb-2 rounded-full flex items-center justify-center"
      >
        <q-icon name="fitness_center" size="24px" color="primary" />
      </div>
      <p :class="[$q.dark.isActive ? 'text-white' : 'text-gray-900']" class="text-2xl font-bold">
        {{ sessionsThisMonth }}
      </p>
      <p :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-500']" class="text-sm">
        treinos este mês
      </p>
    </div>

    <!-- Streak -->
    <div
      :class="[$q.dark.isActive ? 'bg-gray-800' : 'bg-white']"
      class="rounded-xl p-4 text-center shadow-sm"
    >
      <div
        :class="[$q.dark.isActive ? 'bg-orange-900/30' : 'bg-orange-100']"
        class="w-12 h-12 mx-auto mb-2 rounded-full flex items-center justify-center"
      >
        <q-icon name="local_fire_department" size="24px" color="orange" />
      </div>
      <p :class="[$q.dark.isActive ? 'text-white' : 'text-gray-900']" class="text-2xl font-bold">
        {{ currentStreak }}
      </p>
      <p :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-500']" class="text-sm">
        dias seguidos
      </p>
    </div>

    <!-- Total exercícios -->
    <div
      :class="[$q.dark.isActive ? 'bg-gray-800' : 'bg-white']"
      class="rounded-xl p-4 text-center shadow-sm"
    >
      <div
        :class="[$q.dark.isActive ? 'bg-green-900/30' : 'bg-green-100']"
        class="w-12 h-12 mx-auto mb-2 rounded-full flex items-center justify-center"
      >
        <q-icon name="check_circle" size="24px" color="positive" />
      </div>
      <p :class="[$q.dark.isActive ? 'text-white' : 'text-gray-900']" class="text-2xl font-bold">
        {{ totalExercises }}
      </p>
      <p :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-500']" class="text-sm">
        exercícios feitos
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useQuasar } from 'quasar';

const $q = useQuasar();

interface Props {
  sessionsThisMonth: number;
  currentStreak: number;
  totalExercises: number;
}

defineProps<Props>();
</script>
