<template>
  <div
    class="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-500 to-purple-600"
  >
    <div class="bg-white rounded-2xl shadow-2xl p-8 max-w-md w-full mx-4">
      <div class="text-center">
        <div v-if="loading" class="py-8">
          <div
            class="inline-block animate-spin rounded-full h-16 w-16 border-b-2 border-blue-600"
          ></div>
          <h2 class="mt-4 text-xl font-semibold text-gray-900">Autenticando...</h2>
          <p class="mt-2 text-gray-600">Aguarde enquanto validamos seu acesso</p>
        </div>

        <div v-else-if="error" class="py-8">
          <div class="text-red-500 mb-4">
            <svg class="w-16 h-16 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
          </div>
          <h2 class="text-xl font-semibold text-gray-900 mb-2">Erro na autenticação</h2>
          <p class="text-gray-600 mb-6">
            {{ errorMessage }}
          </p>
          <button
            @click="goToLogin"
            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
          >
            Voltar ao login
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { useAuth } from 'src/composables/useAuth';
import { useRouter, useRoute } from 'vue-router';

const router = useRouter();
const route = useRoute();
const { handleGoogleCallback } = useAuth();

const loading = ref(true);
const error = ref(false);
const errorMessage = ref('Ocorreu um erro ao processar sua autenticação. Tente novamente.');

onMounted(async () => {
  try {
    // Obtém o token da query string
    const token = route.query.accessToken as string;

    if (!token) {
      throw new Error('Token não fornecido');
    }

    // Processa o callback
    await handleGoogleCallback(token);

    // Redireciona para home
    await router.push('/');
  } catch (err) {
    console.error('Erro no callback do Google:', err);
    error.value = true;

    if (err instanceof Error) {
      errorMessage.value = err.message;
    }
  } finally {
    loading.value = false;
  }
});

async function goToLogin() {
  await router.push('/login');
}
</script>
