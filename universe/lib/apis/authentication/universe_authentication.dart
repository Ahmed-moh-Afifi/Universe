import 'package:dio/dio.dart';
import 'package:universe/interfaces/iauthentication.dart';
import 'package:universe/models/user.dart';

class UniverseAuthentication implements IAuthentication {
  final dioClient = Dio();

  UniverseAuthentication._() {
    dioClient.options.baseUrl = 'https://localhost:5149/auth';
  }

  static final UniverseAuthentication _instance = UniverseAuthentication._();

  factory UniverseAuthentication() => _instance;

  @override
  Future<User?> signIn(String username, String password) async {
    var response = await dioClient.post<User>('/login', data: {
      'email': username,
      'password': password,
    });
    return response.data;
  }

  @override
  Future<User?> register(String email, String password) async {
    var response = await dioClient.post<User>('/register', data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }
}
