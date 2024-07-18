import 'dart:io';

import 'package:dio/dio.dart';
import 'package:universe/interfaces/iauthentication_api.dart';
import 'package:universe/models/login_model.dart';
import 'package:universe/models/register_model.dart';
import 'package:universe/models/tokens_model.dart';

class UniverseAuthenticationApi implements IAuthenticationApi {
  final dioClient = Dio();

  UniverseAuthenticationApi._() {
    dioClient.options.baseUrl = 'https://localhost:5149/auth';
  }

  static final UniverseAuthenticationApi _instance =
      UniverseAuthenticationApi._();

  factory UniverseAuthenticationApi() => _instance;

  @override
  Future<bool> register(RegisterModel registerModel) async {
    var response = await dioClient.post('/register', data: registerModel);

    if (response.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  @override
  Future<TokensModel?> login(LoginModel loginModel) async {
    var response =
        await dioClient.post<TokensModel>('/login', data: loginModel);

    if (response.statusCode == 200) {
      return response.data;
    }

    return response.data;
  }

  @override
  Future signOut() {
    throw UnimplementedError();
  }
}
