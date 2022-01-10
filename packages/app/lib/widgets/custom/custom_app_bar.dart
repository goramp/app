import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../services/index.dart';
import 'app_bar_logo.dart';
import 'platform_adaptive.dart';

class ElevatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<bool> hasElevation;
  final Size preferredSize;
  final Widget? leading;
  final Widget? middle;
  final List<Widget>? actions;

  ElevatedAppBar(this.hasElevation, {this.leading, this.middle, this.actions})
      : this.preferredSize = Size.fromHeight(kToolbarHeight);

  Widget _buildMaterialAppBar(BuildContext context, bool hasElevation) {
    return AppBar(
      leading: leading,
      title: middle,
      centerTitle: true,
      elevation: hasElevation ? 2.0 : 0.0,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: Container(
            height: 1.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: hasElevation
                    ? Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 0.5, // One physical pixel.
                          style: BorderStyle.solid,
                        ),
                      )
                    : Border(bottom: BorderSide.none)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: hasElevation,
      builder: (BuildContext context, bool hasElevation, _) {
        // return UniversalPlatform.isIOS
        //     ? _buildCupertinoAppBar(context, hasElevation)
        //     : _buildMaterialAppBar(context, hasElevation);
        return _buildMaterialAppBar(context, hasElevation);
      },
    );
  }
}

class DividedBottomBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? dividerColor;
  final Size preferredSize;

  DividedBottomBar({this.dividerColor})
      : this.preferredSize = Size.fromHeight(0.5);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.5,
      child: Divider(
        height: 0.5,
      ),
    );
  }
}

class SignInAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Size preferredSize;
  final Widget? leading;
  final Widget? middle;
  final List<Widget>? actions;

  SignInAppBar({this.leading, this.middle, this.actions})
      : this.preferredSize = Size.fromHeight(kToolbarHeight);

  Widget _renderBackButton(BuildContext context) {
    return PlatformAdaptiveBackButton(
      onPressed: () {
        // NavigationService navigationService =
        //     Provider.of<NavigationService>(context, listen: false);
        // navigationService.goBack();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.colorScheme.brightness == Brightness.dark;
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      leading: UniversalPlatform.isWeb ? const AppBarLogo() : leading,
      leadingWidth: UniversalPlatform.isWeb ? double.infinity : null,
      titleSpacing: 0,
      automaticallyImplyLeading: !UniversalPlatform.isWeb,
      title: UniversalPlatform.isWeb ? null : const AppBarLogo(),
      elevation: 0.0,
      actions: actions,
    );
  }
}
