import type { DailyWorkoutResponse } from 'src/core/interfaces/workout.interface';
import { mockDailyWorkouts } from './daily-workouts.mock';

/**
 * Mock do treino do dia atual
 * Em produção, isso virá do backend baseado na data atual e plano do usuário
 */
export const mockTodayWorkout: DailyWorkoutResponse = mockDailyWorkouts[0]!; // A - Peito

/**
 * Simula diferentes treinos para testar a UI
 * Descomente a linha desejada para testar
 */
// export const mockTodayWorkout: DailyWorkoutResponse = mockDailyWorkouts[1]; // B - Costas
// export const mockTodayWorkout: DailyWorkoutResponse = mockDailyWorkouts[2]; // C - Pernas
// export const mockTodayWorkout: DailyWorkoutResponse = mockDailyWorkouts[3]; // D - Ombros
