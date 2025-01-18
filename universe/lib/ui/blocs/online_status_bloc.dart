import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/apis/hubs/messaging_hub.dart';
import 'package:universe/models/data/user_status.dart';

class UserState {
  final String state;
  final DateTime lastOnline;
  UserState({this.state = 'Offline', required this.lastOnline});
}

class ListenToOnlineStateEvent {}

class UpdateOnlineStateEvent {
  final String state;
  final DateTime lastOnline;
  UpdateOnlineStateEvent(this.state, {required this.lastOnline});
}

class OnlineStatusBloc extends Bloc<Object?, UserState> {
  final List<String> userIds;
  void Function(List<Object?>?)? onOnlineStateCallback;
  OnlineStatusBloc(
      {required this.userIds,
      String state = 'Offline',
      required DateTime lastOnline})
      : super(UserState(state: state, lastOnline: lastOnline)) {
    on<ListenToOnlineStateEvent>(
      (event, emit) async {
        await MessagingHub().invoke('SubscribeToUsersStatus', [userIds]);
        onOnlineStateCallback = (List<Object?>? args) {
          log('Received UpdateUserStatus event', name: 'OnlineStatusBloc');
          log('args: $args', name: 'OnlineStatusBloc');
          log('userIds: $userIds', name: 'OnlineStatusBloc');
          if (userIds.contains((args![0] as String))) {
            var userStatus =
                UserStatus.fromJson(args[1] as Map<String, dynamic>);
            add(UpdateOnlineStateEvent(userStatus.status,
                lastOnline: userStatus.lastOnline));
            log('User status updated', name: 'OnlineStatusBloc');
          }
        };

        MessagingHub().on('UpdateUserStatus', onOnlineStateCallback!);
      },
    );

    on<UpdateOnlineStateEvent>(
      (event, emit) {
        emit(UserState(state: event.state, lastOnline: event.lastOnline));
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
