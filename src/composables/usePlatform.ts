import { ref, computed, readonly } from 'vue';
import { Capacitor } from '@capacitor/core';

export type Platform = 'ios' | 'android' | 'web';

const platform = ref<Platform>('web');
const isNative = ref(false);

/**
 * Composable para detectar a plataforma (iOS, Android ou Web)
 * e fornecer informações sobre safe areas
 */
export function usePlatform() {
  const isIOS = computed(() => platform.value === 'ios');
  const isAndroid = computed(() => platform.value === 'android');
  const isWeb = computed(() => platform.value === 'web');

  return {
    platform: readonly(platform),
    isNative: readonly(isNative),
    isIOS,
    isAndroid,
    isWeb,
  };
}

/**
 * Inicializa a detecção de plataforma
 * Deve ser chamado no boot
 */
export async function initPlatform(): Promise<void> {
  try {
    // Usa a API do Capacitor para detectar a plataforma
    const capacitorPlatform = Capacitor.getPlatform();

    if (capacitorPlatform === 'ios') {
      platform.value = 'ios';
      isNative.value = true;
    } else if (capacitorPlatform === 'android') {
      platform.value = 'android';
      isNative.value = true;
    } else {
      platform.value = 'web';
      isNative.value = false;
    }

    // Adiciona classes ao body para estilização condicional
    document.body.classList.add(`platform-${platform.value}`);

    if (isNative.value) {
      document.body.classList.add('platform-native');
    }

    console.log(`[Platform] Detected: ${platform.value}, Native: ${isNative.value}`);
  } catch (error) {
    console.warn('[Platform] Error detecting platform:', error);
    platform.value = 'web';
    isNative.value = false;
  }
}
