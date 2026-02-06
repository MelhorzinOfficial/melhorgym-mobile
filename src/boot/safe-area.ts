import { boot } from 'quasar/wrappers';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';

/**
 * Boot file para configurar safe areas específicas por plataforma
 * e inicializar a status bar no iOS/Android
 */
export default boot(async () => {
  const platform = Capacitor.getPlatform();
  const isNative = platform === 'ios' || platform === 'android';

  // Adiciona classes de plataforma ao body
  document.body.classList.add(`platform-${platform}`);

  if (isNative) {
    document.body.classList.add('platform-native');
  }

  // Configuração da StatusBar para apps nativos
  if (isNative) {
    try {
      // Configura a status bar para ser transparente e overlay
      if (platform === 'ios') {
        await StatusBar.setStyle({ style: Style.Light });
      } else {
        // Android
        await StatusBar.setStyle({ style: Style.Light });
        await StatusBar.setBackgroundColor({ color: '#ffffff' });
      }
    } catch (error) {
      console.warn('[SafeArea] Error configuring StatusBar:', error);
    }
  }

  console.log(`[SafeArea] Platform: ${platform}, Native: ${isNative}`);
});
