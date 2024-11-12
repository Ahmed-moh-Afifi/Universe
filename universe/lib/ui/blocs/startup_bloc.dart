import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/authentication/token_manager.dart';
import 'package:universe/apis/firebase_cloud_messaging.dart';
import 'package:universe/models/config.dart';
import 'package:universe/models/authentication/notification_token.dart'
    as notification_token;
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/firebase_options.dart';

enum StartupEvent { initial, loggedIn, sessionExpired }

class StartupState {
  final StartupEvent event;

  StartupState(this.event);
}

class StartupCompleted {}

class StartupBloc extends Bloc<Object, StartupState> {
  StartupBloc() : super(StartupState(StartupEvent.initial)) {
    on<StartupCompleted>(
      (event, emit) async {
        if (AuthenticationRepository().authenticationService.currentUser() ==
            null) {
          RouteGenerator.mainNavigatorkey.currentState!
              .pushReplacementNamed(RouteGenerator.loginPage);
        } else {
          if (await AuthenticationRepository()
              .authenticationService
              .isUserValid(AuthenticationRepository()
                  .authenticationService
                  .currentUser()!)) {
            emit(StartupState(StartupEvent.loggedIn));
            RouteGenerator.mainNavigatorkey.currentState!
                .pushReplacementNamed(RouteGenerator.homePage);
          } else {
            AuthenticationRepository().authenticationService.signOut();
            emit(StartupState(StartupEvent.sessionExpired));
            RouteGenerator.mainNavigatorkey.currentState!
                .pushReplacementNamed(RouteGenerator.loginPage);
          }
        }
      },
    );

    initializeApp();
  }

  Future initializeApp() async {
    await Config.load();
    late final Future<FirebaseApp> initialization;
    initialization =
        Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await initialization;
    await AuthenticationRepository().authenticationService.loadUser();

    late notification_token.Platform platform;
    if (Platform.isAndroid) {
      platform = notification_token.Platform.android;
    } else if (Platform.isIOS) {
      platform = notification_token.Platform.ios;
    } else if (kIsWeb) {
      platform = notification_token.Platform.web;
    }

    if (!kIsWeb) {
      // until adding the vapid key for web support.
      String fcmToken = await FCM().init();

      if (AuthenticationRepository().authenticationService.currentUser() !=
          null) {
        notification_token.NotificationToken notificationToken =
            notification_token.NotificationToken(
          token: fcmToken,
          userId: AuthenticationRepository()
              .authenticationService
              .currentUser()!
              .id,
          platform: platform,
        );

        await TokenManager().saveNotificationToken(notificationToken);
      }
    }

    add(StartupCompleted());
  }
}
