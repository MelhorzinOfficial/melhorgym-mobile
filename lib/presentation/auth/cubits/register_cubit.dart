import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(const RegisterState());

  Future<void> register({
    String? name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    final result = await _authRepository.register(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (user) {
        emit(state.copyWith(status: RegisterStatus.success));
      },
    );
  }
}
