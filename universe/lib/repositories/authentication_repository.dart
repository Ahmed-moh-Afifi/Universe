import 'package:universe/apis/authentication/universe_authentication.dart';
import 'package:universe/apis/authentication/universe_authentication_api.dart';
import 'package:universe/interfaces/iauthentication.dart';
import 'package:universe/repositories/users_repository.dart';

class AuthenticationRepository {
  final IAuthentication authenticationService;

  const AuthenticationRepository._(this.authenticationService);

  static final _instance = AuthenticationRepository._(
      UniverseAuthentication(UniverseAuthenticationApi(), UsersRepository()));

  factory AuthenticationRepository() => _instance;
}
