import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/chats_repository.dart';
import 'package:universe/repositories/users_repository.dart';
import 'package:universe/route_generator.dart';

enum MessagesStates { initial, loading, loaded, error }

class MessagesState {
  final MessagesStates state;
  final List<Chat>? chats;
  final String? error;

  const MessagesState({required this.state, this.chats, this.error});

  factory MessagesState.initial() {
    return MessagesState(state: MessagesStates.initial);
  }

  factory MessagesState.loading() {
    return MessagesState(state: MessagesStates.loading);
  }

  factory MessagesState.loaded(List<Chat> chats) {
    return MessagesState(state: MessagesStates.loaded, chats: chats);
  }

  factory MessagesState.error(String error) {
    return MessagesState(state: MessagesStates.error, error: error);
  }
}

class GetChatsEvent {}

class OpenChatEvent {
  final User user;

  const OpenChatEvent(this.user);
}

class MessagesBloc extends Bloc<Object?, MessagesState> {
  MessagesBloc(ChatsRepository chatsRepository, UsersRepository usersRepository)
      : super(MessagesState.initial()) {
    on<GetChatsEvent>(
      (event, emit) async {
        emit(MessagesState.loading());
        try {
          var chats = await chatsRepository.getUserChats(
              AuthenticationRepository()
                  .authenticationService
                  .currentUser()!
                  .id);

          chats.sort((a, b) => b
              .messages.first.publishDate.millisecondsSinceEpoch
              .compareTo(a.messages.first.publishDate.millisecondsSinceEpoch));

          emit(MessagesState.loaded(chats));
        } on Exception {
          emit(MessagesState.error("Something went wrong."));
        }
      },
    );

    on<OpenChatEvent>(
      (event, emit) async {
        final chat = await chatsRepository.getChatByParticipants(
          AuthenticationRepository().authenticationService.currentUser()!.id,
          event.user.id,
        );

        // RouteGenerator.mainNavigatorkey.currentState!.pop();
        var user = await usersRepository.getUser(event.user.id);
        RouteGenerator.mainNavigatorkey.currentState!.pushNamed(
          RouteGenerator.chat,
          arguments: [user, chat],
        );
      },
    );
  }
}
