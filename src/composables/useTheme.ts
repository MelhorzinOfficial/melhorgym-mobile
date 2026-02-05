import { ref, watch } from 'vue';
import { useQuasar } from 'quasar';

type Theme = 'light' | 'dark';

const STORAGE_KEY = 'melhorgym-theme';

// Inicializar tema imediatamente
const getInitialTheme = (): Theme => {
  if (typeof window === 'undefined') return 'light';

  const stored = localStorage.getItem(STORAGE_KEY) as Theme | null;
  if (stored && (stored === 'light' || stored === 'dark')) {
    return stored;
  }

  // Verificar preferência do sistema
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  return prefersDark ? 'dark' : 'light';
};

const theme = ref<Theme>(getInitialTheme());

// Aplicar tema no HTML e Quasar
const applyTheme = (quasar?: ReturnType<typeof useQuasar>) => {
  if (typeof window === 'undefined') return;

  const root = document.documentElement;
  const body = document.body;

  if (theme.value === 'dark') {
    root.classList.add('dark');
    body.classList.add('body--dark');
    body.classList.remove('body--light');
    if (quasar) {
      quasar.dark.set(true);
    }
  } else {
    root.classList.remove('dark');
    body.classList.add('body--light');
    body.classList.remove('body--dark');
    if (quasar) {
      quasar.dark.set(false);
    }
  }
};

// Aplicar tema inicial (sem Quasar ainda)
applyTheme();

/**
 * Composable para gerenciar tema dark/light
 */
export const useTheme = () => {
  let quasar: ReturnType<typeof useQuasar> | undefined;

  try {
    quasar = useQuasar();
    // Sincronizar estado inicial com Quasar
    applyTheme(quasar);
  } catch {
    // Quasar não disponível ainda (SSR ou fora de componente)
  }

  const setTheme = (newTheme: Theme) => {
    theme.value = newTheme;
    localStorage.setItem(STORAGE_KEY, newTheme);
    applyTheme(quasar);
  };

  const toggleTheme = () => {
    setTheme(theme.value === 'light' ? 'dark' : 'light');
  };

  // Watch para mudanças no tema
  watch(theme, () => {
    applyTheme(quasar);
  });

  return {
    theme,
    setTheme,
    toggleTheme,
    isDark: () => theme.value === 'dark',
    isLight: () => theme.value === 'light',
  };
};
