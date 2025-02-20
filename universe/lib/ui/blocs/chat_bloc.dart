import 'dart:async';
import 'dart:collection';
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
  final User? typingUser;

  ChatState({
    required this.state,
    this.messages,
    this.isTyping,
    this.isOnline,
    this.lastOnline,
    this.error,
    this.typingUser,
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
    User? typingUser,
  ) {
    return ChatState(
      state: ChatStates.loaded,
      messages: messages,
      isTyping: isTyping,
      isOnline: isOnline,
      lastOnline: lastOnline,
      error: '',
      typingUser: typingUser,
    );
  }

  factory ChatState.newMessage(
    List<Message> messages,
    bool isTyping,
    bool isOnline,
    DateTime lastOnline,
    User? typingUser,
  ) {
    return ChatState(
      state: ChatStates.newMessage,
      messages: messages,
      isTyping: isTyping,
      isOnline: isOnline,
      lastOnline: lastOnline,
      error: '',
      typingUser: typingUser,
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
      typingUser: oldState.typingUser,
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
  final User user;

  const StatusUpdatedEvent({
    required this.isTyping,
    required this.isOnline,
    required this.lastOnline,
    required this.user,
  });
}

class UpdateStatusEvent {
  final bool typing;

  const UpdateStatusEvent({required this.typing});
}

class SendMessage {
  final Message message;

  SendMessage(this.message);
}

class TextChangedEvent {}

class ChatBloc extends Bloc<Object, ChatState> {
  Chat chat;
  final IChatsRepository _chatsRepository;
  late void Function(List<Object?>?) onHubReceive;
  late void Function(List<Object?>?) onStatusChanged;
  DateTime? lastTyped;
  HashSet<String> sentMessages = HashSet();
  Queue<User> typingUsers = Queue();
  late Timer typingIndicatorTimer;

  ChatBloc(this.chat, this._chatsRepository)
      : super(ChatState.initial(
            online: chat.users.any((u) => u.onlineSessions > 0))) {
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
        if (!sentMessages.remove(event.message.uid!)) {
          emit(
            ChatState.newMessage(
              [
                event.message,
                ...?state.messages,
              ],
              state.isTyping ?? false,
              state.isOnline ?? false,
              state.lastOnline ?? DateTime.now(),
              state.typingUser,
            ),
          );
        }
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
            event.user,
          ),
        );
      },
    );

    on<SendMessage>(
      (event, emit) async {
        await updateStatus(false);
        log('Sending message: ${event.message}', name: 'NotificationsBloc');
        sentMessages.add(event.message.uid!);
        add(NewMessageEvent(event.message));
        MessagingHub().invoke('SendToChatAsync', [event.message]);
      },
    );

    on<UpdateStatusEvent>(
      (event, emit) async {
        await updateStatus(event.typing);
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
    chat = await _chatsRepository.getChat(
        AuthenticationRepository().authenticationService.currentUser()!.id,
        chat.id);

    await MessagingHub().invoke("SubscribeToUsersStatus", [
      chat.users
          .map(
            (e) => e.id,
          )
          .toList()
    ]);
    await MessagingHub().invoke("SubscribeToChats", [
      [chat.id.toString()]
    ]);

    onHubReceive = (arguments) {
      log("Message received from hub: ${arguments?[0]}", name: "ChatBloc");
      var message = Message.fromJson(arguments?[0] as Map<String, dynamic>);
      if (message.chatId == chat.id) {
        add(
          NewMessageEvent(
            message,
          ),
        );
      }
    };
    onStatusChanged = (arguments) {
      log('User status updated: ${arguments?[0]}', name: "ChatBloc");
      if ((arguments?[0] as String == chat.id.toString() ||
              arguments?[0] as String == "-1") &&
          arguments?[1] !=
              AuthenticationRepository()
                  .authenticationService
                  .currentUser()!
                  .id) {
        var userStatus =
            UserStatus.fromJson(arguments?[2] as Map<String, dynamic>);
        if (userStatus.status == "Typing") {
          typingUsers.add(
              chat.users.singleWhere((u) => u.id == arguments?[1] as String));
        } else {
          typingUsers.removeWhere(
            (u) => u.id == arguments?[1] as String,
          );
        }
        if (userStatus.status == "Typing" || typingUsers.isEmpty) {
          add(
            StatusUpdatedEvent(
                isTyping: userStatus.status == "Typing",
                isOnline: userStatus.status != "Offline",
                lastOnline: userStatus.lastOnline,
                user: chat.users
                    .singleWhere((u) => u.id == arguments?[1] as String)),
          );
        }
      }
    };
    MessagingHub().on("MessageReceived", onHubReceive);
    MessagingHub().on("UpdateUserStatus", onStatusChanged);

    typingIndicatorTimer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        log('Typing timer tick.', name: "ChatBloc");
        if (typingUsers.isNotEmpty) {
          log('Typing Users Queue is not empty.', name: "ChatBloc");

          add(
            StatusUpdatedEvent(
              isTyping: true,
              isOnline: true,
              lastOnline: DateTime.now(),
              user: typingUsers.first,
            ),
          );
          typingUsers.add(typingUsers.first);
          typingUsers.removeFirst();
        }
      },
    );

    log("ChatBloc initialized", name: "ChatBloc");
    log("Users count in chat: ${chat.users.length}", name: "ChatBloc");

    return ChatState.loaded(
      chat.messages.reversed.toList(),
      false,
      state.isOnline!,
      DateTime.now(),
      state.typingUser,
    );
  }

  Future<void> updateStatus(bool typing) async {
    await MessagingHub().invoke('SendTypingStatus', [
      chat.id.toString(),
      UserStatus(
        status: typing ? 'Typing' : 'Online',
        lastOnline: DateTime.now(),
      )
    ]);
  }

  @override
  Future<void> close() async {
    MessagingHub().off("MessageReceived", onHubReceive);
    MessagingHub().off("UpdateUserStatus", onStatusChanged);
    await MessagingHub().invoke("UnsubscribeFromUsersStatus", [
      chat.users
          .map(
            (e) => e.id,
          )
          .toList()
    ]);
    await MessagingHub().invoke("UnsubscribeFromChats", [
      [chat.id.toString()]
    ]);
    RouteGenerator.openedChat = null;
    await super.close();
  }
}
