// Exercise Types
export interface Exercise {
  name: string;
  sets: number;
  reps: string;
}

export interface ExerciseResponse extends Exercise {
  id: number;
  dailyWorkoutId: number;
}

export interface AddExerciseInput {
  name: string;
  sets: number;
  reps: string;
}

export interface UpdateExerciseInput {
  name?: string;
  sets?: number;
  reps?: string;
}

// Daily Workout Types
export interface DailyWorkout {
  dayName: string;
  exercises: Exercise[];
}

export interface DailyWorkoutResponse {
  id: number;
  dayName: string;
  trainingPlanId: number;
  exercises: ExerciseResponse[];
}

export interface AddDailyWorkoutInput {
  dayName: string;
}

export interface UpdateDailyWorkoutInput {
  dayName?: string;
}

// Training Plan (Workout) Types
export interface CreateWorkoutInput {
  name: string;
  dailyWorkouts: DailyWorkout[];
}

export interface UpdateWorkoutInput {
  name?: string;
}

export interface TrainingPlanResponse {
  id: number;
  name: string;
  userId: number;
  dailyWorkouts: DailyWorkoutResponse[];
}

export type ListWorkoutsResponse = TrainingPlanResponse[];
