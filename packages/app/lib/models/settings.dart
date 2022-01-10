import 'notification_settings.dart';

class Settings {
  Settings({
    this.notifications,
  });
  final NotificationSettings? notifications;


  @override
  Settings.fromMap(Map<String, dynamic> map)
      : notifications = map['notifications'] != null ? NotificationSettings.fromMap(map['notifications'].cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() {
    return {
      'notifications': notifications?.toMap(),
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }


}
