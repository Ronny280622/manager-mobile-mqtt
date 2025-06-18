import 'package:manager_mqtt/core/api/api_client.dart';
import 'package:manager_mqtt/core/api/api_response.dart';

class DataDeviceRequestHttp {
  final String baseUrl = "data";
  final ApiClient _apiClient;
  DataDeviceRequestHttp({required ApiClient apiClient }) : _apiClient = apiClient;

  Future<ApiResponse> getData({ required Map<String, dynamic> body }) async {
    String path = '$baseUrl/getfordevice';
    return _apiClient.request(path: path, method: "POST", body: body);
  }
}