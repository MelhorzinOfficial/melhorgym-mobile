<template>
  <div
    class="toast-container fixed right-4 z-[9999] space-y-3 max-w-sm w-full px-4 pointer-events-none"
  >
    <TransitionGroup name="toast">
      <div
        v-for="toast in toasts"
        :key="toast.id"
        :class="[
          'pointer-events-auto flex items-start gap-4 p-4 rounded-xl shadow-xl',
          'border-l-4 transform transition-all duration-300 hover:scale-105',
          toastClasses[toast.type],
        ]"
      >
        <!-- Icon -->
        <div class="flex-shrink-0">
          <component :is="toastIcons[toast.type]" class="w-7 h-7" />
        </div>

        <!-- Message -->
        <div class="flex-1 text-sm font-medium leading-relaxed pt-0.5">
          {{ toast.message }}
        </div>

        <!-- Close Button -->
        <button
          @click="removeToast(toast.id)"
          class="flex-shrink-0 text-current opacity-50 hover:opacity-100 transition-all hover:rotate-90 duration-200"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>
    </TransitionGroup>
  </div>
</template>

<script setup lang="ts">
import { computed, h } from 'vue';
import { useToastStore, type ToastType } from 'src/stores/toast.store';

const toastStore = useToastStore();
const toasts = computed(() => toastStore.toasts);

const toastClasses: Record<ToastType, string> = {
  success: 'bg-white text-gray-800 border-green-500 shadow-green-100',
  error: 'bg-white text-gray-800 border-red-500 shadow-red-100',
  warning: 'bg-white text-gray-800 border-yellow-500 shadow-yellow-100',
  info: 'bg-white text-gray-800 border-blue-500 shadow-blue-100',
};

// SVG Icons as render functions
const toastIcons: Record<ToastType, any> = {
  success: () =>
    h(
      'svg',
      {
        class: 'w-6 h-6 text-green-600',
        fill: 'none',
        stroke: 'currentColor',
        viewBox: '0 0 24 24',
      },
      [
        h('path', {
          'stroke-linecap': 'round',
          'stroke-linejoin': 'round',
          'stroke-width': '2',
          d: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z',
        }),
      ],
    ),
  error: () =>
    h(
      'svg',
      {
        class: 'w-6 h-6 text-red-600',
        fill: 'none',
        stroke: 'currentColor',
        viewBox: '0 0 24 24',
      },
      [
        h('path', {
          'stroke-linecap': 'round',
          'stroke-linejoin': 'round',
          'stroke-width': '2',
          d: 'M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z',
        }),
      ],
    ),
  warning: () =>
    h(
      'svg',
      {
        class: 'w-6 h-6 text-yellow-600',
        fill: 'none',
        stroke: 'currentColor',
        viewBox: '0 0 24 24',
      },
      [
        h('path', {
          'stroke-linecap': 'round',
          'stroke-linejoin': 'round',
          'stroke-width': '2',
          d: 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z',
        }),
      ],
    ),
  info: () =>
    h(
      'svg',
      {
        class: 'w-6 h-6 text-blue-600',
        fill: 'none',
        stroke: 'currentColor',
        viewBox: '0 0 24 24',
      },
      [
        h('path', {
          'stroke-linecap': 'round',
          'stroke-linejoin': 'round',
          'stroke-width': '2',
          d: 'M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
        }),
      ],
    ),
};

function removeToast(id: string) {
  toastStore.removeToast(id);
}
</script>

<style scoped>
/* Posicionamento com safe area */
.toast-container {
  top: var(--toast-top-offset, 16px);
}

/* Animações de entrada e saída */
.toast-enter-active {
  transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.toast-leave-active {
  transition: all 0.3s ease-in;
}

.toast-enter-from {
  opacity: 0;
  transform: translateX(100%) scale(0.8);
}

.toast-leave-to {
  opacity: 0;
  transform: translateX(120%) scale(0.95);
}

.toast-move {
  transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}
</style>
