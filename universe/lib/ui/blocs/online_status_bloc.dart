import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/hubs/messaging_hub.dart';

class OnlineState {
  final bool isOnline;
  OnlineState({this.isOnline = false});
}

class ListenToOnlineStateEvent {}

class UpdateOnlineStateEvent {
  final bool isOnline;
  UpdateOnlineStateEvent(this.isOnline);
}

class OnlineStatusBloc extends Bloc<Object?, OnlineState> {
  final List<String> userIds;
  void Function(List<Object?>?)? onOnlineStateCallback;
  OnlineStatusBloc({required this.userIds, bool isOnline = false})
      : super(OnlineState(isOnline: isOnline)) {
    on<ListenToOnlineStateEvent>(
      (event, emit) async {
        await MessagingHub().invoke('SubscribeToUsersStatus', [userIds]);
        onOnlineStateCallback = (List<Object?>? args) {
          log('Received UpdateUserStatus event', name: 'OnlineStatusBloc');
          log('args: $args', name: 'OnlineStatusBloc');
          log('userIds: $userIds', name: 'OnlineStatusBloc');
          if (userIds.contains((args![0] as String))) {
            add(UpdateOnlineStateEvent((args[1] as String) == 'Online'));
            log('User status updated', name: 'OnlineStatusBloc');
          }
        };

        MessagingHub().on('UpdateUserStatus', onOnlineStateCallback!);
      },
    );

    on<UpdateOnlineStateEvent>(
      (event, emit) {
        emit(OnlineState(isOnline: event.isOnline));
      },
    );

    add(ListenToOnlineStateEvent());
  }

  @override
  Future<void> close() async {
    log('Closing OnlineStatusBloc', name: 'OnlineStatusBloc');
    MessagingHub().off('UpdateUserStatus', onOnlineStateCallback);
    await MessagingHub().invoke('UnsubscribeFromUsersStatus', [userIds]);
    return super.close();
  }
}
