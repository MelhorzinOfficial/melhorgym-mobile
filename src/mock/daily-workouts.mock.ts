import type { DailyWorkoutResponse } from 'src/core/interfaces/workout.interface';
import { getExercisesByDailyWorkoutId } from './exercises.mock';

export const mockDailyWorkouts: DailyWorkoutResponse[] = [
  {
    id: 1,
    dayName: 'A - Peito',
    trainingPlanId: 1,
    exercises: getExercisesByDailyWorkoutId(1),
  },
  {
    id: 2,
    dayName: 'B - Costas',
    trainingPlanId: 1,
    exercises: getExercisesByDailyWorkoutId(2),
  },
  {
    id: 3,
    dayName: 'C - Pernas',
    trainingPlanId: 1,
    exercises: getExercisesByDailyWorkoutId(3),
  },
  {
    id: 4,
    dayName: 'D - Ombros',
    trainingPlanId: 1,
    exercises: getExercisesByDailyWorkoutId(4),
  },
  {
    id: 5,
    dayName: 'E - Braços',
    trainingPlanId: 1,
    exercises: getExercisesByDailyWorkoutId(5),
  },
  {
    id: 6,
    dayName: 'A - Push (Empurrar)',
    trainingPlanId: 2,
    exercises: [
      {
        id: 22,
        name: 'Supino Reto',
        sets: 4,
        reps: '8-10',
        dailyWorkoutId: 6,
      },
      {
        id: 23,
        name: 'Desenvolvimento Militar',
        sets: 4,
        reps: '8-10',
        dailyWorkoutId: 6,
      },
      {
        id: 24,
        name: 'Tríceps Paralelas',
        sets: 3,
        reps: '10-12',
        dailyWorkoutId: 6,
      },
    ],
  },
  {
    id: 7,
    dayName: 'B - Pull (Puxar)',
    trainingPlanId: 2,
    exercises: [
      {
        id: 25,
        name: 'Barra Fixa',
        sets: 4,
        reps: '8-10',
        dailyWorkoutId: 7,
      },
      {
        id: 26,
        name: 'Remada Curvada',
        sets: 4,
        reps: '8-10',
        dailyWorkoutId: 7,
      },
      {
        id: 27,
        name: 'Rosca Direta',
        sets: 3,
        reps: '10-12',
        dailyWorkoutId: 7,
      },
    ],
  },
  {
    id: 8,
    dayName: 'C - Legs (Pernas)',
    trainingPlanId: 2,
    exercises: [
      {
        id: 28,
        name: 'Agachamento Livre',
        sets: 4,
        reps: '8-10',
        dailyWorkoutId: 8,
      },
      {
        id: 29,
        name: 'Stiff',
        sets: 3,
        reps: '10-12',
        dailyWorkoutId: 8,
      },
      {
        id: 30,
        name: 'Leg Press',
        sets: 3,
        reps: '12-15',
        dailyWorkoutId: 8,
      },
    ],
  },
];

export const getDailyWorkoutsByTrainingPlanId = (
  trainingPlanId: number,
): DailyWorkoutResponse[] => {
  return mockDailyWorkouts.filter((dw) => dw.trainingPlanId === trainingPlanId);
};
