import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/chat.dart';

enum ChatsStates {
  initial,
  loading,
  loaded,
  error,
}

class ChatsState {
  final ChatsStates state;
  final List<Chat> chats;
  final String error;

  ChatsState({
    required this.state,
    required this.chats,
    required this.error,
  });

  factory ChatsState.initial() {
    return ChatsState(
      state: ChatsStates.initial,
      chats: [],
      error: '',
    );
  }

  factory ChatsState.loading() {
    return ChatsState(
      state: ChatsStates.loading,
      chats: [],
      error: '',
    );
  }

  factory ChatsState.loaded(List<Chat> chats) {
    return ChatsState(
      state: ChatsStates.loaded,
      chats: chats,
      error: '',
    );
  }

  factory ChatsState.error(String error) {
    return ChatsState(
      state: ChatsStates.error,
      chats: [],
      error: error,
    );
  }
}

class MessageReceived {
  final Chat chat;

  MessageReceived({required this.chat});
}

class LoadChatsEvent {}

class MessagesBloc extends Bloc<Object, ChatsState> {
  MessagesBloc() : super(ChatsState.initial());
}
