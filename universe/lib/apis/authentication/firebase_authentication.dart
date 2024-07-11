import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:universe/apis/authentication/exceptions/authentication_exception.dart';
import 'package:universe/interfaces/iauthentication.dart';
import 'package:universe/models/user.dart' as usr;
import 'package:universe/models/user.dart';
import 'package:universe/repositories/data_repository.dart';

class FirebaseAuthentication implements IAuthentication {
  FirebaseAuthentication._();

  static final FirebaseAuthentication _instance = FirebaseAuthentication._();

  factory FirebaseAuthentication() => _instance;

  usr.User? user;

  @override
  Future<usr.User?> register(String firstName, String lastName, String email,
      String userName, bool gender, String password) async {
    bool userNameAvailable =
        await DataRepository().dataProvider.isUserNameAvailable(userName);

    if (!userNameAvailable) {
      throw UserNameUsedException(code: '');
    }

    firebase.UserCredential? auth;
    try {
      auth = await firebase.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await auth.user!.updatePhotoURL(
          'https://lh3.googleusercontent.com/d/1cUl6zMQACAVh1vK7jbxH18k4xW0qyKE9');
    } on firebase.FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          throw EmailInUseException(code: e.code);
        case "invalid-email":
          throw InvalidEmailException(code: e.code);
        case "weak-password":
          throw WeakPasswordException(code: e.code);
        default:
          throw AuthenticationException(code: e.code);
      }
    }

    // await auth.user!.sendEmailVerification();
    if (auth.user != null) {
      await DataRepository().createUser(
        usr.User(
          uid: auth.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          userName: userName,
          photoUrl:
              'https://lh3.googleusercontent.com/d/1cUl6zMQACAVh1vK7jbxH18k4xW0qyKE9',
          joinDate: auth.user!.metadata.creationTime!,
          gender: gender,
          verified: false,
        ),
      );
    }

    return await loadUser();
  }

  @override
  Future<usr.User?> signIn(String email, String password) async {
    try {
      await firebase.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on firebase.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          throw InvalidCredentialsException(code: e.code);
        default:
          throw AuthenticationException(code: e.code);
      }
    }

    return await loadUser();
  }

  @override
  Future signOut() async => await firebase.FirebaseAuth.instance.signOut();

  @override
  Future sendPasswordResetEmail(usr.User user) async =>
      await firebase.FirebaseAuth.instance
          .sendPasswordResetEmail(email: user.email);

  @override
  Future<usr.User?> loadUser() async {
    firebase.User? firebaseUser = firebase.FirebaseAuth.instance.currentUser;
    return firebaseUser != null
        ? user = await DataRepository().getUser(firebaseUser.uid)
        : null;
  }

  @override
  usr.User? getUser() => user;

  @override
  Future<usr.User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final account = await googleSignIn.signIn();

    if (account != null) {
      try {
        final GoogleSignInAuthentication auth = await account.authentication;
        final credential = firebase.GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );

        final firebase.UserCredential userCredential = await firebase
            .FirebaseAuth.instance
            .signInWithCredential(credential);

        if (userCredential.user != null) {
          DataRepository().createUser(
            usr.User(
              uid: userCredential.user!.uid,
              email: userCredential.user!.email!,
              firstName: userCredential.user!.displayName!,
              lastName: '',
              userName: userCredential.user!.displayName!.toLowerCase() +
                  userCredential.user!.uid,
              photoUrl:
                  'https://lh3.googleusercontent.com/d/1cUl6zMQACAVh1vK7jbxH18k4xW0qyKE9',
              joinDate: userCredential.user!.metadata.creationTime!,
              gender:
                  true, //this should be getting the actual gender from google in the future.
              verified: false,
            ),
          );
        }
      } on Exception catch (_) {
        throw AuthenticationException(code: '');
      }
    } else {
      throw OperationCanceledException(code: 'operation-canceled');
    }

    return await loadUser();
  }

  @override
  Future<bool> isUserValid(User user) async {
    try {
      await firebase.FirebaseAuth.instance.currentUser!.reload();
      return true;
    } catch (e) {
      return false;
    }
  }
}
