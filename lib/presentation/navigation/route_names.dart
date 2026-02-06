class RouteNames {
  RouteNames._();

  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String trainings = '/trainings';
  static const String trainingNew = '/trainings/new';
  static const String trainingDetail = '/trainings/:id';
  static const String trainingEdit = '/trainings/:id/edit';
  static const String profile = '/profile';

  static String trainingDetailPath(int id) => '/trainings/$id';
  static String trainingEditPath(int id) => '/trainings/$id/edit';
}
