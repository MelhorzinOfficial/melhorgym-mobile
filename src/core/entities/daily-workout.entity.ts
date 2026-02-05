import { Endpoint } from 'src/core/decorators/endpoint.decorator';
import { Filterable } from 'src/core/decorators/filterable.decorator';
import type { ExerciseResponse } from 'src/core/interfaces/workout.interface';

@Endpoint('/daily-workouts')
export class DailyWorkout {
  declare id: number;

  @Filterable({ name: 'dayName' })
  declare dayName: string;

  declare trainingPlanId: number;
  declare exercises: ExerciseResponse[];
}
