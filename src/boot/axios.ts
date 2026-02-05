import { defineBoot } from '#q-app/wrappers';
import axios, { type AxiosInstance, type InternalAxiosRequestConfig } from 'axios';
import { AuthStorageKeys } from 'src/core/interfaces/auth.interface';

declare module 'vue' {
  interface ComponentCustomProperties {
    $axios: AxiosInstance;
    $api: AxiosInstance;
  }
}

// Be careful when using SSR for cross-request state pollution
// due to creating a Singleton instance here;
// If any client changes this (global) instance, it might be a
// good idea to move this instance creation inside of the
// "export default () => {}" function below (which runs individually
// for each client)
const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000',
  timeout: 30000,
});

/**
 * Interceptor de requisição para adicionar token JWT
 */
api.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    // Obtém o token do localStorage
    const token = localStorage.getItem(AuthStorageKeys.TOKEN);

    // Se existir token, adiciona ao header Authorization
    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    return config;
  },
  (error) => {
    return Promise.reject(error instanceof Error ? error : new Error(String(error)));
  },
);

/**
 * Interceptor de resposta para tratar erros de autenticação
 */
api.interceptors.response.use(
  (response) => response,
  (error) => {
    // Se receber 401, limpa o localStorage e redireciona para login
    if (error.response?.status === 401) {
      localStorage.removeItem(AuthStorageKeys.TOKEN);
      localStorage.removeItem(AuthStorageKeys.USER);

      // Redireciona para login se não estiver na rota de login
      if (window.location.pathname !== '/login') {
        window.location.href = '/login';
      }
    }

    return Promise.reject(error instanceof Error ? error : new Error(String(error)));
  },
);

export default defineBoot(({ app }) => {
  // for use inside Vue files (Options API) through this.$axios and this.$api

  app.config.globalProperties.$axios = axios;
  // ^ ^ ^ this will allow you to use this.$axios (for Vue Options API form)
  //       so you won't necessarily have to import axios in each vue file

  app.config.globalProperties.$api = api;
  // ^ ^ ^ this will allow you to use this.$api (for Vue Options API form)
  //       so you can easily perform requests against your app's API
});

export { api };
