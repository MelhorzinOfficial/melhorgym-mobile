import { User } from 'src/core/entities/user.entity';
import { EntityService } from 'src/services/entity.service';
import { toValue, type MaybeRefOrGetter } from 'vue';
import type {
  RegisterUserInput,
  UpdateUserInput,
  UserResponse,
} from 'src/core/interfaces/user.interface';

export interface UseUserParams {
  userId?: MaybeRefOrGetter<string>;
}

/**
 * Composable para gerenciar usuários
 *
 * @example
 * ```ts
 * const { fetchUser, updateUser, deleteUser } = useUser({ userId: '1' });
 *
 * // Buscar usuário
 * const user = await fetchUser();
 *
 * // Atualizar
 * await updateUser({ email: 'newemail@test.com' });
 * ```
 */
export const useUser = (params?: UseUserParams) => {
  const service = new EntityService(User);

  const fetchUser = async (): Promise<UserResponse> => {
    if (!params?.userId) {
      throw new Error('userId is required');
    }
    const userId = toValue(params.userId);
    return await service.getOne(userId);
  };

  const createUser = async (data: RegisterUserInput): Promise<UserResponse> => {
    return await service.create(data);
  };

  const updateUser = async (id: string, data: UpdateUserInput): Promise<UserResponse> => {
    return await service.update(id, data);
  };

  const deleteUser = async (id: string): Promise<void> => {
    await service.delete(id);
  };

  return {
    fetchUser,
    createUser,
    updateUser,
    deleteUser,
  };
};
