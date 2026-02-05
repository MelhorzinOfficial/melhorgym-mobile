import { ENTITY_METADATA_KEY } from 'src/core/entity.metadata.key';
import 'reflect-metadata';

export function Endpoint(endpoint: string): ClassDecorator {
  return (target) => {
    Reflect.defineMetadata(ENTITY_METADATA_KEY, endpoint, target);
  };
}
