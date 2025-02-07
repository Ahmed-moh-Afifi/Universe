import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/hubs/messaging_hub.dart';
import 'package:universe/interfaces/ichats_repository.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/models/data/message.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/data/user_status.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';

enum ChatStates {
  initial,
  loading,
  loaded,
  newMessage,
  error,
}

class ChatState {
  final ChatStates state;
  final List<Message>? messages;
  final bool? isTyping;
  final bool? isOnline;
  final DateTime? lastOnline;
  final String? error;

  ChatState({
    required this.state,
    this.messages,
    this.isTyping,
    this.isOnline,
    this.lastOnline,
    this.error,
  });

  factory ChatState.initial({bool online = false}) {
    return ChatState(
      state: ChatStates.initial,
      messages: [],
      isTyping: false,
      isOnline: online,
      error: '',
    );
  }

  factory ChatState.loading(ChatState oldState) {
    return ChatState(
      state: ChatStates.loading,
      messages: oldState.messages,
      isTyping: oldState.isTyping,
      isOnline: oldState.isOnline,
      lastOnline: oldState.lastOnline,
      error: '',
    );
  }

  factory ChatState.loaded(
    List<Message> messages,
    bool isTyping,
    bool isOnline,
    DateTime lastOnline,
  ) {
    return ChatState(
      state: ChatStates.loaded,
      messages: messages,
      isTyping: isTyping,
      isOnline: isOnline,
      lastOnline: lastOnline,
      error: '',
    );
  }

  factory ChatState.newMessage(
    List<Message> messages,
    bool isTyping,
    bool isOnline,
    DateTime lastOnline,
  ) {
    return ChatState(
      state: ChatStates.newMessage,
      messages: messages,
      isTyping: isTyping,
      isOnline: isOnline,
      lastOnline: lastOnline,
      error: '',
    );
  }

  factory ChatState.error(String error, ChatState oldState) {
    return ChatState(
      state: ChatStates.error,
      messages: oldState.messages,
      isTyping: oldState.isTyping,
      isOnline: oldState.isOnline,
      lastOnline: oldState.lastOnline,
      error: error,
    );
  }
}

class InitChatEvent {}

class NewMessageEvent {
  final Message message;

  const NewMessageEvent(this.message);
}

class StatusUpdatedEvent {
  final bool isTyping;
  final bool isOnline;
  final DateTime lastOnline;

  const StatusUpdatedEvent({
    required this.isTyping,
    required this.isOnline,
    required this.lastOnline,
  });
}

class UpdateStatusEvent {
  final bool typing;

  const UpdateStatusEvent({required this.typing});
}

class SendMessage {
  final Message message;
  final String userId;

  SendMessage(this.message, this.userId);
}

class TextChangedEvent {}

class ChatBloc extends Bloc<Object, ChatState> {
  final Chat chat;
  final User user;
  final IChatsRepository _chatsRepository;
  late void Function(List<Object?>?) onHubReceive;
  late void Function(List<Object?>?) onStatusChanged;
  DateTime? lastTyped;

  ChatBloc(this.chat, this.user, this._chatsRepository)
      : super(ChatState.initial(online: user.onlineSessions > 0)) {
    RouteGenerator.openedChat = chat;

    on<InitChatEvent>(
      (event, emit) async {
        emit(ChatState.loading(state));
        emit(await initialize());
      },
    );

    on<NewMessageEvent>(
      (event, emit) {
        log("New message received: ${event.message.toJson()}",
            name: "ChatBloc");
        emit(
          ChatState.newMessage(
            [
              event.message,
              ...?state.messages,
            ],
            state.isTyping ?? false,
            state.isOnline ?? false,
            state.lastOnline ?? DateTime.now(),
          ),
        );
      },
    );

    on<StatusUpdatedEvent>(
      (event, emit) {
        emit(
          ChatState.loaded(
            state.messages ?? [],
            event.isTyping,
            event.isOnline,
            event.lastOnline,
          ),
        );
      },
    );

    on<SendMessage>(
      (event, emit) {
        log('Sending message: ${event.message}', name: 'NotificationsBloc');
        MessagingHub().invoke('SendToUserAsync', [event.userId, event.message]);
        add(NewMessageEvent(event.message));
      },
    );

    on<UpdateStatusEvent>(
      (event, emit) {
        MessagingHub().invoke('SendUserStatus', [
          UserStatus(
            status: event.typing ? 'Typing' : 'Online',
            lastOnline: DateTime.now(),
          )
        ]);
      },
    );

    on<TextChangedEvent>(
      (event, emit) {
        if (lastTyped == null ||
            DateTime.now().difference(lastTyped!).inSeconds >= 2) {
          // send typing.
          log('Sending typing...', name: 'ChatsBloc');
          add(UpdateStatusEvent(typing: true));
        }
        lastTyped = DateTime.now();
        Future.delayed(
          Duration(seconds: 2),
          () {
            if (DateTime.now().difference(lastTyped!).inSeconds >= 2) {
              // send not typing.
              log('Sending online...', name: 'ChatsBloc');
              add(UpdateStatusEvent(typing: false));
            }
          },
        );
      },
    );

    add(InitChatEvent());
  }

  Future<ChatState> initialize() async {
    log("Initializing ChatBloc", name: "ChatBloc");
    var cht = await _chatsRepository.getChat(
        AuthenticationRepository().authenticationService.currentUser()!.id,
        chat.id);

    MessagingHub().invoke("SubscribeToUsersStatus", [
      [user.id]
    ]);
    onHubReceive = (arguments) {
      log("Message received from hub: ${arguments?[0]}", name: "ChatBloc");
      add(
        NewMessageEvent(
          Message.fromJson(arguments?[0] as Map<String, dynamic>),
        ),
      );
    };
    onStatusChanged = (arguments) {
      log('User status updated: ${arguments?[0]}', name: "ChatBloc");
      var userStatus =
          UserStatus.fromJson(arguments?[1] as Map<String, dynamic>);
      add(
        StatusUpdatedEvent(
          isTyping: userStatus.status == "Typing",
          isOnline: userStatus.status != "Offline",
          lastOnline: userStatus.lastOnline,
        ),
      );
    };
    MessagingHub().on("MessageReceived", onHubReceive);
    MessagingHub().on("UpdateUserStatus", onStatusChanged);
    log("ChatBloc initialized", name: "ChatBloc");

    return ChatState.loaded(
      cht.messages.reversed.toList(),
      false,
      state.isOnline!,
      DateTime.now(),
    );
  }

  @override
  Future<void> close() async {
    MessagingHub().off("MessageReceived", onHubReceive);
    MessagingHub().off("UpdateUserStatus", onStatusChanged);
    RouteGenerator.openedChat = null;
    await super.close();
  }
}
