import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';

class AuthLocalDatasource {
  final SharedPreferences _prefs;

  AuthLocalDatasource(this._prefs);

  Future<void> saveToken(String token) async {
    final success = await _prefs.setString(AppConstants.tokenKey, token);
    if (!success) {
      throw const CacheException('Falha ao salvar token');
    }
  }

  String? getToken() {
    return _prefs.getString(AppConstants.tokenKey);
  }

  Future<void> deleteToken() async {
    await _prefs.remove(AppConstants.tokenKey);
  }

  bool hasToken() {
    return _prefs.containsKey(AppConstants.tokenKey);
  }
}
