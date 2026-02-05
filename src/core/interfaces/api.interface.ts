/**
 * Interface para parâmetros de paginação
 */
export interface PaginationParams {
  /**
   * Número da página (começando em 1)
   */
  page?: number;

  /**
   * Quantidade de itens por página
   */
  limit?: number;

  /**
   * Quantidade de itens por página (alias para limit)
   */
  perPage?: number;

  /**
   * Campo para ordenação
   */
  sortBy?: string;

  /**
   * Direção da ordenação
   */
  sortOrder?: 'asc' | 'desc';
}

/**
 * Interface para query parameters genéricos
 */
export interface QueryParams extends PaginationParams {
  [key: string]: string | number | boolean | undefined;
}

/**
 * Interface para metadados de paginação na resposta
 */
export interface PaginationMeta {
  /**
   * Página atual
   */
  currentPage: number;

  /**
   * Total de páginas
   */
  totalPages: number;

  /**
   * Total de itens
   */
  totalItems: number;

  /**
   * Itens por página
   */
  itemsPerPage: number;

  /**
   * Se tem próxima página
   */
  hasNextPage: boolean;

  /**
   * Se tem página anterior
   */
  hasPreviousPage: boolean;
}

/**
 * Interface para resposta paginada da API
 */
export interface PaginatedResponse<T> {
  /**
   * Dados da resposta
   */
  data: T[];

  /**
   * Metadados de paginação
   */
  meta: PaginationMeta;
}

/**
 * Interface para resposta simples da API
 */
export interface ApiResponse<T> {
  /**
   * Dados da resposta
   */
  data: T;

  /**
   * Mensagem da API
   */
  message?: string;

  /**
   * Status da requisição
   */
  success?: boolean;
}

/**
 * Interface para configuração de requisição
 */
export interface RequestConfig {
  /**
   * Headers customizados
   */
  headers?: Record<string, string>;

  /**
   * Parâmetros de query
   */
  params?: QueryParams;

  /**
   * Timeout da requisição em ms
   */
  timeout?: number;

  /**
   * Se deve mostrar loading
   */
  showLoading?: boolean;

  /**
   * Se deve mostrar mensagem de erro
   */
  showError?: boolean;
}

/**
 * Tipo para metadados de endpoint no decorator
 */
export interface EndpointMetadata {
  /**
   * Endpoint base da entidade
   */
  endpoint: string;

  /**
   * Versão da API
   */
  version?: string;
}
