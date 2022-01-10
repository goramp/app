import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:wiredash/wiredash.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../bloc/index.dart';

import '../../../models/index.dart';
import '../../utils/index.dart';

enum SettingOption {
  profile,
  logout,
  feedback,
}

class SettingItem {
  final String title;
  final String titleKey;
  final String? subtitle;
  final String? subtitleKey;
  final SettingOption option;
  final IconData icon;

  const SettingItem(
      {required this.title,
      required this.titleKey,
      required this.option,
      required this.icon,
      this.subtitle,
      this.subtitleKey});
}

Future<bool?> showLogoutDialog(BuildContext context) async {
  final ThemeData theme = Theme.of(context);
  final TextStyle? dialogTitleTextStyle = theme.textTheme.headline6;

  MyAppModel model = context.read();
  final style = TextButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: kMediumBorderRadius),
  );
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
            '${S.of(context).log_out_of} ${model.currentUser?.name ?? ""}?',
            style: dialogTitleTextStyle),
        // content: Text('This will discard your video and all changes.',
        //     style: dialogTextStyle),
        actions: <Widget>[
          TextButton(
              child: Text(S.of(context).cancel),
              style: style,
              onPressed: () {
                Navigator.of(context).pop(
                    false); // Pops the confirmation dialog but not the page.
              }),
          TextButton(
              style: style,
              child: Text(S.of(context).log_out),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Returning true to _onWillPop will pop again.
              })
        ],
      );
    },
  );
}

class ProfileSettingItem extends StatelessWidget {
  final SettingItem item;
  ProfileSettingItem(this.item);
  @override
  Widget build(BuildContext context) {
    var profile =
        context.select<MyAppModel, UserProfile?>((value) => value.profile);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = isDark ? Colors.green[200] : Colors.green[400];
    final bool enabled = profile != null;
    return ListTile(
      leading: Icon(
        item.icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      enabled: profile != null,
      onTap: () {
        PagenavigationHelper.editProfile(context);
      },
      //leading: const Icon(Icons.person_outline),
      title: Text(item.title),
      trailing: enabled
          ? profile.kycVerified
              ? Tooltip(
                  message: S.of(context).verified,
                  child: Icon(
                    Icons.verified_user,
                    color: color,
                  ),
                )
              : null
          : null,
    );
  }
}

class KuroWalletSettingItem extends StatelessWidget {
  final SettingItem item;
  KuroWalletSettingItem(this.item);
  @override
  Widget build(BuildContext context) {
    var profile =
        context.select<MyAppModel, UserProfile?>((value) => value.profile);
    final theme = Theme.of(context);
    return ListTile(
      leading: PlatformSvg.asset(Constants.APP_LOGO_KURO_SVG,
          width: 24.0, height: 24.0),
      enabled: profile != null,
      onTap: () {
        MyAppModel model = context.read();
        if (model.profile == null) {
          return;
        }
      },
      //leading: const Icon(Icons.person_outline),
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '0 KURO',
            style: theme.textTheme.subtitle1,
          ),
          Text("\$0.00", style: theme.textTheme.caption)
        ],
        crossAxisAlignment: CrossAxisAlignment.end,
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage();

  Future<void> _handleAccount(BuildContext context) async {
    PagenavigationHelper.editProfile(context);
  }

  Future<void> _handleWallets(BuildContext context) async {}

  Future<void> _handleLogout(BuildContext context) async {
    bool? logout = await showLogoutDialog(context);
    if (logout != null && logout) {
      LoginHelper.logout(context);
    }
    return null;
  }

  Future<void> _handleFeedback(BuildContext context) async {
    Wiredash.of(context)?.show();
    print('show wiredash');
  }

  Future<dynamic>? _handleSetting(BuildContext contex, SettingOption option) {
    switch (option) {
      case SettingOption.profile:
        return _handleAccount(contex);
      case SettingOption.feedback:
        return _handleFeedback(contex);
      case SettingOption.logout:
        return _handleLogout(contex);
    }
  }

  Widget _subtileWidget(BuildContext context, SettingItem item) {
    return Text(item.subtitle!);
  }

  Widget _buildListItem(
      BuildContext context, SettingItem item, UserProfile? profile) {
    if (item.option == SettingOption.profile) {
      return ProfileSettingItem(item);
    }
    return ListTile(
      enabled: profile != null,
      leading: Icon(
        item.icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        _handleSetting(context, item.option);
      },
      //leading: const Icon(Icons.person_outline),
      title: Text(item.title),
      subtitle: item.subtitle != null ? _subtileWidget(context, item) : null,
    );
  }

  Widget build(BuildContext context) {
    final defaultSettingItems = [
      SettingItem(
          icon: Icons.account_circle_outlined,
          option: SettingOption.profile,
          title: S.of(context).edit_profile,
          titleKey: "profile",
          subtitle: S.of(context).unverified.toLowerCase()),
      SettingItem(
        icon: Icons.feedback_outlined,
        option: SettingOption.feedback,
        title: S.of(context).feedback,
        titleKey: "feedback",
      ),
      SettingItem(
        icon: Icons.login_outlined,
        option: SettingOption.logout,
        title: S.of(context).log_out,
        titleKey: "logout",
      ),
    ];
    var result = context.select<MyAppModel, Tuple2>(
        (value) => Tuple2(value.currentUser, value.profile));
    if (result.item1 == null) return SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          S.of(context).settings,
        ),
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter(
          //   child: Container(
          //     color: Theme.of(context).appBarTheme.color,
          //     //height: _kUserDetailHeight,
          //     child: MyUserDetail(
          //       showUsername: true,
          //       showButtons: false,
          //       canEdit: true,
          //       profile: result.item2,
          //     ),
          //   ),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final int itemIndex = index ~/ 2;
                if (index.isEven) {
                  return _buildListItem(
                      context, defaultSettingItems[itemIndex], result.item2);
                }
                return Divider(
                  height: context.dividerHairLineWidth,
                  thickness: context.dividerHairLineWidth,
                );
              },
              semanticIndexCallback: (Widget widget, int localIndex) {
                if (localIndex.isEven) {
                  return localIndex ~/ 2;
                }
                return null;
              },
              childCount: math.max(0, defaultSettingItems.length * 2 - 1),
            ),
          ),
        ],
      ),
    );
  }
}
