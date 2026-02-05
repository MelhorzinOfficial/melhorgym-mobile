<script setup lang="ts">
import { useAuth } from 'src/composables/useAuth';
import { useTheme } from 'src/composables/useTheme';
import type { HeaderProps } from './interfaces/header.interface';

const _props = withDefaults(defineProps<HeaderProps>(), {
  title: 'MelhorGym',
  showLogo: true,
  fixed: true,
  elevated: false
});

const { user, userName, userAvatar, logout } = useAuth();
const { theme, toggleTheme } = useTheme();
</script>

<template>
  <q-header :elevated="_props.elevated" class="app-header shadow-sm">
    <q-toolbar>
      <div class="flex items-center gap-2">
        <img src="~assets/melhorzin-treino-logo.png" alt="MelhorGym" class="h-12 w-12 rounded-lg" />
        <q-toolbar-title class="text-lg font-semibold">{{ title }}</q-toolbar-title>
      </div>

      <q-space />

      <!-- Theme Toggle Button -->
      <q-btn
        flat
        round
        :icon="theme === 'dark' ? 'light_mode' : 'dark_mode'"
        :color="theme === 'dark' ? 'yellow' : undefined"
        @click="toggleTheme"
      >
        <q-tooltip>{{ theme === 'light' ? 'Ativar modo escuro' : 'Ativar modo claro' }}</q-tooltip>
      </q-btn>

      <slot name="actions" />

      <!-- User Menu -->
      <q-btn v-if="user" flat round no-caps class="ml-2">
        <q-avatar v-if="userAvatar" size="36px">
          <img :src="userAvatar" :alt="userName" />
        </q-avatar>
        <q-avatar v-else size="36px" color="primary" text-color="white">
          {{ userName.charAt(0).toUpperCase() }}
        </q-avatar>

        <q-menu>
          <q-list style="min-width: 180px">
            <q-item-label header class="text-weight-medium">
              {{ userName }}
              <div class="text-caption text-grey">{{ user.email }}</div>
            </q-item-label>
            <q-separator />
            <q-item clickable v-close-popup @click="logout">
              <q-item-section avatar>
                <q-icon name="logout" color="negative" />
              </q-item-section>
              <q-item-section class="text-negative">Sair</q-item-section>
            </q-item>
          </q-list>
        </q-menu>
      </q-btn>
    </q-toolbar>
  </q-header>
</template>

<style scoped>
.app-header {
  background: white;
  color: #1f2937;
}

.body--dark .app-header {
  background: #1f2937;
  color: white;
}

.app-header :deep(.q-toolbar-title) {
  color: inherit;
}
</style>
