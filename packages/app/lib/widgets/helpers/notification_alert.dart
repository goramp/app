import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../custom/banners/index.dart';
import '../styles/index.dart';

class NotificationHelper {
  static void showErrorLight(BuildContext context,
      {String? title, String? description}) {
    final _alertTitleStyle =
        TextStyle(color: Theme.of(context).errorColor, fontSize: 22);
    final _alertDescStyle =
        TextStyle(color: Theme.of(context).errorColor, fontSize: 14);
    final erroIcon = Icon(
      MdiIcons.alertOctagon,
      size: 35,
      color: Theme.of(context).errorColor,
    );
    NotificationBannerController? errorNotificationBanner;
    errorNotificationBanner = NotificationBannerController(
        backgroundColor: Colors.white,
        settings: defaultBannerSettings.copyWith(
          aroundPadding: EdgeInsets.all(8.0),
          isDismissible: true,
          duration: Duration(seconds: 6)
        ),
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
        icon: erroIcon,
        mainButton: IconButton(
          icon: Icon(
            Icons.close,
            color: primary,
          ),
          onPressed: () async {
            errorNotificationBanner?.dismiss();
            errorNotificationBanner = null;
          },
        ));
    errorNotificationBanner!.show(context);
  }
}
