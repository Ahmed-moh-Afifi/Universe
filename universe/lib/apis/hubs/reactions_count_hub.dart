import 'dart:async';
import 'dart:developer';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:universe/models/config.dart';
import 'package:universe/models/data/post_reaction.dart';

class ReactionsCountHub {
  static String serverUrl = '${Config().api}/ReactionsCountHub';
  late HubConnection hubConnection;
  late Future<void>? connection;

  ReactionsCountHub._privateConstructor() {
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
  }

  static final ReactionsCountHub _instance =
      ReactionsCountHub._privateConstructor();

  factory ReactionsCountHub() => _instance;

  Future<void>? connect() async {
    if (hubConnection.state == HubConnectionState.Connected) {
      log('Already connected with connectionId: ${hubConnection.connectionId}',
          name: 'ReactionsCountHub');
      return;
    }

    if (hubConnection.state == HubConnectionState.Connecting) {
      log('Already connecting...', name: 'ReactionsCountHub');
      await connection;
      return;
    }

    log('Connecting to $serverUrl', name: 'ReactionsCountHub');
    connection = hubConnection.start();
    await connection;
    log('Connection started with connectionId: ${hubConnection.connectionId}',
        name: 'ReactionsCountHub');
  }

  Future<void> disconnect() async {
    log('Disconnecting from connectionId: ${hubConnection.connectionId}',
        name: 'ReactionsCountHub');
    await hubConnection.stop();
    log('Disconnected from connectionId: ${hubConnection.connectionId}',
        name: 'ReactionsCountHub');
  }

  Future<void> subscribeToPostReactionsCount(String postId) async {
    log('Subscribing to post reactions count for postId: $postId',
        name: 'ReactionsCountHub');
    await hubConnection
        .invoke('JoinGroup', args: [hubConnection.connectionId!, postId]);
    log('Subscribed to post reactions count for postId: $postId',
        name: 'ReactionsCountHub');
  }

  Future<void> unsubscribeFromPostReactionsCount(String postId) async {
    log('Unsubscribing from post reactions count for postId: $postId',
        name: 'ReactionsCountHub');
    await hubConnection
        .invoke('LeaveGroup', args: [hubConnection.connectionId!, postId]);
    log('Unsubscribed from post reactions count for postId: $postId',
        name: 'ReactionsCountHub');
  }

  void onReactionsCountChanged(Function(int, String, PostReaction) callback) {
    hubConnection.on('UpdateReactionsCount', (arguments) {
      log('Received reactions count changes: $arguments',
          name: 'ReactionsCountHub');
      final reactionCount = arguments![0] as int;
      final userId = arguments[1] as String;
      final reaction =
          PostReaction.fromJson(arguments[2] as Map<String, dynamic>);

      callback(reactionCount, userId, reaction);
    });
    log('Listening to reactions count changes', name: 'ReactionsCountHub');
  }
}
