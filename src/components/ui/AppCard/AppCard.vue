<template>
  <q-card
    :class="[
      'app-card',
      hoverable && 'app-card--hoverable',
      clickable && 'cursor-pointer',
      `app-card--${padding}`,
    ]"
    :flat="variant === 'secondary'"
    bordered
    @click="handleClick"
  >
    <!-- Header (optional) -->
    <q-card-section v-if="$slots.header || title" class="q-pb-none">
      <slot name="header">
        <div class="flex items-center justify-between">
          <div class="text-lg font-semibold">{{ title }}</div>
          <slot name="headerActions" />
        </div>
      </slot>
    </q-card-section>

    <!-- Content -->
    <q-card-section :class="!contentPadding && 'q-pa-none'">
      <slot />
    </q-card-section>

    <!-- Footer (optional) -->
    <q-card-section v-if="$slots.footer" class="q-pt-none">
      <slot name="footer" />
    </q-card-section>
  </q-card>
</template>

<script setup lang="ts">
import type { AppCardProps, AppCardEmits } from './AppCard.types';

const props = withDefaults(defineProps<AppCardProps>(), {
  variant: 'default',
  padding: 'md',
  hoverable: false,
  clickable: false,
  headerPadding: true,
  contentPadding: true,
  footerPadding: true,
});

const emit = defineEmits<AppCardEmits>();

function handleClick(event: MouseEvent) {
  if (props.clickable) {
    emit('click', event);
  }
}
</script>

<style scoped>
.app-card {
  border-radius: 0.75rem;
}

.app-card--hoverable:hover {
  box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1);
}

.app-card--sm :deep(.q-card__section) {
  padding: 0.75rem;
}

.app-card--lg :deep(.q-card__section) {
  padding: 1.5rem;
}
</style>
