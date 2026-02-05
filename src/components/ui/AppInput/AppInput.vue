<template>
  <div :class="['w-full', containerClass]">
    <q-input
      :model-value="modelValue"
      :label="label"
      :placeholder="placeholder"
      :type="inputType"
      :disable="disabled"
      :readonly="readonly"
      :error="!!error"
      :error-message="error"
      :hint="helperText"
      :hide-bottom-space="!error && !helperText"
      :dense="size === 'sm'"
      outlined
      :class="['app-input', size === 'lg' && 'app-input--lg']"
      @update:model-value="handleInput"
      @blur="handleBlur"
      @focus="handleFocus"
    >
      <template v-if="prefixIcon" #prepend>
        <q-icon :name="prefixIcon" />
      </template>
      <template v-if="type === 'password' && showPasswordToggle" #append>
        <q-icon
          :name="passwordVisible ? 'visibility_off' : 'visibility'"
          class="cursor-pointer"
          @click="togglePasswordVisibility"
        />
      </template>
      <template v-else-if="suffixIcon" #append>
        <q-icon :name="suffixIcon" />
      </template>
    </q-input>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import type { AppInputProps, AppInputEmits } from './AppInput.types';

const props = withDefaults(defineProps<AppInputProps>(), {
  type: 'text',
  disabled: false,
  readonly: false,
  required: false,
  size: 'md',
  showPasswordToggle: true,
});

const emit = defineEmits<AppInputEmits>();

const passwordVisible = ref(false);

const inputType = computed(() => {
  if (props.type === 'password') {
    return passwordVisible.value ? 'text' : 'password';
  }
  return props.type;
});

function handleInput(value: string | number | null) {
  emit('update:modelValue', value ?? '');
}

function handleBlur(event: Event) {
  emit('blur', event as FocusEvent);
}

function handleFocus(event: Event) {
  emit('focus', event as FocusEvent);
}

function togglePasswordVisibility() {
  passwordVisible.value = !passwordVisible.value;
}
</script>

<style scoped>
.app-input :deep(.q-field__control) {
  border-radius: 0.5rem;
  background: white;
}

.body--dark .app-input :deep(.q-field__control) {
  background: #374151;
}

.app-input--lg :deep(.q-field__control) {
  min-height: 56px;
}

.app-input--lg :deep(.q-field__native) {
  font-size: 1.125rem;
}
</style>
