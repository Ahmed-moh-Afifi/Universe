import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:universe/apis/authentication/token_manager.dart';
import 'package:universe/models/config.dart';

class MessagingHub {
  static final MessagingHub _singleton = MessagingHub._internal();

  MessagingHub._internal();

  factory MessagingHub() {
    return _singleton;
  }

  final HubConnection _hubConnection = HubConnectionBuilder()
      .withUrl('${Config().api}/MessagingHub',
          options: HttpConnectionOptions(
            accessTokenFactory: () => Future.microtask(
              () async {
                return (await TokenManager().getValidTokens()).accessToken;
              },
            ),
          ))
      .withAutomaticReconnect()
      .build();

  Future<void> start() async {
    await _hubConnection.start();
  }

  Future<void> stop() async {
    await _hubConnection.stop();
  }

  void on(String methodName, void Function(List<Object?>?) handler) {
    _hubConnection.on(methodName, handler);
  }

  void off(String methodName, void Function(List<Object?>?)? handler) {
    _hubConnection.off(methodName, method: handler);
  }

  void invoke(String methodName, List<Object>? arguments) {
    _hubConnection.invoke(methodName, args: arguments);
  }

  void isRunning() {
    _hubConnection.state == HubConnectionState.Connected;
  }
}
