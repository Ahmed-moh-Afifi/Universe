import 'package:universe/models/login_model.dart';
import 'package:universe/models/register_model.dart';
import 'package:universe/models/tokens_model.dart';

abstract class IAuthenticationApi {
  Future<bool> register(RegisterModel registerModel);

  Future<TokensModel?> login(LoginModel loginModel);

  Future signOut();
}
