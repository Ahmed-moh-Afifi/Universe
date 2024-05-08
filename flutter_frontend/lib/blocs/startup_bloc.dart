import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/firebase_cloud_messaging.dart';
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
    await AuthenticationRepository().authenticationService.loadUser();
    if (!kIsWeb) {
      // until adding the vapid key for web support.
      await FCM().init();
    }
    add(StartupCompleted());
  }
}
