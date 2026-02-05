import type { ToastType } from 'src/stores/toast.store';

export interface AppToastProps {
  // Toast não recebe props diretamente, ele usa o store
  // mas podemos definir configurações se necessário no futuro
}

export { type ToastType };
