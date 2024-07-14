import 'dart:io';

import 'package:dio/dio.dart';
import 'package:universe/apis/authentication/token_manager.dart';
import 'package:universe/models/register_model.dart';
import 'package:universe/models/tokens_model.dart';

class UniverseAuthentication {
  final dioClient = Dio();
  final tokenManager = TokenManager();

  UniverseAuthentication._() {
    dioClient.options.baseUrl = 'https://localhost:5149/auth';
  }

  static final UniverseAuthentication _instance = UniverseAuthentication._();

  factory UniverseAuthentication() => _instance;

  Future<bool> register(RegisterModel registerModel) async {
    var response = await dioClient.post('/register', data: registerModel);

    if (response.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  Future<TokensModel?> login(String username, String password) async {
    var response = await dioClient.post<TokensModel>('/login', data: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      tokenManager.saveTokens(response.data!);
      return response.data;
    }

    return response.data;
  }

  Future signOut() {
    throw UnimplementedError();
  }
}
