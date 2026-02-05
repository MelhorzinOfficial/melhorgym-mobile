<template>
  <div
    :class="[
      'flex items-center gap-3 py-3 px-2 rounded-lg cursor-pointer transition-all',
      completed ? 'bg-green-50 dark:bg-green-900/20' : 'hover:bg-gray-50 dark:hover:bg-gray-700/50',
    ]"
    @click="$emit('toggle')"
  >
    <!-- Checkbox -->
    <div
      :class="[
        'flex-shrink-0 w-6 h-6 rounded-full border-2 flex items-center justify-center transition-all',
        completed ? 'bg-green-500 border-green-500' : 'border-gray-300 dark:border-gray-600',
      ]"
    >
      <q-icon v-if="completed" name="check" size="16px" color="white" />
    </div>

    <!-- Exercise Info -->
    <div class="flex-1 min-w-0">
      <p
        :class="['font-medium', completed ? 'text-green-700 dark:text-green-400 line-through' : '']"
      >
        {{ name }}
      </p>
      <p class="text-sm text-gray-500 dark:text-gray-400">{{ sets }} séries × {{ reps }} reps</p>
    </div>

    <!-- Status Icon -->
    <q-icon v-if="completed" name="check_circle" size="24px" color="positive" />
  </div>
</template>

<script setup lang="ts">
interface Props {
  name: string;
  sets: number;
  reps: string;
  completed: boolean;
}

defineProps<Props>();

defineEmits<{
  toggle: [];
}>();
</script>
