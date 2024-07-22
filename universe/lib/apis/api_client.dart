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

  Future<Response<T>> get<T>(
      String path, dynamic data, Map<String, dynamic> queryParams) async {
    return _dio.get<T>(path);
  }

  Future<Response<T>> post<T>(
      String path, dynamic data, Map<String, dynamic> queryParams) async {
    return _dio.post<T>(path, data: data);
  }

  Future<Response<T>> put<T>(
      String path, dynamic data, Map<String, dynamic> queryParams) async {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(
      String path, dynamic data, Map<String, dynamic> queryParams) async {
    return _dio.delete<T>(path);
  }
}
