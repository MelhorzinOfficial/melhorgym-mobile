import { TrainingPlan } from 'src/core/entities/training-plan.entity';
import { EntityService } from 'src/services/entity.service';
import { toValue, type MaybeRefOrGetter } from 'vue';
import type {
  CreateWorkoutInput,
  TrainingPlanResponse,
  ListWorkoutsResponse,
} from 'src/core/interfaces/workout.interface';
import type { EntityServiceParams } from 'src/core/interfaces/entity-service-params.interface';

export interface UseWorkoutParams {
  workoutId?: MaybeRefOrGetter<string>;
}

/**
 * Composable para gerenciar treinos
 *
 * @example
 * ```ts
 * const { fetchWorkout, fetchWorkouts, createWorkout, updateWorkout, deleteWorkout } = useWorkout({ workoutId: '1' });
 *
 * // Buscar um treino
 * const workout = await fetchWorkout();
 *
 * // Listar treinos
 * const workouts = await fetchWorkouts({ page: 1, size: 10 });
 *
 * // Criar treino
 * await createWorkout({ name: 'Treino ABC', dailyWorkouts: [...] });
 * ```
 */
export const useWorkout = (params?: UseWorkoutParams) => {
  const service = new EntityService(TrainingPlan);

  const fetchWorkout = async (): Promise<TrainingPlanResponse> => {
    if (!params?.workoutId) {
      throw new Error('workoutId is required');
    }
    const workoutId = toValue(params.workoutId);
    return await service.getOne(workoutId);
  };

  const fetchWorkouts = async (
    queryParams?: EntityServiceParams,
  ): Promise<ListWorkoutsResponse> => {
    const result = await service.getAll(queryParams);
    // A API retorna um array diretamente, não um objeto paginado
    return result as unknown as TrainingPlanResponse[];
  };

  const createWorkout = async (data: CreateWorkoutInput): Promise<TrainingPlanResponse> => {
    return await service.create(data);
  };

  const updateWorkout = async (
    id: string,
    data: Partial<CreateWorkoutInput>,
  ): Promise<TrainingPlanResponse> => {
    return await service.update(id, data);
  };

  const deleteWorkout = async (id: string): Promise<void> => {
    await service.delete(id);
  };

  return {
    fetchWorkout,
    fetchWorkouts,
    createWorkout,
    updateWorkout,
    deleteWorkout,
  };
};
