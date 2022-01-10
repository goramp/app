class NotificationChannel {
  final String channelId;
  final String channelName;
  final String channelDescription;
  const NotificationChannel(
      {required this.channelId, required this.channelName, required this.channelDescription})
      : assert(channelId != null),
        assert(channelName != null),
        assert(channelDescription != null);
}