import { useToastStore } from 'src/stores/toast.store';

/**
 * Composable para exibir toasts globalmente
 *
 * @example
 * const toast = useToast();
 *
 * // Sucesso
 * toast.success('Login realizado com sucesso!');
 *
 * // Erro
 * toast.error('Erro ao fazer login');
 *
 * // Warning
 * toast.warning('Atenção: sessão expirando em 5 minutos');
 *
 * // Info
 * toast.info('Nova atualização disponível');
 *
 * // Com duração customizada (em milissegundos)
 * toast.success('Salvo!', 3000);
 */
export function useToast() {
  const toastStore = useToastStore();

  return {
    /**
     * Exibe um toast de sucesso
     */
    success: (message: string, duration?: number) => {
      return toastStore.success(message, duration);
    },

    /**
     * Exibe um toast de erro
     */
    error: (message: string, duration?: number) => {
      return toastStore.error(message, duration);
    },

    /**
     * Exibe um toast de aviso/warning
     */
    warning: (message: string, duration?: number) => {
      return toastStore.warning(message, duration);
    },

    /**
     * Exibe um toast informativo
     */
    info: (message: string, duration?: number) => {
      return toastStore.info(message, duration);
    },

    /**
     * Remove todos os toasts
     */
    clearAll: () => {
      toastStore.clearAll();
    },
  };
}
