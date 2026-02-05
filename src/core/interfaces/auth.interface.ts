/**
 * Interface para resposta de login do Google
 */
export interface GoogleLoginResponse {
  /**
   * Token JWT de acesso
   */
  accessToken: string;
}

/**
 * Interface para credenciais de login
 */
export interface LoginCredentials {
  email: string;
  password: string;
}

/**
 * Interface para resposta de login
 */
export interface LoginResponse {
  token: string;
  user: AuthUser;
}

/**
 * Interface para dados do usuário autenticado
 */
export interface AuthUser {
  id: number;
  email: string;
  role: string;
  name?: string;
  avatar?: string;
  createdAt?: string;
}

/**
 * Interface para estado de autenticação
 */
export interface AuthState {
  /**
   * Usuário autenticado
   */
  user: AuthUser | null;

  /**
   * Token JWT
   */
  token: string | null;

  /**
   * Status de carregamento
   */
  loading: boolean;

  /**
   * Se está autenticando via Google
   */
  authenticating: boolean;
}

/**
 * Chaves para localStorage
 */
export enum AuthStorageKeys {
  TOKEN = 'auth_token',
  USER = 'auth_user',
}

/**
 * Interface para configuração de autenticação
 */
export interface AuthConfig {
  /**
   * URL base da API
   */
  apiBaseUrl?: string;

  /**
   * Se deve redirecionar após logout
   */
  redirectAfterLogout?: boolean;

  /**
   * Rota para redirecionar após logout
   */
  logoutRedirectPath?: string;

  /**
   * Rota para redirecionar após login
   */
  loginRedirectPath?: string;
}
