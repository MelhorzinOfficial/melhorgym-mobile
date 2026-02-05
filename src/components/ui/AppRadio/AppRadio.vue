<template>
  <div :class="['w-full', containerClass]">
    <!-- Group Label -->
    <label v-if="label" class="block text-sm font-medium mb-3">
      {{ label }}
      <span v-if="required" class="text-red-500 ml-0.5">*</span>
    </label>

    <!-- Radio Options -->
    <q-option-group
      :model-value="modelValue"
      :options="mappedOptions"
      :inline="orientation === 'horizontal'"
      :disable="disabled"
      :dense="size === 'sm'"
      :class="[
        'app-radio-group',
        size === 'lg' && 'app-radio-group--lg',
        error && 'app-radio-group--error',
      ]"
      @update:model-value="handleChange"
    />

    <!-- Group Helper Text or Error Message -->
    <p
      v-if="error || helperText"
      :class="['mt-2 text-sm', error ? 'text-red-600' : 'text-grey-6']"
    >
      {{ error || helperText }}
    </p>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import type { AppRadioProps, AppRadioEmits } from './AppRadio.types';

const props = withDefaults(defineProps<AppRadioProps>(), {
  disabled: false,
  required: false,
  size: 'md',
  orientation: 'vertical',
});

const emit = defineEmits<AppRadioEmits>();

const mappedOptions = computed(() =>
  props.options.map((opt) => ({
    label: opt.label,
    value: opt.value,
    disable: opt.disabled,
  }))
);

const handleChange = (value: string | number) => {
  emit('update:modelValue', value);
  emit('change', value);
};
</script>

<style scoped>
.app-radio-group--lg :deep(.q-radio__label) {
  font-size: 1.125rem;
}

.app-radio-group--error :deep(.q-radio__inner) {
  color: var(--q-negative);
}
</style>
