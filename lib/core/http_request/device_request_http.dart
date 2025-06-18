import 'package:manager_mqtt/core/api/api_client.dart';
import 'package:manager_mqtt/core/api/api_response.dart';

class DeviceRequestHttp {
  final String baseUrl = "device";
  final ApiClient _apiClient;
  DeviceRequestHttp({required ApiClient apiClient }) : _apiClient = apiClient;

  Future<ApiResponse> getAll(
      { required int index,
        required int pageSize,
      }) async {
    String path = '$baseUrl/all?offset=$index&limit=$pageSize';
    return _apiClient.request(path: path, method: "GET");
  }

  Future<ApiResponse> store({ required Map<String, dynamic> body }) async {
    String path = '$baseUrl/store';
    return _apiClient.request(path: path, method: "POST", body: body);
  }

  Future<ApiResponse> update({ required Map<String, dynamic> body }) async {
    String path = '$baseUrl/update';
    return _apiClient.request(path: path, method: "PUT", body: body);
  }

  Future<ApiResponse> getForId({ required id }) async {
    String path = '$baseUrl/show/$id';
    return _apiClient.request(path: path, method: "GET");
  }

  Future<ApiResponse> delete({ required id }) async {
    String path = '$baseUrl/delete/$id';
    return _apiClient.request(path: path, method: "DELETE");
  }

  Future<ApiResponse> sendData({ required id }) async {
    String path = '$baseUrl/sendData/$id';
    return _apiClient.request(path: path, method: "GET");
  }
}