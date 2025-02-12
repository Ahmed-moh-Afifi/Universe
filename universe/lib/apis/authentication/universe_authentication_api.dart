import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:universe/interfaces/iauthentication_api.dart';
import 'package:universe/models/config.dart';
import 'package:universe/models/authentication/login_model.dart';
import 'package:universe/models/authentication/register_model.dart';
import 'package:universe/models/authentication/tokens_model.dart';

class UniverseAuthenticationApi implements IAuthenticationApi {
  final dioClient = Dio();

  UniverseAuthenticationApi._() {
    (dioClient.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      var client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dioClient.options.baseUrl = '${Config().api}/Auth';
  }

  static final UniverseAuthenticationApi _instance =
      UniverseAuthenticationApi._();

  factory UniverseAuthenticationApi() => _instance;

  @override
  Future<bool> register(RegisterModel registerModel) async {
    log('Registering user ${registerModel.username}...',
        name: 'UniverseAuthenticationApi');
    var response =
        await dioClient.post('/Register', data: registerModel.toJson());

    if (response.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  @override
  Future<TokensModel?> login(LoginModel loginModel) async {
    log('Logging in user ${loginModel.username}...',
        name: 'UniverseAuthenticationApi');
    var response = await dioClient.post<Map<String, dynamic>>('/Login',
        data: loginModel.toJson());

    if (response.statusCode == 200) {
      return TokensModel.fromJson(response.data!);
    }

    return null;
  }

  @override
  Future signOut() {
    log('Signing out...', name: 'UniverseAuthenticationApi');
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
