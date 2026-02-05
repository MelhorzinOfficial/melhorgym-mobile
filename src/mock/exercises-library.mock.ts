/**
 * Biblioteca de exercícios comuns organizados por grupo muscular
 */

export type MuscleGroup =
  | 'peito'
  | 'costas'
  | 'ombros'
  | 'biceps'
  | 'triceps'
  | 'pernas'
  | 'gluteos'
  | 'abdomen'
  | 'cardio';

export interface ExerciseLibraryItem {
  name: string;
  muscleGroup: MuscleGroup;
  variations?: string[];
}

export const muscleGroups: { value: MuscleGroup; label: string }[] = [
  { value: 'peito', label: 'Peito' },
  { value: 'costas', label: 'Costas' },
  { value: 'ombros', label: 'Ombros' },
  { value: 'biceps', label: 'Bíceps' },
  { value: 'triceps', label: 'Tríceps' },
  { value: 'pernas', label: 'Pernas' },
  { value: 'gluteos', label: 'Glúteos' },
  { value: 'abdomen', label: 'Abdômen' },
  { value: 'cardio', label: 'Cardio' },
];

export const exercisesLibrary: ExerciseLibraryItem[] = [
  // Peito
  { name: 'Supino Reto', muscleGroup: 'peito' },
  { name: 'Supino Inclinado', muscleGroup: 'peito' },
  { name: 'Supino Declinado', muscleGroup: 'peito' },
  { name: 'Supino com Halteres', muscleGroup: 'peito' },
  { name: 'Supino Inclinado com Halteres', muscleGroup: 'peito' },
  { name: 'Crucifixo', muscleGroup: 'peito' },
  { name: 'Crucifixo Inclinado', muscleGroup: 'peito' },
  { name: 'Fly no Peck Deck', muscleGroup: 'peito' },
  { name: 'Crossover', muscleGroup: 'peito' },
  { name: 'Flexão de Braço', muscleGroup: 'peito' },

  // Costas
  { name: 'Barra Fixa', muscleGroup: 'costas' },
  { name: 'Puxada Frontal', muscleGroup: 'costas' },
  { name: 'Puxada com Triângulo', muscleGroup: 'costas' },
  { name: 'Remada Curvada', muscleGroup: 'costas' },
  { name: 'Remada Cavalinho', muscleGroup: 'costas' },
  { name: 'Remada Unilateral', muscleGroup: 'costas' },
  { name: 'Remada Sentado', muscleGroup: 'costas' },
  { name: 'Levantamento Terra', muscleGroup: 'costas' },
  { name: 'Pullover', muscleGroup: 'costas' },
  { name: 'Remada Baixa', muscleGroup: 'costas' },

  // Ombros
  { name: 'Desenvolvimento com Barra', muscleGroup: 'ombros' },
  { name: 'Desenvolvimento com Halteres', muscleGroup: 'ombros' },
  { name: 'Elevação Lateral', muscleGroup: 'ombros' },
  { name: 'Elevação Frontal', muscleGroup: 'ombros' },
  { name: 'Elevação Posterior', muscleGroup: 'ombros' },
  { name: 'Remada Alta', muscleGroup: 'ombros' },
  { name: 'Encolhimento', muscleGroup: 'ombros' },
  { name: 'Desenvolvimento Arnold', muscleGroup: 'ombros' },

  // Bíceps
  { name: 'Rosca Direta', muscleGroup: 'biceps' },
  { name: 'Rosca Alternada', muscleGroup: 'biceps' },
  { name: 'Rosca Martelo', muscleGroup: 'biceps' },
  { name: 'Rosca Concentrada', muscleGroup: 'biceps' },
  { name: 'Rosca Scott', muscleGroup: 'biceps' },
  { name: 'Rosca Inversa', muscleGroup: 'biceps' },
  { name: 'Rosca 21', muscleGroup: 'biceps' },

  // Tríceps
  { name: 'Tríceps Testa', muscleGroup: 'triceps' },
  { name: 'Tríceps Francês', muscleGroup: 'triceps' },
  { name: 'Tríceps Corda', muscleGroup: 'triceps' },
  { name: 'Tríceps Barra', muscleGroup: 'triceps' },
  { name: 'Mergulho', muscleGroup: 'triceps' },
  { name: 'Tríceps Coice', muscleGroup: 'triceps' },

  // Pernas
  { name: 'Agachamento', muscleGroup: 'pernas' },
  { name: 'Agachamento Sumô', muscleGroup: 'pernas' },
  { name: 'Leg Press', muscleGroup: 'pernas' },
  { name: 'Cadeira Extensora', muscleGroup: 'pernas' },
  { name: 'Cadeira Flexora', muscleGroup: 'pernas' },
  { name: 'Stiff', muscleGroup: 'pernas' },
  { name: 'Avanço', muscleGroup: 'pernas' },
  { name: 'Agachamento Búlgaro', muscleGroup: 'pernas' },
  { name: 'Panturrilha em Pé', muscleGroup: 'pernas' },
  { name: 'Panturrilha Sentado', muscleGroup: 'pernas' },

  // Glúteos
  { name: 'Hip Thrust', muscleGroup: 'gluteos' },
  { name: 'Elevação Pélvica', muscleGroup: 'gluteos' },
  { name: 'Abdução de Quadril', muscleGroup: 'gluteos' },
  { name: 'Coice na Polia', muscleGroup: 'gluteos' },
  { name: 'Stiff com Halteres', muscleGroup: 'gluteos' },

  // Abdômen
  { name: 'Abdominal Supra', muscleGroup: 'abdomen' },
  { name: 'Abdominal Infra', muscleGroup: 'abdomen' },
  { name: 'Abdominal Oblíquo', muscleGroup: 'abdomen' },
  { name: 'Prancha', muscleGroup: 'abdomen' },
  { name: 'Prancha Lateral', muscleGroup: 'abdomen' },
  { name: 'Abdominal Bicicleta', muscleGroup: 'abdomen' },
  { name: 'Elevação de Pernas', muscleGroup: 'abdomen' },

  // Cardio
  { name: 'Esteira', muscleGroup: 'cardio' },
  { name: 'Bicicleta Ergométrica', muscleGroup: 'cardio' },
  { name: 'Elíptico', muscleGroup: 'cardio' },
  { name: 'Transport', muscleGroup: 'cardio' },
  { name: 'Remo', muscleGroup: 'cardio' },
  { name: 'Pular Corda', muscleGroup: 'cardio' },
];

