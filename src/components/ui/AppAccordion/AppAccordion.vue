<template>
  <q-expansion-item
    v-model="isExpanded"
    :header-class="['app-accordion-header', headerClass]"
    :class="['app-accordion', rootClass]"
    expand-separator
  >
    <template #header>
      <slot name="header">
        <div class="flex items-center justify-between w-full">
          <div class="flex items-center gap-3">
            <div>
              <h3 v-if="title" class="font-semibold">{{ title }}</h3>
              <p v-if="subtitle" class="text-sm text-grey-6 mt-0.5">{{ subtitle }}</p>
            </div>
            <div v-if="badge">
              <q-badge color="primary" :label="badge" />
            </div>
          </div>
          <div v-if="$slots.actions" class="flex items-center gap-1" @click.stop>
            <slot name="actions" />
          </div>
        </div>
      </slot>
    </template>

    <q-card flat class="app-accordion-content">
      <q-card-section>
        <slot />
      </q-card-section>
    </q-card>
  </q-expansion-item>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';

interface Props {
  title?: string;
  subtitle?: string;
  badge?: string | number;
  defaultExpanded?: boolean;
  headerClass?: string;
  rootClass?: string;
}

const props = withDefaults(defineProps<Props>(), {
  defaultExpanded: false,
  headerClass: '',
  rootClass: '',
});

const isExpanded = ref(props.defaultExpanded);

watch(
  () => props.defaultExpanded,
  (newValue) => {
    isExpanded.value = newValue;
  },
);
</script>

<style scoped>
.app-accordion {
  border-radius: 0.75rem;
  border: 1px solid rgba(0, 0, 0, 0.12);
  overflow: hidden;
}

.body--dark .app-accordion {
  border-color: rgba(255, 255, 255, 0.12);
}

.app-accordion-header {
  transition: background-color 0.2s;
}

.app-accordion-content {
  border-top: 1px solid rgba(0, 0, 0, 0.12);
}

.body--dark .app-accordion-content {
  border-top-color: rgba(255, 255, 255, 0.12);
}
</style>
