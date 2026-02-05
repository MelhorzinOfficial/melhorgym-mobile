import { Endpoint } from 'src/core/decorators/endpoint.decorator';
import { Filterable } from 'src/core/decorators/filterable.decorator';

@Endpoint('/exercises')
export class Exercise {
  declare id: number;

  @Filterable({ name: 'name' })
  declare name: string;

  declare sets: number;
  declare reps: string;
  declare dailyWorkoutId: number;
}
