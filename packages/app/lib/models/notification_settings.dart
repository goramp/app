class NotificationSettings {
  NotificationSettings({
    this.email,
    this.appPush,
  });
  final bool? email;
  final bool? appPush;


  NotificationSettings.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        appPush = map['appPush'];

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'appPush': appPush,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
