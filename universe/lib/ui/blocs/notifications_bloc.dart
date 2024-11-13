import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/hubs/messaging_hub.dart';
import 'package:universe/models/data/message.dart';
import 'package:universe/route_generator.dart';

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
  final Message? notification;
  final String error;

  NotificationsState({
    required this.state,
    this.notification,
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

  factory NotificationsState.notificationReceived(Message notification) {
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
  final Message message;

  NotificationReceived({required this.message});
}

class InitializeNotifications {}

class NotificationsBloc extends Bloc<Object, NotificationsState> {
  NotificationsBloc() : super(NotificationsState.initial()) {
    on<NotificationReceived>((event, emit) {
      if (RouteGenerator.openedChat == null ||
          RouteGenerator.openedChat!.id != event.message.chatId) {
        emit(NotificationsState.notificationReceived(event.message));
      }
    });

    on<InitializeNotifications>((event, emit) async {
      emit(NotificationsState.connecting());
      await initializeNotifications().onError((error, stackTrace) {
        emit(NotificationsState.error(error.toString()));
      });
      emit(NotificationsState.connected());
    });

    add(InitializeNotifications());
  }

  Future<void> initializeNotifications() async {
    log('Initializing notifications', name: 'NotificationsBloc');
    MessagingHub messagingHub = MessagingHub();
    await messagingHub.start();
    log('Connection started', name: 'NotificationsBloc');

    messagingHub.on('MessageReceived', (message) {
      log('MessageReceived: ${message![0]}', name: 'NotificationsBloc');

      var msg = message[0] as Map<String, dynamic>;
      log('Message body: ${msg['body']}', name: 'NotificationsBloc');
      var msgObj = Message.fromJson(msg);

      add(NotificationReceived(
        message: msgObj,
      ));
    });
  }
}
