import 'package:dio/dio.dart';
import 'package:universe/apis/authentication/token_manager.dart';

class ApiClient {
  final TokenManager _tokenManager = TokenManager();
  final Dio _dio;

  ApiClient(String path)
      : _dio = Dio(BaseOptions(baseUrl: 'https://localhost:5149/$path')) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            var tokens = await _tokenManager.readSavedTokens();
            if (tokens != null) {
              if (!tokens.isAccessTokenExpired()) {
                options.headers['Authorization'] =
                    'Bearer ${tokens.accessToken}';
                return handler.next(options);
              } else {
                var newTokens = await _tokenManager.refreshTokens();
                if (newTokens != null) {
                  options.headers['Authorization'] =
                      'Bearer ${newTokens.accessToken}';
                  return handler.next(options);
                }
              }
            }

            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No token found',
              ),
            );
          } catch (e) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No token found',
              ),
            );
          }
        },
      ),
    );
  }

  Future<Response> get(String path) async {
    return _dio.get(path);
  }

  Future<Response> post(String path, dynamic data) async {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, dynamic data) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }
}
