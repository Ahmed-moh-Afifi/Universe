import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/chat.dart';

enum MessagesStates { initial, loading, loaded, error }

class MessagesState {
  final MessagesStates state;
  final List<Chat> chats;
  final String error;

  MessagesState({
    required this.state,
    required this.chats,
    required this.error,
  });

  factory MessagesState.initial() {
    return MessagesState(
      state: MessagesStates.initial,
      chats: [],
      error: '',
    );
  }

  factory MessagesState.loading() {
    return MessagesState(
      state: MessagesStates.loading,
      chats: [],
      error: '',
    );
  }

  factory MessagesState.loaded(List<Chat> chats) {
    return MessagesState(
      state: MessagesStates.loaded,
      chats: chats,
      error: '',
    );
  }

  factory MessagesState.error(String error) {
    return MessagesState(
      state: MessagesStates.error,
      chats: [],
      error: error,
    );
  }
}

class LoadChatsEvent {}

class MessagesBloc extends Bloc<Object, MessagesState> {
  MessagesBloc() : super(MessagesState.initial());
}
