import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/firebase_options.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';

enum StartupStates {
  loading,
  loaded,
  error,
}

class StartupCompleted {}

class StartupBloc extends Bloc<Object, Object> {
  StartupBloc() : super(0) {
    on<StartupCompleted>((event, emit) {
      if (AuthenticationRepository().authenticationService.getUser() == null) {
        RouteGenerator.mainNavigatorkey.currentState!
            .pushReplacementNamed(RouteGenerator.loginPage);
      } else {
        RouteGenerator.mainNavigatorkey.currentState!
            .pushReplacementNamed(RouteGenerator.homePage);
      }
    });
    initializeApp();
  }

  Future initializeApp() async {
    late final Future<FirebaseApp> initialization;
    initialization =
        Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await initialization;
    // await FirebasePushManager().init();
    await AuthenticationRepository().authenticationService.loadUser();
    add(StartupCompleted());
  }
}
