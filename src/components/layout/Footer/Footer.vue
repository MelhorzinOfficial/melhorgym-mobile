<script setup lang="ts">
import { useRoute } from 'vue-router';
import type { FooterProps, NavigationItem } from './interfaces/footer.interface';

const _props = withDefaults(defineProps<FooterProps>(), {
  fixed: true,
  elevated: false,
  navigationItems: () => [
    {
      id: 'home',
      label: 'Início',
      icon: 'home',
      to: '/',
    },
    {
      id: 'workouts',
      label: 'Treinos',
      icon: 'fitness_center',
      to: '/workouts',
    },
  ],
});

const route = useRoute();

const isItemActive = (item: NavigationItem) => {
  if (item.active !== undefined) {
    return item.active;
  }
  return item.to === route.path;
};
</script>

<template>
  <q-footer :elevated="_props.elevated" class="app-footer">
    <q-tabs dense indicator-color="transparent" class="app-footer-tabs">
      <q-route-tab
        v-for="item in navigationItems"
        :key="item.id"
        :to="item.to"
        :icon="item.icon"
        :label="item.label"
        no-caps
        :class="{ 'text-primary': isItemActive(item) }"
      >
        <q-badge v-if="item.badge" color="negative" floating rounded>
          {{ item.badge }}
        </q-badge>
      </q-route-tab>
    </q-tabs>
  </q-footer>
</template>

<style scoped>
.app-footer {
  background: #1f2937;
  padding-bottom: var(--footer-bottom-padding, 0px);
}

.body--light .app-footer {
  background: white;
  border-top: 1px solid rgba(0, 0, 0, 0.12);
}

.body--dark .app-footer {
  border-top: 1px solid rgba(255, 255, 255, 0.12);
}

.app-footer-tabs :deep(.q-tab) {
  min-width: 0;
  padding: 8px 0;
}

.app-footer-tabs :deep(.q-tab__label) {
  font-size: 0.75rem;
}

/* Texto cinza no light mode quando não selecionado */
.body--light .app-footer-tabs :deep(.q-tab) {
  color: #6b7280;
}

.body--light .app-footer-tabs :deep(.q-tab.text-primary) {
  color: var(--q-primary);
}

/* Texto claro no dark mode */
.body--dark .app-footer-tabs :deep(.q-tab) {
  color: #9ca3af;
}

.body--dark .app-footer-tabs :deep(.q-tab.text-primary) {
  color: var(--q-primary);
}
</style>
