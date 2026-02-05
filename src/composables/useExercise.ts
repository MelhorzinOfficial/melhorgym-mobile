import { api } from 'src/boot/axios';
import type {
  AddExerciseInput,
  UpdateExerciseInput,
  ExerciseResponse,
} from 'src/core/interfaces/workout.interface';

/**
 * Composable para gerenciar exercícios
 *
 * @example
 * ```ts
 * const { addExercise, updateExercise, deleteExercise } = useExercise();
 *
 * // Adicionar exercício
 * await addExercise('1', { name: 'Supino Reto', sets: 4, reps: '8-12' });
 *
 * // Atualizar exercício
 * await updateExercise('1', { sets: 5, reps: '6-10' });
 *
 * // Deletar exercício
 * await deleteExercise('1');
 * ```
 */
export const useExercise = () => {
  /**
   * Adiciona um novo exercício a um dia de treino
   * POST /workouts/:id/exercises
   */
  const addExercise = async (
    dailyWorkoutId: string | number,
    data: AddExerciseInput,
  ): Promise<ExerciseResponse> => {
    const response = await api.post<ExerciseResponse>(
      `/workouts/${dailyWorkoutId}/exercises`,
      data,
    );
    return response.data;
  };

  /**
   * Atualiza um exercício existente
   * PUT /exercises/:id
   */
  const updateExercise = async (
    exerciseId: string | number,
    data: UpdateExerciseInput,
  ): Promise<ExerciseResponse> => {
    const response = await api.put<ExerciseResponse>(`/exercises/${exerciseId}`, data);
    return response.data;
  };

  /**
   * Deleta um exercício
   * DELETE /exercises/:id
   */
  const deleteExercise = async (exerciseId: string | number): Promise<void> => {
    await api.delete(`/exercises/${exerciseId}`);
  };

  return {
    addExercise,
    updateExercise,
    deleteExercise,
  };
};
