import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/custom/gt_navigation_rail.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:safe_insets/index.dart';
import 'package:url_launcher/link.dart';
import 'package:wiredash/wiredash.dart';
import 'package:goramp/generated/l10n.dart';
import 'tabs.dart';

const _kMinWidth = 72.0;

class _AppLogo extends StatelessWidget {
  const _AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConfig config = Provider.of(context, listen: false);
    return PlatformSvg.asset(
      config.isKuro ? Constants.APP_LOGO_KURO_SVG : Constants.APP_LOGO_SVG,
      width: 32,
    );
  }
}

class _NavigationRailHeader extends StatelessWidget {
  const _NavigationRailHeader({
    required this.extended,
  });

  final ValueNotifier<bool> extended;

  @override
  Widget build(BuildContext context) {
    final animation = GTNavigationRail.extendedAnimation(context)!;
    AppConfig config = Provider.of(context, listen: false);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Align(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: animation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                width: _kMinWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Link(
                      uri: Uri.parse(config.landingUrl!),
                      target: LinkTarget.blank,
                      builder: (contex, follow) =>
                          const _AppLogo().clickable(follow),
                    ),
                    // if (animation.value > 0)
                    //   Opacity(
                    //     opacity: animation.value,
                    //     child: Row(
                    //       children: const [
                    //         SizedBox(width: 18),
                    //         ProfileAvatar(
                    //           avatar: 'reply/avatars/avatar_2.jpg',
                    //           radius: 16,
                    //         ),
                    //         SizedBox(width: 12),
                    //         Icon(
                    //           Icons.settings,
                    //           color: ReplyColors.white50,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavigationRailFooter extends StatelessWidget {
  const _NavigationRailFooter();

  Widget _buildIconButton(BuildContext context, Icon child,
      {VoidCallback? onTap, String? tooltipMessage}) {
    final theme = Theme.of(context);
    final NavigationRailThemeData navigationRailTheme =
        NavigationRailTheme.of(context);
    final IconThemeData? defaultUnselectedIconTheme =
        navigationRailTheme.unselectedIconTheme;
    final IconThemeData unselectedIconTheme = IconThemeData(
      size: defaultUnselectedIconTheme?.size ?? 24.0,
      color: defaultUnselectedIconTheme?.color ?? theme.colorScheme.onSurface,
      opacity: defaultUnselectedIconTheme?.opacity ?? 0.64,
    );
    final icon = SizedBox(
      width: _kMinWidth,
      height: _kMinWidth,
      child: Align(
        alignment: Alignment.center,
        child: IconTheme(
          child: child,
          data: unselectedIconTheme,
        ),
      ),
    );
    return Tooltip(
      message: tooltipMessage ?? '',
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.none,
        child: InkResponse(
          onTap: onTap,
          highlightShape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(_kMinWidth / 2.0)),
          containedInkWell: true,
          splashColor: theme.colorScheme.primary.withOpacity(0.12),
          hoverColor: theme.colorScheme.primary.withOpacity(0.04),
          child: icon,
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    bool? logout = await showLogoutDialog(context);
    if (logout != null && logout) {
      LoginHelper.logout(context);
    }
    return null;
  }

  Future<void> _handleFeedback(BuildContext context) async {
    Wiredash.of(context)?.show();
  }

  @override
  Widget build(BuildContext context) {
    //final animation = NavigationRail.extendedAnimation(context);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Divider(
            height: _kMinWidth,
            thickness: context.dividerHairLineWidth,
          ),
          _buildIconButton(context, Icon(Icons.feedback_outlined),
              onTap: () => _handleFeedback(context),
              tooltipMessage: S.of(context).feedback),
          _buildIconButton(context, Icon(Icons.logout_outlined),
              onTap: () => _handleLogout(context),
              tooltipMessage: S.of(context).log_out)
        ],
      ),
    );
  }
}

class KNavigationBar extends StatefulWidget {
  final ValueChanged<int> onSelect;
  final bool extended;
  final int page;

  const KNavigationBar(this.onSelect, this.page, {this.extended = false});

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<KNavigationBar> {
  late ValueNotifier<bool> _isExtended;

  @override
  void initState() {
    super.initState();
    _isExtended = ValueNotifier<bool>(widget.extended);
  }

  Widget _buildSideNavigation(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ClipRect(
        child: Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        // border: Border(
        //   right: BorderSide(
        //     color: Theme.of(context).dividerColor,
        //     width: context.dividerHairLineWidth, // One physical pixel.
        //     style: BorderStyle.solid,
        //   ),
        // ),
      ),
      child: SafeArea(
        top: true,
        child: ValueListenableBuilder<bool>(
            valueListenable: _isExtended,
            builder: (context, value, child) {
              return GTNavigationRail(
                backgroundColor: Colors.transparent,
                onDestinationSelected: widget.onSelect,
                elevation: null,
                selectedIndex: widget.page,
                leading: _NavigationRailHeader(
                  extended: _isExtended,
                ),
                labelType: GTNavigationRailLabelType.selected,
                //extended: value,
                destinations: DesktopTabs.map(
                  (TabDescription tab) => GTNavigationRailDestination(
                    icon: tab.dummy ? SizedBox.shrink() : tab.icon,
                    label: tab.dummy
                        ? const SizedBox.shrink()
                        : Text(TabDescription.tabTitle(context, tab) ?? ''),
                    tooltip: TabDescription.tabTitle(context, tab) ?? '',
                    selectedIcon:
                        tab.dummy ? SizedBox.shrink() : tab.activeIcon,
                  ),
                ).toList(),
                trailing: const _NavigationRailFooter(),
              );
            }),
      ),
    ));
  }

  Widget _buildBottomNavigation(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor,
          // border: Border(
          //   top: BorderSide(
          //     color: Theme.of(context).dividerColor,
          //     width: context.dividerHairLineWidth,
          //     style: BorderStyle.solid,
          //   ),
          // ),
        ),
        child: SafeArea(
            top: false,
            bottom: true,
            child: SafeAreaWrap(
              BottomNavigationBar(
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                onTap: widget.onSelect,
                elevation: 0.0,
                currentIndex: widget.page >= Tabs.length ? 0 : widget.page,
                unselectedItemColor: theme.textTheme.caption!.color,
                selectedItemColor: theme.colorScheme.primary,
                items: Tabs.map(
                  (TabDescription tab) => BottomNavigationBarItem(
                    icon: tab.dummy ? SizedBox.shrink() : tab.icon,
                    label: tab.dummy ? '' : TabDescription.tabTitle(context, tab),
                    activeIcon: tab.dummy ? SizedBox.shrink() : tab.activeIcon,
                  ),
                ).toList(),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    if (isDesktop) {
      return _buildSideNavigation(context);
    }
    return _buildBottomNavigation(context);
  }
}
