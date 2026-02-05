import type { TrainingPlanResponse } from 'src/core/interfaces/workout.interface';
import { getDailyWorkoutsByTrainingPlanId } from './daily-workouts.mock';

export const mockTrainingPlans: TrainingPlanResponse[] = [
  {
    id: 1,
    name: 'Treino ABC - Hipertrofia',
    userId: 1,
    dailyWorkouts: getDailyWorkoutsByTrainingPlanId(1),
  },
  {
    id: 2,
    name: 'Push Pull Legs',
    userId: 1,
    dailyWorkouts: getDailyWorkoutsByTrainingPlanId(2),
  },
  {
    id: 3,
    name: 'Full Body 3x',
    userId: 2,
    dailyWorkouts: [
      {
        id: 9,
        dayName: 'Segunda-Feira',
        trainingPlanId: 3,
        exercises: [
          {
            id: 31,
            name: 'Agachamento',
            sets: 3,
            reps: '10-12',
            dailyWorkoutId: 9,
          },
          {
            id: 32,
            name: 'Supino Reto',
            sets: 3,
            reps: '10-12',
            dailyWorkoutId: 9,
          },
          {
            id: 33,
            name: 'Remada',
            sets: 3,
            reps: '10-12',
            dailyWorkoutId: 9,
          },
        ],
      },
      {
        id: 10,
        dayName: 'Quarta-Feira',
        trainingPlanId: 3,
        exercises: [
          {
            id: 34,
            name: 'Leg Press',
            sets: 3,
            reps: '12-15',
            dailyWorkoutId: 10,
          },
          {
            id: 35,
            name: 'Desenvolvimento',
            sets: 3,
            reps: '10-12',
            dailyWorkoutId: 10,
          },
          {
            id: 36,
            name: 'Puxada Frontal',
            sets: 3,
            reps: '10-12',
            dailyWorkoutId: 10,
          },
        ],
      },
      {
        id: 11,
        dayName: 'Sexta-Feira',
        trainingPlanId: 3,
        exercises: [
          {
            id: 37,
            name: 'Stiff',
            sets: 3,
            reps: '10-12',
            dailyWorkoutId: 11,
          },
          {
            id: 38,
            name: 'Supino Inclinado',
            sets: 3,
            reps: '10-12',
            dailyWorkoutId: 11,
          },
          {
            id: 39,
            name: 'Remada Unilateral',
            sets: 3,
            reps: '10-12',
            dailyWorkoutId: 11,
          },
        ],
      },
    ],
  },
];

export const getTrainingPlansByUserId = (userId: number): TrainingPlanResponse[] => {
  return mockTrainingPlans.filter((tp) => tp.userId === userId);
};
