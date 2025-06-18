import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory ApiException.fromDioError(DioException dioError) {
    return ApiException(
      message: dioError.response?.statusMessage ?? 'Error desconocido',
      statusCode: dioError.response?.statusCode ?? 500,
      data: dioError.response?.data,
    );
  }

  @override
  String toString() => 'ApiException: $message (Code: $statusCode)';
}