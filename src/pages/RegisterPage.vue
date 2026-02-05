<template>
  <div :class="[$q.dark.isActive ? 'bg-gray-900' : 'bg-white']" class="min-h-screen flex flex-col">
    <div class="flex-1 flex flex-col justify-center px-6 py-12 max-w-md mx-auto w-full">
      <!-- Header -->
      <div class="text-center mb-10">
        <div
          :class="[$q.dark.isActive ? 'bg-primary/20' : 'bg-orange-100']"
          class="h-24 w-24 mx-auto mb-6 rounded-full flex items-center justify-center"
        >
          <q-icon name="person_add" size="48px" color="primary" />
        </div>
        <h1
          :class="[$q.dark.isActive ? 'text-white' : 'text-gray-900']"
          class="text-4xl font-bold mb-3"
        >
          Criar Conta
        </h1>
        <p :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-600']" class="text-lg">
          Cadastre-se para começar a treinar
        </p>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-8">
        <q-spinner-dots size="48px" color="primary" />
        <p :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-600']" class="mt-4">
          Criando conta...
        </p>
      </div>

      <!-- Register Form -->
      <div v-else class="space-y-6">
        <form @submit.prevent="handleRegister" class="space-y-5">
          <!-- Name Field -->
          <AppInput
            v-model="name"
            type="text"
            label="Nome"
            placeholder="Seu nome completo"
            required
            :disabled="loading"
            :error="errors.name"
          />

          <!-- Email Field -->
          <AppInput
            v-model="email"
            type="email"
            label="Email"
            placeholder="seu@email.com"
            required
            :disabled="loading"
            :error="errors.email"
          />

          <!-- Password Field -->
          <AppInput
            v-model="password"
            type="password"
            label="Senha"
            placeholder="••••••••"
            required
            :disabled="loading"
            :error="errors.password"
          />

          <!-- Confirm Password Field -->
          <AppInput
            v-model="confirmPassword"
            type="password"
            label="Confirmar Senha"
            placeholder="••••••••"
            required
            :disabled="loading"
            :error="errors.confirmPassword"
          />

          <!-- Register Button -->
          <AppButton
            type="submit"
            :disabled="loading || !isFormValid"
            :loading="loading"
            full-width
          >
            Criar Conta
          </AppButton>
        </form>

        <!-- Divider -->
        <!-- <div class="relative">
          <div class="absolute inset-0 flex items-center">
            <div
              :class="[$q.dark.isActive ? 'border-gray-700' : 'border-gray-300']"
              class="w-full border-t"
            ></div>
          </div>
          <div class="relative flex justify-center text-sm">
            <span
              :class="[$q.dark.isActive ? 'bg-gray-900 text-gray-400' : 'bg-white text-gray-500']"
              class="px-4"
            >
              Ou continue com
            </span>
          </div>
        </div> -->

        <!-- Google Register Button -->
        <!-- <AppButton variant="outline" :disabled="loading" full-width @click="handleGoogleLogin">
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

        <!-- Login Link -->
        <div
          :class="[$q.dark.isActive ? 'text-gray-400' : 'text-gray-600']"
          class="text-center text-sm"
        >
          Já tem uma conta?
          <router-link to="/login" class="text-primary hover:text-orange-600 font-semibold">
            Entrar
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { useQuasar } from 'quasar';
import { useRouter } from 'vue-router';
import { useToast } from 'src/composables/useToast';
import AppInput from 'src/components/ui/AppInput';
import AppButton from 'src/components/ui/AppButton';
import { api } from 'src/boot/axios';

const $q = useQuasar();
const router = useRouter();
const toast = useToast();

// Form fields
const name = ref('');
const email = ref('');
const password = ref('');
const confirmPassword = ref('');
const loading = ref(false);

// Errors
const errors = ref({
  name: '',
  email: '',
  password: '',
  confirmPassword: '',
});

// Validation
const isFormValid = computed(() => {
  return (
    name.value.trim() !== '' &&
    email.value.trim() !== '' &&
    password.value !== '' &&
    confirmPassword.value !== '' &&
    password.value === confirmPassword.value &&
    password.value.length >= 6
  );
});

function validateForm(): boolean {
  let isValid = true;
  errors.value = { name: '', email: '', password: '', confirmPassword: '' };

  if (!name.value.trim()) {
    errors.value.name = 'Nome é obrigatório';
    isValid = false;
  }

  if (!email.value.trim()) {
    errors.value.email = 'Email é obrigatório';
    isValid = false;
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
    errors.value.email = 'Email inválido';
    isValid = false;
  }

  if (!password.value) {
    errors.value.password = 'Senha é obrigatória';
    isValid = false;
  } else if (password.value.length < 6) {
    errors.value.password = 'Senha deve ter pelo menos 6 caracteres';
    isValid = false;
  }

  if (!confirmPassword.value) {
    errors.value.confirmPassword = 'Confirme sua senha';
    isValid = false;
  } else if (password.value !== confirmPassword.value) {
    errors.value.confirmPassword = 'As senhas não coincidem';
    isValid = false;
  }

  return isValid;
}

/**
 * Converte erros técnicos em mensagens amigáveis
 */
function getErrorMessage(error: any): string {
  if (error.response?.data?.message) {
    return error.response.data.message;
  }

  if (error.response?.status) {
    switch (error.response.status) {
      case 400:
        return 'Dados inválidos. Verifique as informações e tente novamente.';
      case 409:
        return 'Este email já está cadastrado.';
      case 422:
        return 'Dados inválidos. Verifique os campos e tente novamente.';
      case 429:
        return 'Muitas tentativas. Aguarde alguns minutos e tente novamente.';
      case 500:
        return 'Erro no servidor. Tente novamente em alguns instantes.';
    }
  }

  if (error.message === 'Network Error' || error.code === 'ERR_NETWORK') {
    return 'Erro de conexão. Verifique sua internet e tente novamente.';
  }

  return 'Erro inesperado. Tente novamente ou entre em contato com o suporte.';
}

async function handleRegister() {
  if (!validateForm()) {
    return;
  }

  try {
    loading.value = true;

    await api.post('/register', {
      name: name.value.trim(),
      email: email.value.trim(),
      password: password.value,
    });

    toast.success('Conta criada com sucesso! Faça login para continuar.');

    // Redireciona para login
    await router.push('/login');
  } catch (error) {
    console.error('Erro ao criar conta:', error);
    toast.error(getErrorMessage(error));
  } finally {
    loading.value = false;
  }
}

// function handleGoogleLogin() {
//   loginWithGoogle();
// }
</script>
