<template>
  <div :class="[$q.dark.isActive ? 'bg-gray-900' : 'bg-white']" class="min-h-screen flex flex-col">
    <div class="flex-1 flex flex-col justify-center px-6 py-12 max-w-md mx-auto w-full">
      <!-- Header -->
      <div class="text-center mb-10">
        <div class="mx-auto mb-6">
          <img
            src="~assets/melhorzin-treino-logo.png"
            alt="Meu Treino"
            class="h-40 w-40 mx-auto rounded-2xl"
          />
        </div>
        <h1
          :class="[$q.dark.isActive ? 'text-white' : 'text-gray-900']"
          class="text-4xl font-bold mb-3"
        >
          Bem-vindo!
        </h1>
        <p :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-600']" class="text-lg">
          Entre para gerenciar seus treinos
        </p>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-8">
        <q-spinner-dots size="48px" color="primary" />
        <p :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-600']" class="mt-4">
          Carregando...
        </p>
      </div>

      <!-- Login Form -->
      <div v-else class="space-y-6">
        <!-- Email and Password Form -->
        <form @submit.prevent="handleEmailLogin" class="space-y-5">
          <!-- Email Field -->
          <AppInput
            v-model="email"
            type="email"
            label="Email"
            placeholder="seu@email.com"
            required
            :disabled="loading"
          />

          <!-- Password Field -->
          <AppInput
            v-model="password"
            type="password"
            label="Senha"
            placeholder="••••••••"
            required
            :disabled="loading"
          />

          <!-- Remember Me & Forgot Password -->
          <div class="flex items-center justify-between text-sm">
            <label class="flex items-center cursor-pointer">
              <input
                v-model="rememberMe"
                type="checkbox"
                class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-primary"
              />
              <span :class="[$q.dark.isActive ? 'text-gray-300' : 'text-gray-700']" class="ml-2"
                >Lembrar-me</span
              >
            </label>
            <!-- <a href="#" class="text-primary hover:text-orange-600 font-medium">
              Esqueceu a senha?
            </a> -->
          </div>

          <!-- Login Button -->
          <AppButton
            type="submit"
            :disabled="loading || !email || !password"
            :loading="loading"
            full-width
          >
            Entrar
          </AppButton>
        </form>

        <!-- Divider -->
        <div class="relative">
          <div class="absolute inset-0 flex items-center">
            <div
              :class="[$q.dark.isActive ? 'border-gray-700' : 'border-gray-300']"
              class="w-full border-t"
            ></div>
          </div>
          <!-- <div class="relative flex justify-center text-sm">
            <span
              :class="[$q.dark.isActive ? 'bg-gray-900 text-gray-400' : 'bg-white text-gray-500']"
              class="px-4"
            >
              Ou continue com
            </span>
          </div> -->
        </div>

        <!-- Google Login Button -->
        <!-- <AppButton
          variant="outline"
          :disabled="authenticating || loading"
          :loading="authenticating"
          full-width
          @click="handleGoogleLogin"
        >
          <svg class="w-5 h-5 -ml-1" viewBox="0 0 24 24">
            <path
              fill="#4285F4"
              d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
            />
            <path
              fill="#34A853"
              d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
            />
            <path
              fill="#FBBC05"
              d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
            />
            <path
              fill="#EA4335"
              d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
            />
          </svg>
          Google
        </AppButton> -->

        <!-- Sign Up Link -->
        <div
          :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-600']"
          class="text-center text-sm"
        >
          Não tem uma conta?
          <router-link to="/register" class="text-primary hover:text-orange-600 font-semibold">
            Criar conta
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useQuasar } from 'quasar';
import { useAuth } from 'src/composables/useAuth';
import { useToast } from 'src/composables/useToast';
import { useRouter } from 'vue-router';
import AppInput from 'src/components/ui/AppInput';
import AppButton from 'src/components/ui/AppButton';

const $q = useQuasar();
const router = useRouter();
const {
  isAuthenticated,
  loading,
  authenticating: _authenticating,
  login,
  loginWithGoogle: _loginWithGoogle,
} = useAuth();
const toast = useToast();

// Form fields
const email = ref('');
const password = ref('');
const rememberMe = ref(false);

/**
 * Converte erros técnicos em mensagens amigáveis
 */
function getErrorMessage(error: any): string {
  // Mensagens específicas do backend
  if (error.response?.data?.message) {
    return error.response.data.message;
  }

  // Erros HTTP conhecidos
  if (error.response?.status) {
    switch (error.response.status) {
      case 400:
        return 'Dados inválidos. Verifique as informações e tente novamente.';
      case 401:
        return 'Email ou senha incorretos.';
      case 403:
        return 'Acesso negado. Você não tem permissão para acessar.';
      case 404:
        return 'Serviço não encontrado. Entre em contato com o suporte.';
      case 422:
        return 'Dados inválidos. Verifique os campos e tente novamente.';
      case 429:
        return 'Muitas tentativas. Aguarde alguns minutos e tente novamente.';
      case 500:
        return 'Erro no servidor. Tente novamente em alguns instantes.';
      case 503:
        return 'Serviço temporariamente indisponível. Tente novamente mais tarde.';
    }
  }

  // Erros de rede
  if (error.message === 'Network Error' || error.code === 'ERR_NETWORK') {
    return 'Erro de conexão. Verifique sua internet e tente novamente.';
  }

  // Timeout
  if (error.code === 'ECONNABORTED' || error.message?.includes('timeout')) {
    return 'A requisição demorou muito. Tente novamente.';
  }

  // Mensagem genérica de fallback
  return 'Erro inesperado. Tente novamente ou entre em contato com o suporte.';
}

// Se já estiver autenticado, redireciona para home
onMounted(async () => {
  if (isAuthenticated.value) {
    await router.push('/');
  }
});

async function handleEmailLogin() {
  try {
    await login({
      email: email.value,
      password: password.value,
    });

    toast.success('Login realizado com sucesso!');

    // Redireciona para home após login bem-sucedido
    await router.push('/');
  } catch (error) {
    console.error('Erro ao fazer login:', error);
    toast.error(getErrorMessage(error));
  }
}

// TODO: Enable Google login when backend is ready
// function handleGoogleLogin() {
//   _loginWithGoogle();
// }
</script>
