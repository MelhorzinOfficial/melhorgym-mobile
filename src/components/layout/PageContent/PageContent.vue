<script setup lang="ts">
import { computed } from 'vue';
import type { PageContentProps } from './interfaces/page-content.interface';

const props = withDefaults(defineProps<PageContentProps>(), {
  padding: 'md',
  bgColor: 'bg-white',
  shadow: true,
  rounded: 'md',
  divider: false,
});

const paddingClasses = computed(() => {
  switch (props.padding) {
    case 'none':
      return '';
    case 'sm':
      return 'p-3';
    case 'md':
      return 'p-4';
    case 'lg':
      return 'p-6';
    case 'xl':
      return 'p-8';
    default:
      return 'p-4';
  }
});

const roundedClasses = computed(() => {
  switch (props.rounded) {
    case 'none':
      return '';
    case 'sm':
      return 'rounded-sm';
    case 'md':
      return 'rounded-md';
    case 'lg':
      return 'rounded-lg';
    case 'xl':
      return 'rounded-xl';
    case 'full':
      return 'rounded-full';
    default:
      return 'rounded-md';
  }
});

const contentClasses = computed(() => {
  return [
    props.bgColor,
    paddingClasses.value,
    roundedClasses.value,
    props.shadow ? 'shadow-md' : '',
    props.class,
  ]
    .filter(Boolean)
    .join(' ');
});

const hasHeader = computed(() => props.title || props.subtitle);
</script>

<template>
  <div :class="contentClasses">
    <header v-if="hasHeader" class="mb-4">
      <h2 v-if="title" class="text-2xl font-bold text-gray-900 mb-1">
        {{ title }}
      </h2>
      <p v-if="subtitle" class="text-sm text-gray-600">
        {{ subtitle }}
      </p>
      <div v-if="divider" class="mt-3 border-b border-gray-200" />
    </header>

    <div class="page-content-body">
      <slot />
    </div>

    <footer v-if="$slots.footer" class="mt-4 pt-4 border-t border-gray-200">
      <slot name="footer" />
    </footer>
  </div>
</template>
