export type PaginatedResource<T> = {
  data: T[];
  page: number;
  itemsPerPage: number;
  totalItems: number;
};
