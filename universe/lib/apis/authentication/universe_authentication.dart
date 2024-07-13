import 'package:dio/dio.dart';
import 'package:universe/interfaces/iauthentication.dart';
import 'package:universe/models/register_model.dart';
import 'package:universe/models/user.dart';

class UniverseAuthentication implements IAuthentication {
  final dioClient = Dio();

  UniverseAuthentication._() {
    dioClient.options.baseUrl = 'https://localhost:5149/auth';
  }

  static final UniverseAuthentication _instance = UniverseAuthentication._();

  factory UniverseAuthentication() => _instance;

  @override
  Future<User?> register(RegisterModel registerModel) async {
    var response = await dioClient.post<User>('/register', data: registerModel);
    return response.data;
  }

  @override
  Future<User?> signIn(String username, String password) async {
    var response = await dioClient.post<User>('/login', data: {
      'email': username,
      'password': password,
    });
    return response.data;
  }

  @override
  Future<User?> signInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future sendPasswordResetEmail(User user) {
    throw UnimplementedError();
  }

  @override
  Future signOut() {
    throw UnimplementedError();
  }

  @override
  Future<User?> loadUser() async {
    throw UnimplementedError();
  }

  @override
  User? currentUser() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isUserValid(User user) {
    throw UnimplementedError();
  }
}
