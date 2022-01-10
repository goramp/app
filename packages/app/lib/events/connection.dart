
import 'package:meta/meta.dart';
enum ConnectionStatus {
  /// device is online any connected
  online,

  /// device is offline
  offline,

  /// we dont yet know the connection status
  undetermined
}

class ConnectionEvent {
  final ConnectionStatus status;
  String? message;

  ConnectionEvent({required this.status, this.message}) : assert(status != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ConnectionEvent &&
              runtimeType == other.runtimeType &&
              message == other.message &&
              status == other.status;

  @override
  int get hashCode => status.hashCode ^ message.hashCode;
}