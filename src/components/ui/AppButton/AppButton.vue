<template>
  <q-btn
    :type="type"
    :disable="disabled"
    :loading="loading"
    :dense="size === 'sm'"
    :size="size === 'lg' ? 'lg' : size === 'sm' ? 'sm' : 'md'"
    :color="buttonColor"
    :text-color="textColor"
    :outline="variant === 'outline'"
    :flat="variant === 'ghost'"
    :class="['app-btn', fullWidth && 'full-width', `app-btn--${variant}`]"
    no-caps
    unelevated
  >
    <q-icon v-if="icon && !loading" :name="icon" :size="iconSize" class="q-mr-sm" />
    <slot />
  </q-btn>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import type { AppButtonProps } from './AppButton.types';

const props = withDefaults(defineProps<AppButtonProps>(), {
  type: 'button',
  variant: 'primary',
  size: 'md',
  disabled: false,
  loading: false,
  fullWidth: false,
});

const buttonColor = computed(() => {
  switch (props.variant) {
    case 'primary':
      return 'primary';
    case 'secondary':
      return 'grey-7';
    case 'outline':
      return 'primary';
    case 'ghost':
      return undefined;
    case 'danger':
      return 'negative';
    default:
      return 'primary';
  }
});

const textColor = computed(() => {
  switch (props.variant) {
    case 'ghost':
      return 'grey-8';
    default:
      return undefined;
  }
});

const iconSize = computed(() => {
  switch (props.size) {
    case 'sm':
      return '16px';
    case 'lg':
      return '24px';
    default:
      return '20px';
  }
});
</script>

<style scoped>
.app-btn {
  border-radius: 0.5rem;
  font-weight: 600;
}

.app-btn.full-width {
  width: 100%;
}
</style>
