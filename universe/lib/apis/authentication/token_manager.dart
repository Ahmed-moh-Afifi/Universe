import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universe/models/tokens_model.dart';

class TokenManager {
  TokenManager._privateConstructor();
  static final TokenManager _instance = TokenManager._privateConstructor();
  factory TokenManager() => _instance;

  TokensModel? _tokensModel;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://localhost:5149/auth',
  ));

  Future<void> readSavedTokens() async {
    AndroidOptions options = const AndroidOptions(
      encryptedSharedPreferences: true,
    );

    final storage = FlutterSecureStorage(aOptions: options);
    var tokens = await storage.read(key: "tokens-model");

    if (tokens != null) {
      Map<String, String> decodedTokensJson = jsonDecode(tokens);
      _tokensModel = TokensModel.fromJson(decodedTokensJson);
    }
  }

  Future<void> saveTokens(TokensModel tokensModel) async {
    AndroidOptions options = const AndroidOptions(
      encryptedSharedPreferences: true,
    );

    final storage = FlutterSecureStorage(aOptions: options);
    await storage.write(
      key: "tokens-model",
      value: jsonEncode(tokensModel.toJson()),
    );
  }

  Future<void> deleteTokens() async {
    AndroidOptions options = const AndroidOptions(
      encryptedSharedPreferences: true,
    );

    final storage = FlutterSecureStorage(aOptions: options);
    await storage.delete(key: "tokens-model");
  }

  Future<bool> hasValidToken() async {
    if (_tokensModel == null) {
      await readSavedTokens();
    }

    if (_tokensModel == null) {
      return false;
    }

    return _tokensModel!.getAccessTokenExpiration().isAfter(
          DateTime.now().subtract(
            const Duration(minutes: 5),
          ),
        );
  }

  Future<bool> refreshTokens() async {
    var response = await _dio.post<TokensModel>(
      '/refresh',
      data: {
        'token-model': _tokensModel,
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      _tokensModel = response.data;
      await saveTokens(_tokensModel!);

      return true;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      await deleteTokens();
    }

    return false;
  }
}
