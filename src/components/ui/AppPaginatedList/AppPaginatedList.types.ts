export interface AppPaginatedListProps<T> {
  /** Array de itens para exibir */
  items: T[];

  /** Total de itens disponíveis (para paginação) */
  totalItems?: number;

  /** Função para obter a chave única de cada item */
  itemKey?: string | ((item: T) => string | number);

  /** Tamanho estimado de cada item em pixels (para virtual scroll) */
  itemSize?: number;

  /** Quantidade de itens a renderizar além do viewport */
  sliceSize?: number;

  /** Classe CSS para cada item */
  itemClass?: string;

  /** Indica se está carregando */
  loading?: boolean;

  /** Indica se está carregando mais itens */
  loadingMore?: boolean;

  /** Indica se há mais itens para carregar */
  hasMore?: boolean;

  /** Texto exibido durante carregamento */
  loadingText?: string;

  /** Título do estado vazio */
  emptyTitle?: string;

  /** Mensagem do estado vazio */
  emptyMessage?: string;

  /** Percentual de scroll para disparar load more automático (0-1) */
  loadMoreThreshold?: number;
}

export interface VirtualScrollDetails {
  index: number;
  from: number;
  to: number;
  direction: 'increase' | 'decrease';
}

export interface AppPaginatedListEmits {
  'load-more': [];
  scroll: [details: VirtualScrollDetails];
}
