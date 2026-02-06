import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/user_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _userRepository;

  ProfileCubit(this._userRepository) : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _userRepository.getProfile();
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ));
      },
      (user) {
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
        ));
      },
    );
  }

  Future<void> updateProfile({
    required int id,
    String? name,
    String? email,
    String? password,
  }) async {
    emit(state.copyWith(status: ProfileStatus.saving));

    final result = await _userRepository.updateProfile(
      id: id,
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ));
      },
      (user) {
        emit(state.copyWith(
          status: ProfileStatus.saved,
          user: user,
        ));
      },
    );
  }
}
