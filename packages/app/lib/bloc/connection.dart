import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:goramp/app_config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_platform/universal_platform.dart';
import '../events/connection.dart';

class ConnectionBloc {
  StreamSubscription<User>? _authSubscription;
  bool hasConnection = false;
  final BehaviorSubject<ConnectionEvent> _connection =
      BehaviorSubject<ConnectionEvent>();
  StreamSubscription<ConnectivityResult>? _connectivitySub;
  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();
  final AppConfig config;
  ConnectionBloc(this.config) {
    _connectivitySub =
        _connectivity.onConnectivityChanged.listen(_connectionChange);
    // checkConnection();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    if (!UniversalPlatform.isAndroid) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        connectionSink.add(ConnectionEvent(status: ConnectionStatus.online));
      } else {
        connectionSink.add(ConnectionEvent(status: ConnectionStatus.offline));
      }
    }
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;
    try {
      await http.get(Uri.parse('https://${config.webDomain}'));
      hasConnection = true;
    } catch (error) {
      hasConnection = false;
    }
    if (previousConnection != hasConnection) {
      if (hasConnection) {
        connectionSink.add(ConnectionEvent(status: ConnectionStatus.online));
      } else {
        connectionSink.add(ConnectionEvent(status: ConnectionStatus.offline));
      }
    }
    return hasConnection;
  }

  Sink<ConnectionEvent> get connectionSink => _connection.sink;

  ValueStream<ConnectionEvent> get connection => _connection.stream;

  void dispose() {
    _connection.close();
    _connectivitySub?.cancel();
    _authSubscription = null;
    _authSubscription?.cancel();
  }
}
