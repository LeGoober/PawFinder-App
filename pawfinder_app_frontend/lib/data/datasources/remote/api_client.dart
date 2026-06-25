import 'package:dio/dio.dart';
import 'package:pawfinder_app/core/constants/api_constants.dart';
import 'package:pawfinder_app/core/errors/exceptions.dart';
import 'package:pawfinder_app/services/auth_service.dart';

class ApiClient {
  late final Dio dio;
  final AuthService _authService;

  ApiClient({required AuthService authService}) : _authService = authService {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.addAll([
      _authInterceptor(),
      _errorInterceptor(),
    ]);
  }

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _authService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Attempt token refresh on 401
        if (error.response?.statusCode == 401) {
          try {
            final newToken = await _authService.refreshToken();
            if (newToken != null) {
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';
              final retryResponse = await dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            }
          } catch (_) {
            await _authService.deleteToken();
          }
        }
        handler.next(error);
      },
    );
  }

  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        final message = _mapErrorToMessage(error);
        handler.next(
          DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: error.error,
            message: message,
          ),
        );
      },
    );
  }

  String _mapErrorToMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'Unable to connect. Check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final body = error.response?.data;
        String detail = '';
        if (body is Map<String, dynamic>) {
          detail = body['message'] ?? body['error'] ?? '';
        }
        switch (statusCode) {
          case 400:
            return detail.isNotEmpty ? detail : 'Invalid request.';
          case 401:
            return 'Session expired. Please log in again.';
          case 403:
            return 'You do not have permission for this action.';
          case 404:
            return 'The requested resource was not found.';
          case 409:
            return detail.isNotEmpty ? detail : 'This resource already exists.';
          case 422:
            return detail.isNotEmpty ? detail : 'Validation failed.';
          case 429:
            return 'Too many requests. Please slow down.';
          case 500:
          case 502:
          case 503:
            return 'Server error. Please try again later.';
          default:
            return detail.isNotEmpty ? detail : 'Something went wrong.';
        }
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Convenience: GET request that returns decoded body or throws [ServerException].
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Request failed');
    }
  }

  /// Convenience: POST request.
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Request failed');
    }
  }

  /// Convenience: PUT request.
  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Request failed');
    }
  }

  /// Convenience: DELETE request.
  Future<dynamic> delete(String path) async {
    try {
      final response = await dio.delete(path);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Request failed');
    }
  }

  /// Convenience: multipart upload.
  Future<dynamic> upload(
    String path, {
    required String filePath,
    String fileField = 'file',
    Map<String, dynamic>? extraFields,
  }) async {
    try {
      final formData = FormData.fromMap({
        fileField: await MultipartFile.fromFile(filePath),
        if (extraFields != null) ...extraFields,
      });
      final response = await dio.post(path, data: formData);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Upload failed');
    }
  }
}
