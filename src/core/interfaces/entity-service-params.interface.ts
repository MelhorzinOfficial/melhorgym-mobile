export type SortEntity = { key: string; order?: boolean | 'asc' | 'desc' };

export type FilterParams = { name: string; value: any };

export interface EntityServiceParams {
  page: number;
  size: number;
  sort?: SortEntity | null;
  filter?: string;
}
