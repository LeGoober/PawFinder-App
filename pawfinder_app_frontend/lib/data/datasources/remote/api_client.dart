import 'package:dio/dio.dart';
import 'package:pawfinder_app/core/constants/api_constants.dart';
import 'package:pawfinder_app/services/auth_service.dart';

class ApiClient {
  late final Dio dio;
  final AuthService _authService;
  String? _refreshToken;

  ApiClient({required AuthService authService}) : _authService = authService {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _authService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));
  }
}
