import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (user) {
        emit(state.copyWith(status: LoginStatus.success));
      },
    );
  }
}
