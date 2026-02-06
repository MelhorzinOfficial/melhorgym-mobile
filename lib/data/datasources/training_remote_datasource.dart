import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/training_plan_model.dart';

class TrainingRemoteDatasource {
  final Dio _dio;

  TrainingRemoteDatasource(this._dio);

  Future<List<TrainingPlanModel>> getTrainings() async {
    try {
      final response = await _dio.get(ApiConstants.trainings);
      return (response.data as List<dynamic>)
          .map((e) => TrainingPlanModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TrainingPlanModel> getTrainingById(int id) async {
    try {
      final response = await _dio.get(ApiConstants.trainingById(id));
      return TrainingPlanModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TrainingPlanModel> createTraining(TrainingPlanModel plan) async {
    try {
      final response = await _dio.post(
        ApiConstants.trainings,
        data: plan.toJson(),
      );
      return TrainingPlanModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TrainingPlanModel> updateTraining(int id, TrainingPlanModel plan) async {
    try {
      final response = await _dio.put(
        ApiConstants.trainingById(id),
        data: plan.toJson(),
      );
      return TrainingPlanModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteTraining(int id) async {
    try {
      await _dio.delete(ApiConstants.trainingById(id));
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
    } else if (statusCode == 401) {
      throw const UnauthorizedException();
    } else if (statusCode == 404) {
      message = 'Plano de treino não encontrado';
    }

    return ServerException(message, statusCode: statusCode);
  }
}
