<template>
  <form :class="['w-full', containerClass]" @submit.prevent="handleSubmit">
    <!-- Form Header -->
    <div v-if="title || subtitle" class="mb-6">
      <h2 v-if="title" class="text-2xl font-bold text-gray-900 dark:text-white mb-2">
        {{ title }}
      </h2>
      <p v-if="subtitle" class="text-gray-600 dark:text-gray-300">
        {{ subtitle }}
      </p>
    </div>

    <!-- Form Grid -->
    <div
      :class="[
        'grid',
        layoutClasses[layout],
        gapClasses[gap],
        loading && 'opacity-50 pointer-events-none',
      ]"
    >
      <slot />
    </div>

    <!-- Form Actions (buttons, etc) -->
    <div v-if="$slots.actions" class="mt-6 flex gap-3 justify-end">
      <slot name="actions" />
    </div>
  </form>
</template>

<script setup lang="ts">
import type { AppFormProps, AppFormEmits, FormLayout } from './AppForm.types';

const props = withDefaults(defineProps<AppFormProps>(), {
  layout: 'single',
  gap: 'md',
  loading: false,
});

const emit = defineEmits<AppFormEmits>();

const layoutClasses: Record<FormLayout, string> = {
  single: 'grid-cols-1',
  double: 'grid-cols-1 md:grid-cols-2',
  triple: 'grid-cols-1 md:grid-cols-2 lg:grid-cols-3',
  auto: 'grid-cols-1 md:grid-cols-[repeat(auto-fit,minmax(250px,1fr))]',
};

const gapClasses: Record<string, string> = {
  sm: 'gap-3',
  md: 'gap-4',
  lg: 'gap-6',
};

const handleSubmit = (event: Event) => {
  if (!props.loading) {
    emit('submit', event);
  }
};
</script>
