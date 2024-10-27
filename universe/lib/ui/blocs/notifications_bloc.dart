import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:universe/apis/authentication/token_manager.dart';
import 'package:universe/models/config.dart';

enum NotificationsStates {
  initial,
  connecting,
  connected,
  disconnected,
  notificationReceived,
  error
}

class NotificationsState {
  final NotificationsStates state;
  final String notification;
  final String error;

  NotificationsState({
    required this.state,
    this.notification = '',
    this.error = '',
  });

  factory NotificationsState.initial() {
    return NotificationsState(
      state: NotificationsStates.initial,
    );
  }

  factory NotificationsState.connecting() {
    return NotificationsState(
      state: NotificationsStates.connecting,
    );
  }

  factory NotificationsState.connected() {
    return NotificationsState(
      state: NotificationsStates.connected,
    );
  }

  factory NotificationsState.disconnected() {
    return NotificationsState(
      state: NotificationsStates.disconnected,
    );
  }

  factory NotificationsState.notificationReceived(String notification) {
    return NotificationsState(
      state: NotificationsStates.notificationReceived,
      notification: notification,
    );
  }

  factory NotificationsState.error(String error) {
    return NotificationsState(
      state: NotificationsStates.error,
      error: error,
    );
  }
}

class NotificationReceived {
  final String message;

  NotificationReceived({required this.message});
}

class SendMessage {
  final String message;
  final String userId;

  SendMessage(this.message, this.userId);
}

class InitializeNotifications {}

class NotificationsBloc extends Bloc<Object, NotificationsState> {
  static final NotificationsBloc _singleton = NotificationsBloc._internal();

  factory NotificationsBloc() {
    return _singleton;
  }

  HubConnection? hubConnection;

  NotificationsBloc._internal() : super(NotificationsState.initial()) {
    on<NotificationReceived>((event, emit) {
      emit(NotificationsState.notificationReceived(event.message));
    });

    on<InitializeNotifications>((event, emit) async {
      emit(NotificationsState.connecting());
      await initializeNotifications().onError((error, stackTrace) {
        emit(NotificationsState.error(error.toString()));
      });
      emit(NotificationsState.connected());
    });

    on<SendMessage>(
      (event, emit) {
        log('Sending message: ${event.message}', name: 'NotificationsBloc');
        hubConnection!
            .invoke('SendToUserAsync', args: [event.userId, event.message]);
      },
    );

    add(InitializeNotifications());
  }

  Future<void> initializeNotifications() async {
    log('Initializing notifications', name: 'NotificationsBloc');
    var serverUrl = '${Config().api}/MessagingHub';
    log('Server URL: $serverUrl', name: 'NotificationsBloc');

    hubConnection = HubConnectionBuilder()
        .withUrl(serverUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () => Future.microtask(
                () async {
                  return (await TokenManager().getValidTokens()).accessToken;
                },
              ),
            ))
        .build();

    await hubConnection!.start();
    log('Connection started', name: 'NotificationsBloc');

    hubConnection!.on('MessageReceived', (message) {
      log('MessageReceived: ${message![0]}', name: 'NotificationsBloc');

      var msg = message[0] as Map<String, dynamic>;
      log('Message body: ${msg['body']}', name: 'NotificationsBloc');

      add(NotificationReceived(
        message: msg['body'],
      ));
    });
  }
}
