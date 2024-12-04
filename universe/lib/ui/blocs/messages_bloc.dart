import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/chats_repository.dart';

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

class MessagesBloc extends Bloc<Object?, MessagesState> {
  MessagesBloc(ChatsRepository chatsRepository)
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

          emit(MessagesState.loaded(chats));
        } on Exception {
          emit(MessagesState.error("Something went wrong."));
        }
      },
    );
  }
}
