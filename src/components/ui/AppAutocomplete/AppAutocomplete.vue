<template>
  <div :class="['w-full', containerClass]">
    <!-- Trigger Input -->
    <q-input
      :model-value="modelValue"
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
      :class="['app-autocomplete', size === 'lg' && 'app-autocomplete--lg']"
      @click="openBottomSheet"
    >
      <template #append>
        <q-icon name="search" class="cursor-pointer" />
      </template>
    </q-input>

    <!-- Bottom Sheet -->
    <AppBottomSheet
      v-model="isOpen"
      :title="label || placeholder"
      show-search
      :search-placeholder="placeholder"
    >
      <template #default="{ searchQuery, isDark }">
        <q-list :class="{ 'bg-transparent': true }">
          <!-- Filtered Options -->
          <template v-if="getFilteredOptions(searchQuery).length > 0">
            <q-item
              v-for="option in getFilteredOptions(searchQuery)"
              :key="option.value"
              clickable
              :active="modelValue === option.label"
              :class="[
                modelValue === option.label
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
              <q-item-section v-if="option.group" side class="flex-shrink-0">
                <q-item-label caption :class="isDark ? 'text-gray-400' : 'text-gray-500'">
                  {{ option.group }}
                </q-item-label>
              </q-item-section>
              <q-item-section v-if="modelValue === option.label" side class="flex-shrink-0">
                <q-icon name="check" color="primary" />
              </q-item-section>
            </q-item>
          </template>

          <!-- No Results -->
          <q-item v-else-if="searchQuery.trim()" :class="isDark ? 'text-white' : 'text-gray-900'">
            <q-item-section
              :class="['text-center py-4', isDark ? 'text-gray-400' : 'text-gray-500']"
            >
              <template v-if="allowCustomValue">
                <q-item-label>Nenhum resultado encontrado</q-item-label>
                <q-btn flat color="primary" class="mt-2" @click="useCustomValue(searchQuery)">
                  Usar "{{ searchQuery }}"
                </q-btn>
              </template>
              <template v-else>
                <q-item-label>Nenhum resultado encontrado</q-item-label>
              </template>
            </q-item-section>
          </q-item>

          <!-- Empty State -->
          <q-item v-else :class="isDark ? 'text-white' : 'text-gray-900'">
            <q-item-section
              :class="['text-center py-4', isDark ? 'text-gray-400' : 'text-gray-500']"
            >
              <q-item-label>Digite para buscar</q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
      </template>
    </AppBottomSheet>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { AppBottomSheet } from '../AppBottomSheet';
import type {
  AppAutocompleteProps,
  AppAutocompleteEmits,
  AutocompleteOption,
} from './AppAutocomplete.types';

const props = withDefaults(defineProps<AppAutocompleteProps>(), {
  disabled: false,
  required: false,
  size: 'md',
  placeholder: 'Digite para buscar...',
  allowCustomValue: false,
});

const emit = defineEmits<AppAutocompleteEmits>();

const isOpen = ref(false);

const openBottomSheet = () => {
  if (!props.disabled) {
    isOpen.value = true;
  }
};

const getFilteredOptions = (searchQuery: string): AutocompleteOption[] => {
  if (!searchQuery.trim()) {
    return props.options;
  }
  const needle = searchQuery.toLowerCase();
  return props.options.filter((opt) => opt.label.toLowerCase().includes(needle));
};

const selectOption = (option: AutocompleteOption) => {
  emit('update:modelValue', option.label);
  emit('change', option.label);
  isOpen.value = false;
};

const useCustomValue = (value: string) => {
  emit('update:modelValue', value);
  emit('change', value);
  isOpen.value = false;
};
</script>

<style scoped>
.app-autocomplete :deep(.q-field__control) {
  border-radius: 0.5rem;
  cursor: pointer;
}

.app-autocomplete--lg :deep(.q-field__control) {
  min-height: 56px;
}

.app-autocomplete--lg :deep(.q-field__native) {
  font-size: 1.125rem;
}
</style>
