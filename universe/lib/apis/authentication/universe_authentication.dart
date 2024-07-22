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
    var apiResponse = await _authenticationApi.register(registerModel);
    if (apiResponse) {
      return signIn(LoginModel(
          username: registerModel.username, password: registerModel.password));
    }

    return null;
  }

  @override
  Future<User?> signIn(LoginModel loginModel) async {
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
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future sendPasswordResetEmail(User user) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<User?> loadUser() async {
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
    return _currentUser;
  }

  @override
  Future<User?> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<bool> isUserValid(User user) {
    // TODO: implement isUserValid
    throw UnimplementedError();
  }
}
