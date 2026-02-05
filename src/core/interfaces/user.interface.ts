// User Types
export interface RegisterUserInput {
  email: string;
  password: string;
}

export interface AuthenticateUserInput {
  email: string;
  password: string;
}

export interface UpdateUserInput {
  email?: string;
  password?: string;
  role?: 'admin' | 'user';
}

export interface UserResponse {
  id: number;
  email: string;
  role: string;
  createdAt: string | Date;
}

export type ListUsersResponse = UserResponse[];

export interface AuthResponse {
  token: string;
  user: UserResponse;
}
