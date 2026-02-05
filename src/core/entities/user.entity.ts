import { Endpoint } from 'src/core/decorators/endpoint.decorator';
import { Filterable } from 'src/core/decorators/filterable.decorator';

@Endpoint('/users')
export class User {
  declare id: number;

  @Filterable({ name: 'email' })
  declare email: string;

  declare role: string;
  declare createdAt: Date | string;
}
