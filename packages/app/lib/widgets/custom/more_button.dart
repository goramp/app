import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../models/index.dart';
import '../helpers/index.dart';
import 'package:goramp/generated/l10n.dart';

enum Options { edit_profile, credit, invite_friends, settings }

class MoreButton extends StatelessWidget {
  final User user;
  MoreButton(this.user);
  Widget build(BuildContext context) {
    return PopupMenuButton<Options>(
      icon: Icon(Icons.more_horiz),
      onSelected: (Options result) {
        //NavigationService navigationService = Provider.of(context, listen: false);
        if (result == Options.edit_profile) {
          // final navigationService = Provider.of<NavigationService>(context, listen: false);
          // navigationService.navigateTo(EditProfileRoute, arguments: user);
        }
        if (result == Options.invite_friends) {
          LinkHelper.sharePrivateInvite(context);
        }
        if (result == Options.settings) {
          //navigationService.navigateTo(SettingsRoute);
        }
        if (result == Options.credit) {
          // final navigationService = Provider.of<NavigationService>(context, listen: false);
          // navigationService.navigateTo(CreditsRoute);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
        PopupMenuItem<Options>(
          value: Options.edit_profile,
          child: Row(
            children: <Widget>[
              Icon(
                MdiIcons.accountEditOutline,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                S.of(context).edit_profile,
              )
            ],
          ),
        ),
        // PopupMenuItem<Options>(
        //   value: Options.credit,
        //   child: Row(
        //     children: <Widget>[
        //       Icon(
        //         MdiIcons.plusCircleMultipleOutline,
        //       ),
        //       SizedBox(
        //         width: 8.0,
        //       ),
        //       Text(
        // S.of(context).get_credit,
        //       )
        //     ],
        //   ),
        // ),
        PopupMenuItem<Options>(
          value: Options.invite_friends,
          child: Row(
            children: <Widget>[
              Icon(
                MdiIcons.accountPlusOutline,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                S.of(context).invite_friends,
              ),
            ],
          ),
        ),
        PopupMenuItem<Options>(
          value: Options.settings,
          child: Row(
            children: <Widget>[
              Icon(
                MdiIcons.cogOutline,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                S.of(context).settings,
              )
            ],
          ),
        ),
      ],
    );
  }
}
