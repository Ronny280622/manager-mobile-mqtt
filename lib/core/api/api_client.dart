import 'package:dio/dio.dart';
import 'package:manager_mqtt/core/api/api_response.dart';

class ApiClient {
  late Dio _dio;

  ApiClient({required Dio dio}) {
    _dio = dio;
  }

  Future<ApiResponse> request({ required path, String method = "GET", Map<String, dynamic>? body }) async {
    try {
      final res = await _dio.request(
          path,
          options: Options(method: method),
          data: body
      );
      dynamic rsl = res.data;
      if (rsl['status'] == 'error') {
        String errorMessage = rsl['error'];
        return ApiResponse.fail(status: 0, error: errorMessage, results: body);
      }
      return ApiResponse.success(rsl);
    } catch (e) {
      print('Stack trace: $e');
      int statusCode = -1;
      String message =  'Error desconocido';
      dynamic data;
      if(e is DioException){
        message = e.message!;
        if(e.response != null){
          statusCode = e.response!.statusCode!;
          message = e.response!.statusMessage!;
          data = e.response!.data;
        }
      }
      return ApiResponse.fail(
          status: statusCode, error: message, results: data);
    }
  }
}