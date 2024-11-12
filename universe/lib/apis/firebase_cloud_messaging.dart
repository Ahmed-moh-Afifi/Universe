import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCM {
  FCM._();

  late String fcmToken;

  static final _instance = FCM._();
  factory FCM() => _instance;

  Future<String> init() async {
    // final notificationSettings =
    await FirebaseMessaging.instance.requestPermission();

    if (!kIsWeb) {
      if (Platform.isIOS || Platform.isMacOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          //throw an exception.
        }
      }
    }

    fcmToken = (await FirebaseMessaging.instance
        .getToken())!; // vapidKey is required for this to run on the web.
    // print('fcmToken: $fcmToken');
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (event) {
        fcmToken = event;
        // print('fcmToken: $fcmToken');
      },
    ).onError(
      (error) {
        //throw an exception.
      },
    );
    return fcmToken;
  }
}
