import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mqtt/core/api/api_client.dart';
import 'package:manager_mqtt/core/api/dio_interceptor.dart';
import 'package:manager_mqtt/core/http_request/data_device_request_http.dart';
import 'package:manager_mqtt/core/http_request/device_request_http.dart';

abstract class InjectionData {
  static Dio dio = Dio(BaseOptions(baseUrl: "http://35.192.218.203:5000/api/"));

  static void  initialize() {
    ApiClient apiClient = ApiClient(dio: dio);

    dio.interceptors.addAll([
      ErrorInterceptor(),
      LoggingInterceptor()
    ]);

    final deviceRequestHttp = DeviceRequestHttp(apiClient: apiClient);
    final dataDeviceRequestHttp = DataDeviceRequestHttp(apiClient: apiClient);

    GetIt.instance.registerSingleton<DeviceRequestHttp>(deviceRequestHttp);
    GetIt.instance.registerSingleton<DataDeviceRequestHttp>(dataDeviceRequestHttp);
  }

}
