import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manager_mqtt/core/api/api_excepcion.dart';
import 'package:manager_mqtt/core/utils/global_keys.dart';
import 'package:manager_mqtt/feature/auth/login_screen.dart';

class AuthInterceptor extends Interceptor {

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    return handler.next(options);
  }
}

class ErrorInterceptor extends Interceptor {

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if(err.response?.statusCode == 401){
      WidgetsBinding.instance.addPostFrameCallback((callback) async {
        Navigator.of(GlobalKeys.navigationKey.currentContext!).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false
        );
      });
      throw ApiException(message: 'Sesión expirada', statusCode: 401);
    }
    throw ApiException.fromDioError(err);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('RESPONSE[${response.data}]');
    return handler.next(response);
  }
}