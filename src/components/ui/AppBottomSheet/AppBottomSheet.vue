<template>
  <teleport to="body">
    <transition name="fade">
      <div v-if="modelValue" class="app-bottom-sheet-overlay" @click="close" />
    </transition>
    <transition name="slide-up">
      <div v-if="modelValue" :class="['app-bottom-sheet-container', isDark ? 'dark' : 'light']">
        <!-- Handle -->
        <div class="app-bottom-sheet-handle">
          <div :class="['handle-bar', isDark ? 'dark' : 'light']" />
        </div>

        <!-- Header -->
        <div
          v-if="title || $slots.header"
          :class="['app-bottom-sheet-header', isDark ? 'dark' : 'light']"
        >
          <slot name="header">
            <h3 :class="['app-bottom-sheet-title', isDark ? 'dark' : 'light']">
              {{ title }}
            </h3>
          </slot>
        </div>

        <!-- Search Input (for autocomplete) -->
        <div
          v-if="showSearch"
          :class="['app-bottom-sheet-search-container', isDark ? 'dark' : 'light']"
        >
          <q-input
            ref="searchInputRef"
            v-model="searchQuery"
            :placeholder="searchPlaceholder"
            outlined
            dense
            clearable
            autofocus
            :dark="isDark"
            class="app-bottom-sheet-search-input"
          >
            <template #prepend>
              <q-icon name="search" :class="isDark ? 'text-gray-400' : 'text-gray-500'" />
            </template>
          </q-input>
        </div>

        <!-- Content -->
        <div :class="['app-bottom-sheet-content', isDark ? 'dark' : 'light']">
          <slot :search-query="searchQuery" :is-dark="isDark" />
        </div>
      </div>
    </transition>
  </teleport>
</template>

<script setup lang="ts">
import { ref, watch, nextTick, computed } from 'vue';
import { useQuasar } from 'quasar';

interface Props {
  modelValue: boolean;
  title?: string;
  showSearch?: boolean;
  searchPlaceholder?: string;
}

const props = withDefaults(defineProps<Props>(), {
  showSearch: false,
  searchPlaceholder: 'Buscar...',
});

const emit = defineEmits<{
  'update:modelValue': [value: boolean];
}>();

const $q = useQuasar();
const isDark = computed(() => $q.dark.isActive);

const searchQuery = ref('');
const searchInputRef = ref<HTMLInputElement | null>(null);

const close = () => {
  emit('update:modelValue', false);
  searchQuery.value = '';
};

watch(
  () => props.modelValue,
  async (isOpen) => {
    if (isOpen && props.showSearch) {
      await nextTick();
      searchInputRef.value?.focus();
    }
    if (!isOpen) {
      searchQuery.value = '';
    }
  },
);

defineExpose({ close, searchQuery });
</script>

<style scoped>
/* Overlay */
.app-bottom-sheet-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 9999;
  background-color: rgba(0, 0, 0, 0.5);
}

/* Container principal */
.app-bottom-sheet-container {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 10000;
  border-top-left-radius: 1rem;
  border-top-right-radius: 1rem;
  max-height: 80vh;
  max-height: 80dvh;
  display: flex;
  flex-direction: column;
  width: 100%;
  max-width: 100%;
  box-sizing: border-box;
  overflow: hidden;
}

.app-bottom-sheet-container.light {
  background-color: white;
}

.app-bottom-sheet-container.dark {
  background-color: #1f2937;
}

/* Handle */
.app-bottom-sheet-handle {
  display: flex;
  justify-content: center;
  padding: 0.75rem 0;
}

.handle-bar {
  width: 2.5rem;
  height: 0.25rem;
  border-radius: 9999px;
}

.handle-bar.light {
  background-color: #d1d5db;
}

.handle-bar.dark {
  background-color: #4b5563;
}

/* Header */
.app-bottom-sheet-header {
  padding: 0 1rem 0.75rem 1rem;
  border-bottom-width: 1px;
  border-bottom-style: solid;
}

.app-bottom-sheet-header.light {
  border-bottom-color: #e5e7eb;
}

.app-bottom-sheet-header.dark {
  border-bottom-color: #374151;
}

.app-bottom-sheet-title {
  font-size: 1.125rem;
  font-weight: 600;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin: 0;
}

.app-bottom-sheet-title.light {
  color: #111827;
}

.app-bottom-sheet-title.dark {
  color: white;
}

/* Search container */
.app-bottom-sheet-search-container {
  padding: 0.75rem 1rem;
  border-bottom-width: 1px;
  border-bottom-style: solid;
}

.app-bottom-sheet-search-container.light {
  border-bottom-color: #e5e7eb;
}

.app-bottom-sheet-search-container.dark {
  border-bottom-color: #374151;
}

.app-bottom-sheet-search-input {
  width: 100%;
}

/* Content */
.app-bottom-sheet-content {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  overscroll-behavior: contain;
  padding-bottom: max(1rem, env(safe-area-inset-bottom));
  width: 100%;
  box-sizing: border-box;
}

/* Animations */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.slide-up-enter-active,
.slide-up-leave-active {
  transition: transform 0.3s ease;
}

.slide-up-enter-from,
.slide-up-leave-to {
  transform: translateY(100%);
}

/* Q-List and Q-Item styles */
.app-bottom-sheet-content :deep(.q-list) {
  background: transparent;
  width: 100%;
  max-width: 100%;
  box-sizing: border-box;
  padding: 0;
}

.app-bottom-sheet-content :deep(.q-item) {
  width: 100%;
  max-width: 100%;
  min-width: 0;
  box-sizing: border-box;
  padding-left: 1rem;
  padding-right: 1rem;
}

.app-bottom-sheet-content :deep(.q-item__section--main) {
  min-width: 0;
  overflow: hidden;
  flex: 1 1 0%;
}

.app-bottom-sheet-content :deep(.q-item__section--side) {
  flex-shrink: 0;
}

.app-bottom-sheet-content :deep(.q-item-label) {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Dark mode q-item styles */
.app-bottom-sheet-content.dark :deep(.q-item) {
  color: white;
}

.app-bottom-sheet-content.dark :deep(.q-item:hover) {
  background: rgba(255, 255, 255, 0.1);
}

.app-bottom-sheet-content.dark :deep(.q-item__label--caption) {
  color: rgba(156, 163, 175, 0.8);
}
</style>
