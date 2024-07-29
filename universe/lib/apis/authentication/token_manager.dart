import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universe/apis/api_client.dart';
import 'package:universe/models/config.dart';
import 'package:universe/models/notification_token.dart';
import 'package:universe/models/tokens_model.dart';

class TokenManager {
  TokenManager._privateConstructor();
  static final TokenManager _instance = TokenManager._privateConstructor();
  factory TokenManager() => _instance;

  TokensModel? _tokensModel;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: '${Config().api}/Auth',
  ));

  Future<TokensModel?> readSavedTokens() async {
    log("Reading saved tokens", name: "TokenManager");
    AndroidOptions options = const AndroidOptions(
      encryptedSharedPreferences: true,
    );

    final storage = FlutterSecureStorage(aOptions: options);
    var tokens = await storage.read(key: "tokens-model");

    if (tokens != null) {
      Map<String, dynamic> decodedTokensJson = jsonDecode(tokens);
      _tokensModel = TokensModel.fromJson(decodedTokensJson);
    }

    return _tokensModel;
  }

  Future<void> saveTokens(TokensModel tokensModel) async {
    log("Saving tokens", name: "TokenManager");
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
    log("Deleting tokens", name: "TokenManager");
    AndroidOptions options = const AndroidOptions(
      encryptedSharedPreferences: true,
    );

    final storage = FlutterSecureStorage(aOptions: options);
    await storage.delete(key: "tokens-model");
  }

  Future<bool> hasValidToken() async {
    log("Checking for valid token", name: "TokenManager");
    if (_tokensModel == null) {
      await readSavedTokens();
    }

    if (_tokensModel == null) {
      return false;
    }

    return !(_tokensModel!.isAccessTokenExpired());
  }

  Future<TokensModel?> refreshTokens() async {
    log("Refreshing tokens", name: "TokenManager");
    var response = await _dio.post<Map<String, dynamic>>(
      '/Refresh',
      data: _tokensModel!.toJson(),
    );

    if (response.statusCode == HttpStatus.ok) {
      _tokensModel = TokensModel.fromJson(response.data!);
      await saveTokens(_tokensModel!);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      await deleteTokens();
      _tokensModel = null;
    }

    return _tokensModel;
  }

  Future saveNotificationToken(NotificationToken token) async {
    log("Saving notification token", name: "TokenManager");
    log(token.toJson().toString(), name: "TokenManager");
    // await _dio.post('/NotificationToken', data: token.toJson());
    ApiClient apiClient = ApiClient("/Auth");
    await apiClient.post('/NotificationToken', token.toJson(), {});
  }
}
