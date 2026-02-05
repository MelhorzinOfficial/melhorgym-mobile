<template>
  <div :class="['w-full', containerClass]">
    <!-- Trigger Input -->
    <q-input
      :model-value="displayValue"
      :label="label"
      :placeholder="placeholder"
      :disable="disabled"
      :error="!!error"
      :error-message="error"
      :hint="helperText"
      :hide-bottom-space="!error && !helperText"
      :dense="size === 'sm'"
      outlined
      readonly
      :class="['app-select', size === 'lg' && 'app-select--lg']"
      @click="openBottomSheet"
    >
      <template #append>
        <q-icon name="expand_more" class="cursor-pointer" />
      </template>
    </q-input>

    <!-- Bottom Sheet -->
    <AppBottomSheet v-model="isOpen" :title="label || placeholder">
      <template #default="{ isDark }">
        <q-list :class="{ 'bg-transparent': true }">
          <q-item
            v-for="option in options"
            :key="option.value"
            clickable
            v-close-popup
            :active="modelValue === option.value"
            :class="[
              modelValue === option.value
                ? 'text-primary ' + (isDark ? 'bg-primary-900/20' : 'bg-primary-50')
                : isDark
                  ? 'text-white'
                  : 'text-gray-900',
              isDark ? 'hover:bg-gray-700/50' : 'hover:bg-gray-100',
            ]"
            @click="selectOption(option)"
          >
            <q-item-section class="overflow-hidden">
              <q-item-label class="truncate">{{ option.label }}</q-item-label>
            </q-item-section>
            <q-item-section v-if="modelValue === option.value" side>
              <q-icon name="check" color="primary" />
            </q-item-section>
          </q-item>
        </q-list>
      </template>
    </AppBottomSheet>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { AppBottomSheet } from '../AppBottomSheet';
import type { AppSelectProps, AppSelectEmits, SelectOption } from './AppSelect.types';

const props = withDefaults(defineProps<AppSelectProps>(), {
  disabled: false,
  required: false,
  size: 'md',
  placeholder: 'Selecione uma opção',
});

const emit = defineEmits<AppSelectEmits>();

const isOpen = ref(false);

const displayValue = computed(() => {
  const selected = props.options.find((opt) => opt.value === props.modelValue);
  return selected?.label ?? '';
});

const openBottomSheet = () => {
  if (!props.disabled) {
    isOpen.value = true;
  }
};

const selectOption = (option: SelectOption) => {
  emit('update:modelValue', option.value);
  emit('change', option.value);
  isOpen.value = false;
};
</script>

<style scoped>
.app-select :deep(.q-field__control) {
  border-radius: 0.5rem;
  cursor: pointer;
}

.app-select--lg :deep(.q-field__control) {
  min-height: 56px;
}

.app-select--lg :deep(.q-field__native) {
  font-size: 1.125rem;
}
</style>
