import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:universe/apis/authentication/token_manager.dart';
import 'package:universe/models/config.dart';

enum NotificationsStates { initial, loading, loaded, error }

class NotificationsState {
  final NotificationsStates state;
  final String notification;

  NotificationsState({required this.state, this.notification = ''});
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
  HubConnection? hubConnection;

  NotificationsBloc()
      : super(NotificationsState(state: NotificationsStates.initial)) {
    on<NotificationReceived>((event, emit) {
      emit(NotificationsState(
          state: NotificationsStates.loaded, notification: event.message));
    });

    on<InitializeNotifications>((event, emit) async {
      emit(NotificationsState(state: NotificationsStates.loading));
      await initializeNotifications();
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
