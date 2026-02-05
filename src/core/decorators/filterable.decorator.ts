import { FILTER_METADATA_KEY } from 'src/core/entity.metadata.key';
import type { FilterableOptions } from './interfaces/filterable-options.interface';
import 'reflect-metadata';

export const Filterable =
  (options?: FilterableOptions): PropertyDecorator =>
  (target, propertyKey: string | symbol): void => {
    const oldMetadata: FilterableOptions[] =
      Reflect.getMetadata(FILTER_METADATA_KEY, target.constructor) || [];

    oldMetadata.push({ name: options?.name || propertyKey.toString() });

    Reflect.defineMetadata(FILTER_METADATA_KEY, oldMetadata, target.constructor);
  };
