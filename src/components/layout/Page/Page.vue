<script setup lang="ts">
import { computed } from 'vue';
import type { PageProps } from './interfaces/page.interface';

const props = withDefaults(defineProps<PageProps>(), {
  padding: 'md',
  paddingTop: true,
  paddingBottom: true,
  bgColor: 'bg-gray-50 dark:bg-gray-900',
  contained: false,
});

const paddingClasses = computed(() => {
  const classes: string[] = [];

  // Padding horizontal e vertical geral
  switch (props.padding) {
    case 'none':
      break;
    case 'sm':
      classes.push('p-2');
      break;
    case 'md':
      classes.push('p-4');
      break;
    case 'lg':
      classes.push('p-6');
      break;
    case 'xl':
      classes.push('p-8');
      break;
  }

  // Padding top para compensar header fixo
  if (props.paddingTop && props.padding !== 'none') {
    classes.push('pt-20'); // Ajuste conforme altura do header
  }

  // Padding bottom para compensar footer fixo
  if (props.paddingBottom && props.padding !== 'none') {
    classes.push('pb-20'); // Ajuste conforme altura do footer
  }

  return classes.join(' ');
});

const pageClasses = computed(() => {
  return ['min-h-screen', props.bgColor, paddingClasses.value, props.class]
    .filter(Boolean)
    .join(' ');
});

const containerClasses = computed(() => {
  return props.contained ? 'container mx-auto max-w-7xl' : 'w-full';
});
</script>

<template>
  <div :class="pageClasses">
    <div :class="containerClasses">
      <slot />
    </div>
  </div>
</template>
