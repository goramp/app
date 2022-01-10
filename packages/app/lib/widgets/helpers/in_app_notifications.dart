import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';
import '../../widgets/index.dart';
import '../../models/index.dart';
import '../../bloc/index.dart';
import 'package:goramp/generated/l10n.dart';

class InAppNotificationHelper {
  static String getTitleForScheduleNotification(
      BuildContext context, CallNotificationData data, User currentUser) {
    switch (data.type) {
      case NotificationType.callConfirmed:
        return S.of(context).confirmed;
      case NotificationType.callReminder:
        return S.of(context).reminder;
      case NotificationType.callCanceled:
        return S.of(context).canceled;
      case NotificationType.callExpired:
        return S.of(context).expired;
      default:
        return S.of(context).no_title;
    }
  }

  static String getDescriptionForScheduleNotification(
      BuildContext context, CallNotificationData data, User currentUser) {
    DateTime scheduledAt = data.scheduledAt!;
    String time =
        "${DateFormat('h:mm a EEE, MMM d, yyyy').format(scheduledAt)} (${scheduledAt.timeZoneName})";
    //.UserService.getProfileStream(userId)
    bool isInvitee = data.guestId == currentUser.id;
    return "${data.title} with ${isInvitee ? data.hostUsername : data.guestUsername} for $time";
  }

  static void showNotification(BuildContext context, NotificationData? data,
      {ValueChanged<NotificationData>? onTap}) {
    MyAppModel model = context.read();
    final currentUser = model.currentUser;
    if (currentUser == null) return;
    if (data is CallNotificationData) {
      final icon = SizedBox(
        width: 40.0,
        height: 40.0,
        child: Image(
          image: CachedNetworkImageProvider(
            data.iconUrl!,
          ),
          fit: BoxFit.contain,
        ),
      );
      _showNotificationLight(
        context,
        icon: icon,
        title: getTitleForScheduleNotification(context, data, currentUser),
        description: getDescriptionForScheduleNotification(
          context,
          data,
          currentUser,
        ),
        onTap: () {
          if (onTap != null) {
            onTap(data);
          }
        },
      );
    }
  }

  static void _showNotificationLight(BuildContext context,
      {Widget? icon, String? title, String? description, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final _alertTitleStyle = theme.textTheme.headline6!.copyWith(fontSize: 16);
    final _alertDescStyle = theme.textTheme.bodyText1;
    NotificationBannerController? notificationBanner;
    notificationBanner = NotificationBannerController(
        onTap: (_) {
          onTap!();
        },
        shouldIconPulse: false,
        backgroundColor: Colors.white,
        settings: defaultBannerSettings.copyWith(
            aroundPadding: EdgeInsets.all(8.0),
            isDismissible: true,
            duration: Duration(seconds: 10)),
        boxShadow: BoxShadow(
          spreadRadius: 4.0,
          blurRadius: 10.0,
          color: Colors.black38,
        ),
        titleText: title != null
            ? Text(
                title,
                style: _alertTitleStyle,
              )
            : null,
        messageText: description != null
            ? Text(
                description,
                style: _alertDescStyle,
              )
            : null,
        bannerStyle: BannerStyle.FLOATING,
        icon: icon,
        mainButton: IconButton(
          icon: Icon(
            Icons.close,
            color: primary,
          ),
          onPressed: () async {
            notificationBanner?.dismiss();
            notificationBanner = null;
          },
        ));
    notificationBanner!.show(context);
  }

  static Future<void> presentNotification(
      BuildContext context, NotificationValue? notificationValue) async {
    if (notificationValue == null) {
      return;
    }
    NotificationsBloc notif =
        Provider.of<NotificationsBloc>(context, listen: false);
    InAppNotificationHelper.showNotification(context, notificationValue.data,
        onTap: (NotificationData data) {
      _handleNotificationNavigation(context, notificationValue.data);
    });
    notif.clearNotification();
  }

  static Future<void> _handleNotificationNavigation(
      BuildContext context, NotificationData? data) async {
    if (data is CallNotificationData) {
      if (data.type != NotificationType.callCanceled) {
        // navigationService.navigateTo(
        //   ScheduleRoute,
        //   arguments: FeedPreviewArgs<Call>(
        //     data.scheduleId,
        //   ),
        // );
      }
    }
  }
}
