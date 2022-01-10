import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../custom/edge_alert.dart';

const _errorAlertDurarion = 4;

class AlertHelper {
  static void showErrorLight(BuildContext context,
      {String? title, String? description, int? duration, bottom = false}) {
    final _alertTitleStyle =
        TextStyle(color: Theme.of(context).errorColor, fontSize: 22);
    final _alertDescStyle =
        TextStyle(color: Theme.of(context).errorColor, fontSize: 14);
    final erroIcon = Icon(
      MdiIcons.alertOctagon,
      size: 35,
      color: Theme.of(context).errorColor,
    );
    EdgeAlert.show(context,
        title: title,
        titleStyle: _alertTitleStyle,
        description: description,
        descriptionStyle:
            duration == null ? _alertDescStyle : duration as TextStyle?,
        duration: _errorAlertDurarion,
        gravity: bottom ? EdgeAlert.BOTTOM : EdgeAlert.TOP,
        backgroundColor: Colors.white,
        icon: erroIcon);
  }
}
