import type { ExerciseResponse } from 'src/core/interfaces/workout.interface';

export const mockExercises: ExerciseResponse[] = [
  // Exercícios para Peito
  {
    id: 1,
    name: 'Supino Reto com Barra',
    sets: 4,
    reps: '8-12',
    dailyWorkoutId: 1,
  },
  {
    id: 2,
    name: 'Supino Inclinado com Halteres',
    sets: 3,
    reps: '10-12',
    dailyWorkoutId: 1,
  },
  {
    id: 3,
    name: 'Crucifixo no Cabo',
    sets: 3,
    reps: '12-15',
    dailyWorkoutId: 1,
  },
  {
    id: 4,
    name: 'Flexão de Braço',
    sets: 3,
    reps: '15-20',
    dailyWorkoutId: 1,
  },

  // Exercícios para Costas
  {
    id: 5,
    name: 'Barra Fixa',
    sets: 4,
    reps: '8-12',
    dailyWorkoutId: 2,
  },
  {
    id: 6,
    name: 'Remada Curvada com Barra',
    sets: 4,
    reps: '10-12',
    dailyWorkoutId: 2,
  },
  {
    id: 7,
    name: 'Puxada Frontal',
    sets: 3,
    reps: '12-15',
    dailyWorkoutId: 2,
  },
  {
    id: 8,
    name: 'Remada Unilateral com Halter',
    sets: 3,
    reps: '10-12',
    dailyWorkoutId: 2,
  },

  // Exercícios para Pernas
  {
    id: 9,
    name: 'Agachamento Livre',
    sets: 4,
    reps: '8-12',
    dailyWorkoutId: 3,
  },
  {
    id: 10,
    name: 'Leg Press 45°',
    sets: 4,
    reps: '12-15',
    dailyWorkoutId: 3,
  },
  {
    id: 11,
    name: 'Cadeira Extensora',
    sets: 3,
    reps: '12-15',
    dailyWorkoutId: 3,
  },
  {
    id: 12,
    name: 'Mesa Flexora',
    sets: 3,
    reps: '12-15',
    dailyWorkoutId: 3,
  },
  {
    id: 13,
    name: 'Panturrilha em Pé',
    sets: 4,
    reps: '15-20',
    dailyWorkoutId: 3,
  },

  // Exercícios para Ombros
  {
    id: 14,
    name: 'Desenvolvimento com Barra',
    sets: 4,
    reps: '8-12',
    dailyWorkoutId: 4,
  },
  {
    id: 15,
    name: 'Elevação Lateral com Halteres',
    sets: 3,
    reps: '12-15',
    dailyWorkoutId: 4,
  },
  {
    id: 16,
    name: 'Elevação Frontal',
    sets: 3,
    reps: '12-15',
    dailyWorkoutId: 4,
  },
  {
    id: 17,
    name: 'Remada Alta',
    sets: 3,
    reps: '10-12',
    dailyWorkoutId: 4,
  },

  // Exercícios para Braços
  {
    id: 18,
    name: 'Rosca Direta com Barra',
    sets: 3,
    reps: '10-12',
    dailyWorkoutId: 5,
  },
  {
    id: 19,
    name: 'Rosca Alternada com Halteres',
    sets: 3,
    reps: '10-12',
    dailyWorkoutId: 5,
  },
  {
    id: 20,
    name: 'Tríceps Testa',
    sets: 3,
    reps: '10-12',
    dailyWorkoutId: 5,
  },
  {
    id: 21,
    name: 'Tríceps Corda',
    sets: 3,
    reps: '12-15',
    dailyWorkoutId: 5,
  },
];

export const getExercisesByDailyWorkoutId = (dailyWorkoutId: number): ExerciseResponse[] => {
  return mockExercises.filter((ex) => ex.dailyWorkoutId === dailyWorkoutId);
};
