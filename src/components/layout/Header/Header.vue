<script setup lang="ts">
import { computed } from 'vue';
import { useTheme } from 'src/composables/useTheme';
import type { HeaderProps } from './interfaces/header.interface';

const props = withDefaults(defineProps<HeaderProps>(), {
  title: 'Meu Treino',
  showLogo: true,
  fixed: true,
});

const { theme, toggleTheme } = useTheme();

const headerClasses = computed(() => {
  const classes = ['w-full bg-white dark:bg-gray-800 shadow-md transition-colors', props.class];
  if (props.fixed) {
    classes.push('fixed top-0 left-0 z-50');
  }
  return classes.filter(Boolean).join(' ');
});
</script>

<template>
  <header :class="headerClasses">
    <div class="container mx-auto px-4 py-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <img
          v-if="showLogo"
          :src="logoUrl || '/icons/favicon-128x128.png'"
          alt="Logo"
          class="h-8 w-8"
        />
        <h1 class="text-xl font-bold text-gray-800 dark:text-white">{{ title }}</h1>
      </div>

      <div class="flex items-center gap-4">
        <!-- Theme Toggle Button -->
        <button
          type="button"
          @click="toggleTheme"
          class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          :title="theme === 'light' ? 'Ativar modo escuro' : 'Ativar modo claro'"
        >
          <!-- Sun Icon (Light Mode) -->
          <svg
            v-if="theme === 'dark'"
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 text-yellow-500"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
            />
          </svg>
          <!-- Moon Icon (Dark Mode) -->
          <svg
            v-else
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 text-gray-700"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
            />
          </svg>
        </button>

        <slot name="actions" />
      </div>
    </div>
  </header>
</template>
