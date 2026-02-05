<template>
  <div :class="[spanClasses[span], containerClass]">
    <slot />
  </div>
</template>

<script setup lang="ts">
import type { AppFormFieldProps, FieldSpan } from './AppFormField.types';

const _props = withDefaults(defineProps<AppFormFieldProps>(), {
  span: 1,
});

const spanClasses: Record<FieldSpan, string> = {
  1: 'col-span-1',
  2: 'col-span-1 md:col-span-2',
  3: 'col-span-1 md:col-span-2 lg:col-span-3',
  full: 'col-span-full',
};
</script>
