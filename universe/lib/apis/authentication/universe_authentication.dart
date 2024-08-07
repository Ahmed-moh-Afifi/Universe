import 'dart:developer';

import 'package:universe/apis/authentication/token_manager.dart';
import 'package:universe/interfaces/iauthentication.dart';
import 'package:universe/interfaces/iauthentication_api.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/login_model.dart';
import 'package:universe/models/register_model.dart';
import 'package:universe/models/user.dart';

class UniverseAuthentication implements IAuthentication {
  final IAuthenticationApi _authenticationApi;
  final IusersDataProvider _usersDataProvider;

  final TokenManager _tokenManager = TokenManager();

  User? _currentUser;

  UniverseAuthentication(this._authenticationApi, this._usersDataProvider);

  @override
  Future<User?> registerAndLogin(RegisterModel registerModel) async {
    log('Registering user ${registerModel.username}...',
        name: 'UniverseAuthentication');
    var apiResponse = await _authenticationApi.register(registerModel);
    if (apiResponse) {
      return signIn(LoginModel(
          username: registerModel.username, password: registerModel.password));
    }

    return null;
  }

  @override
  Future<User?> signIn(LoginModel loginModel) async {
    log('Logging in user ${loginModel.username}...',
        name: 'UniverseAuthentication');
    var tokens = await _authenticationApi.login(loginModel);
    if (tokens != null) {
      await _tokenManager.saveTokens(tokens);
      _currentUser =
          await _usersDataProvider.getUser(tokens.getIdFromAccessToken());
      return _currentUser;
    }

    return null;
  }

  @override
  Future signOut() {
    log('Signing out...', name: 'UniverseAuthentication');
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future sendPasswordResetEmail(User user) {
    log('Sending password reset email to ${user.userName}...',
        name: 'UniverseAuthentication');
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<User?> loadUser() async {
    log('Loading user...', name: 'UniverseAuthentication');
    var savedTokens = await _tokenManager.readSavedTokens();
    if (savedTokens == null) {
      return null;
    } else if (savedTokens.isAccessTokenExpired()) {
      var newTokens = await _tokenManager.refreshTokens();
      if (newTokens == null) {
        return null;
      }
    }

    _currentUser =
        await _usersDataProvider.getUser(savedTokens.getIdFromAccessToken());

    return _currentUser;
  }

  @override
  User? currentUser() {
    log('Getting current user...', name: 'UniverseAuthentication');
    return _currentUser;
  }

  @override
  Future<User?> signInWithGoogle() {
    log('Signing in with Google...', name: 'UniverseAuthentication');
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<bool> isUserValid(User user) {
    log('Checking if user is valid...', name: 'UniverseAuthentication');
    // TODO: implement isUserValid
    return Future.value(true);
  }
}
