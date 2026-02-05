<template>
  <div class="min-h-screen bg-gray-50 flex items-center justify-center px-4 py-12">
    <div class="max-w-2xl w-full text-center">
      <!-- Illustration/Icon -->
      <div class="mb-8">
        <div
          class="inline-flex items-center justify-center w-32 h-32 rounded-full bg-primary-100 mb-6"
        >
          <svg
            class="w-20 h-20 text-primary-600"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
            />
          </svg>
        </div>

        <!-- 404 Number -->
        <h1 class="text-9xl font-bold text-primary-600 mb-4">404</h1>
      </div>

      <!-- Message -->
      <div class="mb-10">
        <h2 class="text-3xl font-bold text-secondary-900 mb-4">Página não encontrada</h2>
        <p class="text-lg text-secondary-600 max-w-md mx-auto">
          Ops! A página que você está procurando não existe ou foi movida. Que tal voltar para a
          página inicial?
        </p>
      </div>

      <!-- Actions -->
      <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
        <AppButton variant="primary" size="lg" @click="$router.push('/')">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
            />
          </svg>
          Voltar para o início
        </AppButton>

        <AppButton variant="ghost" size="lg" @click="$router.back()">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M10 19l-7-7m0 0l7-7m-7 7h18"
            />
          </svg>
          Voltar
        </AppButton>
      </div>

      <!-- Additional Help -->
      <div class="mt-12 pt-8 border-t border-secondary-200">
        <p class="text-sm text-secondary-500 mb-4">
          Se você acredita que isso é um erro, entre em contato conosco.
        </p>
        <div class="flex gap-6 justify-center text-sm">
          <a href="#" class="text-primary-600 hover:text-primary-700 font-medium"> Suporte </a>
          <span class="text-secondary-300">|</span>
          <a href="#" class="text-primary-600 hover:text-primary-700 font-medium">
            Reportar problema
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import AppButton from 'src/components/ui/AppButton';
</script>
