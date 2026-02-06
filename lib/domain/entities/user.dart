import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String? name;
  final String email;
  final String role;
  final DateTime createdAt;

  const User({
    required this.id,
    this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, role, createdAt];
}
