import 'package:universe/apis/authentication/firebase_authentication.dart';
import 'package:universe/interfaces/iauthentication.dart';

class AuthenticationRepository {
  final IAuthentication authenticationService;

  const AuthenticationRepository._(this.authenticationService);

  static final _instance = AuthenticationRepository._(FirebaseAuthentication());

  factory AuthenticationRepository() => _instance;
}
