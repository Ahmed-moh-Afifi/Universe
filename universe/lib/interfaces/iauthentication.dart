import 'package:universe/models/register_model.dart';
import 'package:universe/models/user.dart';

abstract class IAuthentication {
  Future<User?> register(RegisterModel registerModel);
  Future<User?> signIn(String email, String password);
  Future signOut();
  Future sendPasswordResetEmail(User user);
  Future<User?> loadUser();
  User? getUser();
  Future<User?> signInWithGoogle();
  Future<bool> isUserValid(User user);
}
