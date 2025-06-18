class ApiResponse {
  final dynamic data;
  final HttpError? error;
  final bool ok;

  ApiResponse(this.data, this.error, this.ok);

  static ApiResponse success(dynamic data) => ApiResponse(data, null, true);

  static ApiResponse fail(
      {required int status,
        required String error,
        required dynamic results}) =>
      ApiResponse(null,
          HttpError(status: status, error: error, results: results), false);
}

class HttpError {
  final int status;
  final String error;
  final dynamic results;
  HttpError({required this.status, required this.error, required this.results});
}