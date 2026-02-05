import { api } from 'src/boot/axios';
import type {
  AddDailyWorkoutInput,
  UpdateDailyWorkoutInput,
  DailyWorkoutResponse,
} from 'src/core/interfaces/workout.interface';

/**
 * Composable para gerenciar dias de treino
 *
 * @example
 * ```ts
 * const { addDailyWorkout, updateDailyWorkout, deleteDailyWorkout } = useDailyWorkout();
 *
 * // Adicionar dia de treino
 * await addDailyWorkout('1', { dayName: 'A - Peito' });
 *
 * // Atualizar dia de treino
 * await updateDailyWorkout('1', { dayName: 'A - Peito e Tríceps' });
 *
 * // Deletar dia de treino
 * await deleteDailyWorkout('1');
 * ```
 */
export const useDailyWorkout = () => {
  /**
   * Adiciona um novo dia de treino a um plano
   * POST /trainings/:id/workouts
   */
  const addDailyWorkout = async (
    trainingPlanId: string | number,
    data: AddDailyWorkoutInput,
  ): Promise<DailyWorkoutResponse> => {
    const response = await api.post<DailyWorkoutResponse>(
      `/trainings/${trainingPlanId}/workouts`,
      data,
    );
    return response.data;
  };

  /**
   * Atualiza um dia de treino existente
   * PUT /workouts/:id
   */
  const updateDailyWorkout = async (
    dailyWorkoutId: string | number,
    data: UpdateDailyWorkoutInput,
  ): Promise<DailyWorkoutResponse> => {
    const response = await api.put<DailyWorkoutResponse>(`/workouts/${dailyWorkoutId}`, data);
    return response.data;
  };

  /**
   * Deleta um dia de treino
   * DELETE /workouts/:id
   */
  const deleteDailyWorkout = async (dailyWorkoutId: string | number): Promise<void> => {
    await api.delete(`/workouts/${dailyWorkoutId}`);
  };

  return {
    addDailyWorkout,
    updateDailyWorkout,
    deleteDailyWorkout,
  };
};
