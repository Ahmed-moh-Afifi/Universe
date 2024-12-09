import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:universe/models/config.dart';

class ReactionsCountHub {
  static final ReactionsCountHub _singleton = ReactionsCountHub._internal();

  ReactionsCountHub._internal();

  factory ReactionsCountHub() {
    return _singleton;
  }

  final HubConnection _hubConnection = HubConnectionBuilder()
      .withUrl('${Config().api}/ReactionsCountHub',
          options: HttpConnectionOptions(
              // accessTokenFactory: () => Future.microtask(
              //   () async {
              //     return (await TokenManager().getValidTokens()).accessToken;
              //   },
              // ),
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

  Future invoke(String methodName, List<Object>? arguments) async {
    await _hubConnection.invoke(methodName, args: arguments);
  }

  void isRunning() {
    _hubConnection.state == HubConnectionState.Connected;
  }
}
