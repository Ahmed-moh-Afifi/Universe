import 'package:universe/apis/authentication/universe_authentication.dart';
import 'package:universe/apis/authentication/universe_authentication_api.dart';
import 'package:universe/apis/users_data_provider.dart';
import 'package:universe/interfaces/iauthentication.dart';

class AuthenticationRepository {
  final IAuthentication authenticationService;

  const AuthenticationRepository._(this.authenticationService);

  static final _instance = AuthenticationRepository._(
      UniverseAuthentication(UniverseAuthenticationApi(), UsersDataProvider()));

  factory AuthenticationRepository() => _instance;
}
