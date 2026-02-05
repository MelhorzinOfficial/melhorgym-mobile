import { defineStore } from 'pinia';

export type ToastType = 'success' | 'error' | 'warning' | 'info';

export interface Toast {
  id: string;
  type: ToastType;
  message: string;
  duration?: number;
}

interface ToastState {
  toasts: Toast[];
}

export const useToastStore = defineStore('toast', {
  state: (): ToastState => ({
    toasts: [],
  }),

  actions: {
    addToast(toast: Omit<Toast, 'id'>) {
      const id = `toast-${Date.now()}-${Math.random()}`;
      const duration = toast.duration || 5000;

      const newToast: Toast = {
        ...toast,
        id,
        duration,
      };

      this.toasts.push(newToast);

      // Remove o toast automaticamente após a duração
      if (duration > 0) {
        setTimeout(() => {
          this.removeToast(id);
        }, duration);
      }

      return id;
    },

    removeToast(id: string) {
      const index = this.toasts.findIndex((t) => t.id === id);
      if (index > -1) {
        this.toasts.splice(index, 1);
      }
    },

    success(message: string, duration?: number) {
      return this.addToast({
        type: 'success',
        message,
        ...(duration !== undefined && { duration }),
      });
    },

    error(message: string, duration?: number) {
      return this.addToast({ type: 'error', message, ...(duration !== undefined && { duration }) });
    },

    warning(message: string, duration?: number) {
      return this.addToast({
        type: 'warning',
        message,
        ...(duration !== undefined && { duration }),
      });
    },

    info(message: string, duration?: number) {
      return this.addToast({ type: 'info', message, ...(duration !== undefined && { duration }) });
    },

    clearAll() {
      this.toasts = [];
    },
  },
});
