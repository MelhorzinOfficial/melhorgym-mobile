import 'package:dio/dio.dart';
import '../../data/datasources/auth_local_datasource.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDatasource _localDatasource;

  AuthInterceptor(this._localDatasource);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _localDatasource.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _localDatasource.deleteToken();
    }
    handler.next(err);
  }
}
