import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoggedIn extends AuthEvent {
  final User user;

  const AuthLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
