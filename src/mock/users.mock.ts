import type { UserResponse } from 'src/core/interfaces/user.interface';

export const mockUsers: UserResponse[] = [
  {
    id: 1,
    email: 'joao.silva@gmail.com',
    role: 'user',
    createdAt: '2024-01-15T10:30:00.000Z',
  },
  {
    id: 2,
    email: 'maria.santos@gmail.com',
    role: 'user',
    createdAt: '2024-02-20T14:45:00.000Z',
  },
  {
    id: 3,
    email: 'admin@melhorgym.com',
    role: 'admin',
    createdAt: '2023-12-01T08:00:00.000Z',
  },
];

export const mockCurrentUser: UserResponse = mockUsers[0]!;
