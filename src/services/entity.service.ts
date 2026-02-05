import { ENTITY_METADATA_KEY, FILTER_METADATA_KEY } from 'src/core/entity.metadata.key';
import type { PaginatedResource } from 'src/core/interfaces/entity-data.interface';
import type { EntityServiceParams } from 'src/core/interfaces/entity-service-params.interface';
import type { AnyObject } from 'src/core/types/any-object.type';
import type { FilterableOptions } from 'src/core/decorators/interfaces/filterable-options.interface';
import { api } from 'src/boot/axios';
import 'reflect-metadata';

export class EntityService<T> {
  declare private endpoint: string;
  declare private urlParams: URLSearchParams;

  constructor(private entity: new () => T) {
    this.buildUrl();
  }

  async get(): Promise<T> {
    try {
      const { data } = await api.get(this.endpoint);
      return data;
    } catch (error) {
      throw error;
    }
  }

  async getAll(params?: EntityServiceParams): Promise<PaginatedResource<T>> {
    try {
      if (params) {
        this.urlParams = this.buildUrlParams(params);
      } else {
        this.urlParams = new URLSearchParams();
      }
      const { data } = await api.get(this.endpoint, {
        params: this.urlParams,
      });
      return data;
    } catch (error) {
      throw error;
    }
  }

  async getById(id: string): Promise<T[]> {
    try {
      const { data } = await api.get(`${this.endpoint}/${id}`);
      return data;
    } catch (error) {
      throw error;
    }
  }

  async create(payload: AnyObject): Promise<T> {
    try {
      const { data } = await api.post(this.endpoint, payload);
      return data;
    } catch (error) {
      throw error;
    }
  }

  async createCustom(id: string, payload: AnyObject): Promise<T> {
    try {
      const { data } = await api.post(`${this.endpoint}/${id}`, payload);
      return data;
    } catch (error) {
      throw error;
    }
  }

  async update(id: string, payload: AnyObject): Promise<T> {
    try {
      const { data } = await api.put(`${this.endpoint}/${id}`, payload);
      return data;
    } catch (error) {
      throw error;
    }
  }

  async delete(id: string): Promise<T> {
    try {
      const { data } = await api.delete(`${this.endpoint}/${id}`);
      return data;
    } catch (error) {
      throw error;
    }
  }

  async getOne(id: string): Promise<T> {
    try {
      const { data } = await api.get(`${this.endpoint}/${id}`);
      return data;
    } catch (error) {
      throw error;
    }
  }

  private buildUrl(): string {
    const endpoint = Reflect.getMetadata(ENTITY_METADATA_KEY, this.entity);
    if (!endpoint) {
      throw new Error(
        `Entity class ${(this.entity as any).name} is missing an @Endpoint decorator`,
      );
    }
    this.endpoint = endpoint;
    return this.endpoint;
  }

  private buildUrlParams(params: EntityServiceParams): URLSearchParams {
    const searchParams: FilterableOptions[] =
      Reflect.getMetadata(FILTER_METADATA_KEY, this.entity) || [];

    const urlParams = new URLSearchParams();
    urlParams.append('page', params.page.toString());
    urlParams.append('size', params.size.toString());

    if (params.filter) {
      const filters = searchParams
        .map((searchParam) => {
          if (searchParam.name) {
            return `${searchParam.name}:${params.filter}`;
          }
          return null;
        })
        .filter(Boolean)
        .join(';');

      if (filters) {
        urlParams.append('filter', filters);
      }
    }

    return urlParams;
  }
}
