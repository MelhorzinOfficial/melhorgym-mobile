<template>
  <q-layout view="hHh lpR fFf">
    <HeaderWithAuth title="Meu Treino" />

    <q-page-container>
      <router-view v-slot="{ Component, route }">
        <transition
          :name="transitionName"
          :enter-active-class="'animated ' + transitionEnter"
          :leave-active-class="'animated ' + transitionLeave"
        >
          <component :is="Component" :key="route.path" />
        </transition>
      </router-view>
    </q-page-container>

    <Footer />
  </q-layout>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { HeaderWithAuth, Footer } from 'components/layout';

const router = useRouter();
const transitionName = ref('bounceIn');
const transitionEnter = ref('slideInRight');
const transitionLeave = ref('slideOutLeft');

let previousPath = '';

// Detecta direção da navegação para aplicar transição correta
router.afterEach((to, from) => {
  const toDepth = to.path.split('/').length;
  const fromDepth = from.path.split('/').length;

  // Navegação para frente (aprofundando)
  if (toDepth > fromDepth || to.path !== previousPath) {
    transitionEnter.value = 'slideInRight';
    transitionLeave.value = 'slideOutLeft';
  } else {
    // Navegação para trás
    transitionEnter.value = 'slideInLeft';
    transitionLeave.value = 'slideOutRight';
  }

  previousPath = to.path;
});
</script>
