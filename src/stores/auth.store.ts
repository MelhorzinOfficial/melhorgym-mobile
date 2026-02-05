import { defineStore } from 'pinia';
import { api } from 'src/boot/axios';
import { useWorkoutProgressStore } from './workout-progress.store';
import type {
  AuthState,
  AuthUser,
  LoginCredentials,
  LoginResponse,
} from 'src/core/interfaces/auth.interface';

/**
 * Store de autenticação
 *
 * Gerencia o estado de autenticação do usuário, incluindo login via Google,
 * armazenamento de token JWT e sincronização com localStorage.
 *
 * @example
 * ```typescript
 * import { useAuthStore } from 'src/stores/auth.store';
 *
 * const authStore = useAuthStore();
 *
 * // Fazer login
 * await authStore.loginWithGoogle();
 *
 * // Verificar autenticação
 * if (authStore.isAuthenticated) {
 *   console.log(authStore.user);
 * }
 *
 * // Fazer logout
 * await authStore.logout();
 * ```
 */
export const useAuthStore = defineStore('auth', {
  state: (): AuthState => ({
    user: null,
    token: null,
    loading: false,
    authenticating: false,
  }),

  getters: {
    /**
     * Verifica se o usuário está autenticado
     */
    isAuthenticated: (state): boolean => {
      return !!state.token && !!state.user;
    },

    /**
     * Retorna o nome do usuário ou 'Usuário' como fallback
     */
    userName: (state): string => {
      return state.user?.name || 'Usuário';
    },

    /**
     * Retorna o email do usuário
     */
    userEmail: (state): string | null => {
      return state.user?.email || null;
    },

    /**
     * Retorna o avatar do usuário
     */
    userAvatar: (state): string | null => {
      return state.user?.avatar || null;
    },
  },

  actions: {
    /**
     * Faz login com email e senha
     *
     * @param credentials - Email e senha do usuário
     */
    async login(credentials: LoginCredentials): Promise<void> {
      try {
        this.loading = true;

        // Faz requisição de login
        const response = await api.post<LoginResponse>('/login', credentials);

        const { token, user } = response.data;

        // Salva o token
        this.setToken(token);

        // Salva o usuário
        this.setUser(user);
      } catch (error) {
        console.error('Erro ao fazer login:', error);
        throw error;
      } finally {
        this.loading = false;
      }
    },

    /**
     * Redireciona para o fluxo de autenticação do Google
     */
    loginWithGoogle(): void {
      this.authenticating = true;

      // Redireciona para a rota de login do Google
      const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:3000';
      window.location.href = `${apiUrl}/login/google`;
    },

    /**
     * Processa o token recebido do callback do Google
     *
     * @param token - Token JWT recebido
     */
    async handleGoogleCallback(token: string): Promise<void> {
      try {
        this.loading = true;

        // Salva o token
        this.setToken(token);

        // Busca os dados do usuário
        await this.fetchUser();

        this.authenticating = false;
      } catch (error) {
        console.error('Erro ao processar callback do Google:', error);
        this.logout();
        throw error;
      } finally {
        this.loading = false;
      }
    },

    /**
     * Busca os dados do usuário autenticado
     */
    async fetchUser(): Promise<void> {
      if (!this.token) {
        throw new Error('Token não encontrado');
      }

      try {
        this.loading = true;

        // TODO: Implementar quando a rota /me estiver disponível
        // Faz requisição para buscar dados do usuário
        // const response = await api.get<AuthUser>('/me');
        // this.setUser(response.data);

        console.warn('Rota /me ainda não implementada no backend');
      } catch (error) {
        console.error('Erro ao buscar usuário:', error);
        throw error;
      } finally {
        this.loading = false;
      }
    },

    /**
     * Define o token JWT e persiste no localStorage
     *
     * @param token - Token JWT
     */
    setToken(token: string): void {
      this.token = token;
      localStorage.setItem('auth_token', token);
    },

    /**
     * Define o usuário e persiste no localStorage
     *
     * @param user - Dados do usuário
     */
    setUser(user: AuthUser): void {
      this.user = user;
      localStorage.setItem('auth_user', JSON.stringify(user));
    },

    /**
     * Faz logout do usuário, limpando token e dados
     */
    logout(): void {
      // Limpa o estado
      this.user = null;
      this.token = null;
      this.authenticating = false;

      // Limpa o localStorage
      localStorage.removeItem('auth_token');
      localStorage.removeItem('auth_user');

      // Limpa outros stores
      const workoutProgressStore = useWorkoutProgressStore();
      workoutProgressStore.resetState();

      // Redireciona para a página de login
      window.location.href = '/login';
    },

    /**
     * Verifica se há uma sessão válida no localStorage
     * e tenta restaurar o estado de autenticação
     */
    async checkAuth(): Promise<boolean> {
      try {
        this.loading = true;

        // Tenta recuperar token e usuário do localStorage
        const token = localStorage.getItem('auth_token');
        const userStr = localStorage.getItem('auth_user');

        if (!token) {
          return false;
        }

        // Restaura o token
        this.token = token;

        // Se tem usuário salvo, restaura
        if (userStr) {
          try {
            this.user = JSON.parse(userStr);
          } catch (e) {
            console.error('Erro ao parsear usuário do localStorage:', e);
          }
        }

        // Valida o token fazendo uma requisição
        try {
          await this.fetchUser();
          return true;
        } catch {
          // Token inválido, faz logout silencioso
          this.user = null;
          this.token = null;
          localStorage.removeItem('auth_token');
          localStorage.removeItem('auth_user');
          return false;
        }
      } catch (error) {
        console.error('Erro ao verificar autenticação:', error);
        return false;
      } finally {
        this.loading = false;
      }
    },

    /**
     * Atualiza os dados do usuário
     *
     * @param updates - Dados parciais para atualizar
     */
    updateUser(updates: Partial<AuthUser>): void {
      if (!this.user) return;

      this.user = { ...this.user, ...updates };
      localStorage.setItem('auth_user', JSON.stringify(this.user));
    },

    /**
     * Reseta o estado de autenticação
     */
    resetState(): void {
      this.user = null;
      this.token = null;
      this.loading = false;
      this.authenticating = false;
    },
  },
});
