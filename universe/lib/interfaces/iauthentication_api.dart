import 'package:universe/models/authentication/login_model.dart';
import 'package:universe/models/authentication/register_model.dart';
import 'package:universe/models/authentication/tokens_model.dart';

abstract class IAuthenticationApi {
  Future<bool> register(RegisterModel registerModel);

  Future<TokensModel?> login(LoginModel loginModel);

  Future signOut();
}
