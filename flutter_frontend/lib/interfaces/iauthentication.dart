import 'package:universe/models/user.dart';

abstract class IAuthentication {
  Future<User?> register(
      String firstName, String lastName, String email, String password);
  Future<User?> signIn(String email, String password);
  Future signOut();
  Future sendPasswordResetEmail(User user);
  Future<User?> loadUser();
  User? getUser();
  Future<User?> signInWithGoogle();
}