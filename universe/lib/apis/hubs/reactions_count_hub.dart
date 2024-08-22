import 'dart:async';
import 'dart:developer';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:universe/models/config.dart';
import 'package:universe/models/responses/reactions_count_change.dart';

class ReactionsCountHub {
  static String serverUrl = '${Config().api}/ReactionsCountHub';
  late HubConnection hubConnection;

  ReactionsCountHub._privateConstructor() {
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
  }

  static final ReactionsCountHub _instance =
      ReactionsCountHub._privateConstructor();

  factory ReactionsCountHub() => _instance;

  Future<void> connect() async {
    if (hubConnection.state == HubConnectionState.Connected) {
      log('Already connected with connectionId: ${hubConnection.connectionId}');
      return;
    }

    log('Connecting to $serverUrl');
    await hubConnection.start();
    log('Connection started with connectionId: ${hubConnection.connectionId}');
  }

  Future<void> disconnect() async {
    log('Disconnecting from connectionId: ${hubConnection.connectionId}');
    await hubConnection.stop();
    log('Disconnected from connectionId: ${hubConnection.connectionId}');
  }

  Future<void> subscribeToPostReactionsCount(String postId) async {
    log('Subscribing to post reactions count for postId: $postId');
    await hubConnection
        .invoke('JoinGroup', args: [hubConnection.connectionId!, postId]);
    log('Subscribed to post reactions count for postId: $postId');
  }

  Future<void> unsubscribeFromPostReactionsCount(String postId) async {
    log('Unsubscribing from post reactions count for postId: $postId');
    await hubConnection
        .invoke('LeaveGroup', args: [hubConnection.connectionId!, postId]);
    log('Unsubscribed from post reactions count for postId: $postId');
  }

  Stream<ReactionsCountChange> onReactionsCountChanged() async* {
    final controller = StreamController<ReactionsCountChange>();

    hubConnection.on('UpdateReactionsCount', (arguments) {
      log('Received reactions count changes: $arguments');
      final reactionCount = arguments![0] as int;
      final userId = arguments[1] as String;
      controller
          .add(ReactionsCountChange(change: reactionCount, userId: userId));
    });

    log('Listening to reactions count changes');

    // Yield each event from the controller's stream
    yield* controller.stream;

    // Clean up when the stream is done
    await controller.close();
    log('Stopped listening to reactions count changes');
  }

  // Stream<ReactionsCountChange> onReactionsCountChanged() async* {
  //   hubConnection.on('UpdateReactionsCount', (arguments) {
  //     log('Received reactions count changes: $arguments');
  //     final reactionCount = arguments![0] as int;
  //     final userId = arguments[1] as String;
  //     yield ReactionsCountChange(reactionCount, userId);
  //   });
  //   log('Listening to reactions count changes');
  // }
}
