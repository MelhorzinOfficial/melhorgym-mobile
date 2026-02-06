import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource(this._dio);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> register({
    String? name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: <String, dynamic>{
          if (name != null) 'name': name,
          'email': email,
          'password': password,
        },
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ServerException _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    String message = 'Erro de conexão com o servidor';

    if (data is Map<String, dynamic> && data.containsKey('message')) {
      message = data['message'] as String;
    } else if (statusCode != null) {
      switch (statusCode) {
        case 400:
          message = 'Dados inválidos';
        case 401:
          message = 'Email ou senha incorretos';
        case 409:
          message = 'Email já cadastrado';
        case 500:
          message = 'Erro interno do servidor';
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = 'Tempo de conexão esgotado';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'Sem conexão com a internet';
    }

    return ServerException(message, statusCode: statusCode);
  }
}
