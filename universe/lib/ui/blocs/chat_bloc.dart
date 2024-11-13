import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/hubs/messaging_hub.dart';
import 'package:universe/interfaces/ichats_repository.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/models/data/message.dart';
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

  factory ChatState.initial() {
    return ChatState(
      state: ChatStates.initial,
      messages: [],
      isTyping: false,
      isOnline: false,
      lastOnline: DateTime.now(),
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

class SendMessage {
  final Message message;
  final String userId;

  SendMessage(this.message, this.userId);
}

class ChatBloc extends Bloc<Object, ChatState> {
  final Chat chat;
  final IChatsRepository _chatsRepository;
  late void Function(List<Object?>?) onHubReceive;
  ChatBloc(this.chat, this._chatsRepository) : super(ChatState.initial()) {
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

    add(InitChatEvent());
  }

  Future<ChatState> initialize() async {
    log("Initializing ChatBloc", name: "ChatBloc");
    var cht = await _chatsRepository.getChat(
        AuthenticationRepository().authenticationService.currentUser()!.id,
        chat.id);

    onHubReceive = (arguments) {
      log("Message received from hub: ${arguments?[0]}", name: "ChatBloc");
      add(
        NewMessageEvent(
          Message.fromJson(arguments?[0] as Map<String, dynamic>),
        ),
      );
    };
    MessagingHub().on("MessageReceived", onHubReceive);
    log("ChatBloc initialized", name: "ChatBloc");

    return ChatState.loaded(
      cht.messages.reversed.toList(),
      false,
      false,
      DateTime.now(),
    );
  }

  @override
  Future<void> close() async {
    MessagingHub().off("MessageReceived", onHubReceive);
    RouteGenerator.openedChat = null;
    await super.close();
  }
}
