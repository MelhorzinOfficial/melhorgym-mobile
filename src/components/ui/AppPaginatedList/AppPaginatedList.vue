<template>
  <div class="flex flex-col h-full">
    <!-- Header (optional) -->
    <div v-if="$slots.header" class="mb-4">
      <slot name="header" :total="totalItems" :loading="loading" />
    </div>

    <!-- Loading State -->
    <div v-if="loading && items.length === 0" class="flex-1 flex items-center justify-center py-12">
      <div class="text-center">
        <div
          class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600 mb-4"
        ></div>
        <p class="text-secondary-600">{{ loadingText }}</p>
      </div>
    </div>

    <!-- Empty State -->
    <div
      v-else-if="!loading && items.length === 0"
      class="flex-1 flex items-center justify-center py-12"
    >
      <div class="text-center max-w-sm">
        <slot name="empty">
          <div class="text-secondary-400 mb-4">
            <svg class="w-16 h-16 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"
              />
            </svg>
          </div>
          <h3 class="text-lg font-semibold text-secondary-900 mb-2">{{ emptyTitle }}</h3>
          <p class="text-secondary-600">{{ emptyMessage }}</p>
        </slot>
      </div>
    </div>

    <!-- List with Virtual Scroll -->
    <q-virtual-scroll
      v-else
      :items="items"
      :virtual-scroll-item-size="itemSize"
      :virtual-scroll-slice-size="sliceSize"
      class="flex-1"
      @virtual-scroll="onVirtualScroll"
    >
      <template v-slot="{ item, index }">
        <div :key="getItemKey(item, index)" :class="itemClass">
          <slot name="item" :item="item" :index="index">
            <AppCard hoverable>
              <pre class="text-sm">{{ item }}</pre>
            </AppCard>
          </slot>
        </div>
      </template>
    </q-virtual-scroll>

    <!-- Load More Indicator -->
    <div v-if="hasMore && !loading" class="py-4 text-center">
      <AppButton variant="ghost" size="sm" :loading="loadingMore" @click="loadMore">
        Carregar mais
      </AppButton>
    </div>

    <!-- Loading More Indicator -->
    <div v-if="loadingMore" class="py-4 text-center">
      <div
        class="inline-block animate-spin rounded-full h-6 w-6 border-b-2 border-primary-600"
      ></div>
    </div>

    <!-- Footer (optional) -->
    <div v-if="$slots.footer" class="mt-4">
      <slot name="footer" :total="totalItems" :showing="items.length" />
    </div>
  </div>
</template>

<script setup lang="ts" generic="T">
import { ref, computed } from 'vue';
import { QVirtualScroll } from 'quasar';
import type {
  AppPaginatedListProps,
  AppPaginatedListEmits,
  VirtualScrollDetails,
} from './AppPaginatedList.types';
import AppCard from '../AppCard';
import AppButton from '../AppButton';

const props = withDefaults(defineProps<AppPaginatedListProps<T>>(), {
  itemSize: 100,
  sliceSize: 30,
  itemClass: 'mb-4',
  loading: false,
  loadingMore: false,
  hasMore: false,
  loadingText: 'Carregando...',
  emptyTitle: 'Nenhum item encontrado',
  emptyMessage: 'Não há itens para exibir no momento.',
  loadMoreThreshold: 0.8,
});

const emit = defineEmits<AppPaginatedListEmits>();

const lastScrollIndex = ref(0);

const totalItems = computed(() => props.totalItems ?? props.items.length);

/**
 * Obtém a chave única de um item
 */
function getItemKey(item: T, index: number): string | number {
  if (!props.itemKey) {
    return index;
  }

  if (typeof props.itemKey === 'string') {
    return (item as any)[props.itemKey] ?? index;
  }

  return props.itemKey(item);
}

/**
 * Handler do evento de scroll virtual
 */
function onVirtualScroll(details: VirtualScrollDetails) {
  emit('scroll', details);

  // Auto load more quando rolar próximo ao fim
  if (
    props.hasMore &&
    !props.loadingMore &&
    details.direction === 'increase' &&
    details.index > lastScrollIndex.value
  ) {
    const scrollPercentage = details.to / props.items.length;

    if (scrollPercentage >= props.loadMoreThreshold) {
      loadMore();
    }
  }

  lastScrollIndex.value = details.index;
}

/**
 * Carrega mais itens
 */
function loadMore() {
  if (!props.loadingMore && props.hasMore) {
    emit('load-more');
  }
}
</script>
