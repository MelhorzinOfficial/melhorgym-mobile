import { Endpoint } from 'src/core/decorators/endpoint.decorator';
import { Filterable } from 'src/core/decorators/filterable.decorator';
import type { DailyWorkoutResponse } from 'src/core/interfaces/workout.interface';

@Endpoint('/trainings')
export class TrainingPlan {
  declare id: number;

  @Filterable({ name: 'name' })
  declare name: string;

  declare userId: number;
  declare dailyWorkouts: DailyWorkoutResponse[];
}