/**
 * Filtra exercícios por grupo muscular
 */
export const getExercisesByMuscleGroup = (
  muscleGroup: MuscleGroup | 'all',
): ExerciseLibraryItem[] => {
  if (muscleGroup === 'all') {
    return exercisesLibrary;
  }
  return exercisesLibrary.filter((ex) => ex.muscleGroup === muscleGroup);
};

/**
 * Busca exercícios por nome
 */
export const searchExercises = (
  query: string,
  muscleGroup?: MuscleGroup | 'all',
): ExerciseLibraryItem[] => {
  const exercises = muscleGroup ? getExercisesByMuscleGroup(muscleGroup) : exercisesLibrary;

  if (!query) {
    return exercises;
  }

  const normalizedQuery = query.toLowerCase().trim();
  return exercises.filter((ex) => ex.name.toLowerCase().includes(normalizedQuery));
};

/**
 * Identifica o grupo muscular de um exercício pelo nome
 * Retorna 'all' se não encontrar
 */
export const getMuscleGroupByExerciseName = (exerciseName: string): MuscleGroup | 'all' => {
  const normalizedName = exerciseName.toLowerCase().trim();
  const exercise = exercisesLibrary.find((ex) => ex.name.toLowerCase() === normalizedName);
  return exercise ? exercise.muscleGroup : 'all';
};
