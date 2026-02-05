<template>
  <div :class="['w-full', containerClass]">
    <q-checkbox
      :model-value="modelValue"
      :disable="disabled"
      :label="label"
      :dense="size === 'sm'"
      :class="['app-checkbox', size === 'lg' && 'app-checkbox--lg', error && 'app-checkbox--error']"
      @update:model-value="handleChange"
    >
      <template v-if="required" #default>
        {{ label }}
        <span class="text-red-500 ml-0.5">*</span>
      </template>
    </q-checkbox>

    <p
      v-if="error || helperText"
      :class="['mt-1 text-sm ml-8', error ? 'text-red-600' : 'text-grey-6']"
    >
      {{ error || helperText }}
    </p>
  </div>
</template>

<script setup lang="ts">
import type { AppCheckboxProps, AppCheckboxEmits } from './AppCheckbox.types';

const _props = withDefaults(defineProps<AppCheckboxProps>(), {
  modelValue: false,
  disabled: false,
  required: false,
  size: 'md',
});

const emit = defineEmits<AppCheckboxEmits>();

const handleChange = (value: boolean) => {
  emit('update:modelValue', value);
  emit('change', value);
};
</script>

<style scoped>
.app-checkbox--lg :deep(.q-checkbox__label) {
  font-size: 1.125rem;
}

.app-checkbox--error :deep(.q-checkbox__inner) {
  color: var(--q-negative);
}
</style>
