import { computed } from 'vue';
import { useAuthStore } from 'src/stores/auth.store';
import type { AuthUser, LoginCredentials } from 'src/core/interfaces/auth.interface';

/**
 * Composable para facilitar o uso da autenticação em componentes
 *
 * @example
 * ```vue
 * <script setup lang="ts">
 * import { useAuth } from 'src/composables/useAuth';
 *
 * const {
 *   user,
 *   isAuthenticated,
 *   loading,
 *   loginWithGoogle,
 *   logout
 * } = useAuth();
 *
 * async function handleLogin() {
 *   await loginWithGoogle();
 * }
 * </script>
 *
 * <template>
 *   <div v-if="loading">Carregando...</div>
 *   <div v-else-if="isAuthenticated">
 *     Bem-vindo, {{ user?.name }}!
 *     <button @click="logout">Sair</button>
 *   </div>
 *   <div v-else>
 *     <button @click="handleLogin">Entrar com Google</button>
 *   </div>
 * </template>
 * ```
 */
export function useAuth() {
  const authStore = useAuthStore();

  return {
    // Estado
    user: computed(() => authStore.user),
    token: computed(() => authStore.token),
    loading: computed(() => authStore.loading),
    authenticating: computed(() => authStore.authenticating),

    // Getters
    isAuthenticated: computed(() => authStore.isAuthenticated),
    userName: computed(() => authStore.userName),
    userEmail: computed(() => authStore.userEmail),
    userAvatar: computed(() => authStore.userAvatar),

    // Actions
    login: (credentials: LoginCredentials) => authStore.login(credentials),
    loginWithGoogle: () => authStore.loginWithGoogle(),
    handleGoogleCallback: (token: string) => authStore.handleGoogleCallback(token),
    fetchUser: () => authStore.fetchUser(),
    logout: () => authStore.logout(),
    checkAuth: () => authStore.checkAuth(),
    updateUser: (updates: Partial<AuthUser>) => authStore.updateUser(updates),

    // Store direto (para casos avançados)
    authStore,
  };
}
