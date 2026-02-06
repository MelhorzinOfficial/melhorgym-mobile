class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://melhorgym-api.melhorzin.com';

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // User
  static const String me = '/me';
  static const String users = '/users';

  // Training
  static const String trainings = '/trainings';

  static String userById(int id) => '/users/$id';
  static String trainingById(int id) => '/trainings/$id';
}
