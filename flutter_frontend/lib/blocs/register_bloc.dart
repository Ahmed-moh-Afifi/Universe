import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/authentication/exceptions/authentication_exception.dart';
import 'package:universe/models/user.dart';
import 'package:universe/repositories/authentication_repository.dart';

enum RegisterStates { startup, loading, failed, success }

class RegisterState {
  RegisterStates state;
  String? error;
  User? userCredential;

  RegisterState({required this.state, this.error, this.userCredential});
}

class RegisterEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterEvent(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.confirmPassword});
}

class RegisterBloc extends Bloc<Object, RegisterState> {
  RegisterBloc() : super(RegisterState(state: RegisterStates.startup)) {
    on<RegisterEvent>(
      (event, emit) async {
        if (event.firstName.isNotEmpty &&
            event.lastName.isNotEmpty &&
            event.email.isNotEmpty &&
            event.password.isNotEmpty &&
            event.confirmPassword.isNotEmpty &&
            event.password == event.confirmPassword) {
          try {
            emit(RegisterState(state: RegisterStates.loading));
            final user = await AuthenticationRepository()
                .authenticationService
                .register(event.firstName, event.lastName, event.email,
                    event.password);
            // await user.user
            //     ?.updateDisplayName("${event.firstName} ${event.lastName}");
            emit(
              RegisterState(
                  state: RegisterStates.success, userCredential: user),
            );
          } on EmailInUseException catch (_) {
            emit(
              RegisterState(
                state: RegisterStates.failed,
                error: "Email already in use",
              ),
            );
          } on InvalidEmailException catch (_) {
            emit(
              RegisterState(
                state: RegisterStates.failed,
                error: "Invalid email",
              ),
            );
          } on WeakPasswordException catch (_) {
            emit(
              RegisterState(
                state: RegisterStates.failed,
                error: "Weak password",
              ),
            );
          } on AuthenticationException catch (e) {
            emit(
              RegisterState(
                state: RegisterStates.failed,
                error: "something's gone wrong :(\n${e.code}",
              ),
            );
          } catch (e) {
            emit(
              RegisterState(
                state: RegisterStates.failed,
                error: "something's gone wrong :(",
              ),
            );
          }
        } else {
          emit(
            RegisterState(
              state: RegisterStates.failed,
              error: "invalid or no input",
            ),
          );
        }
      },
    );
  }
}
