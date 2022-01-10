import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/widgets/custom/one_line_text.dart';
import 'package:goramp/widgets/custom/page_feed/base_event_tile.dart';
import 'package:goramp/widgets/router/routes/public_route_path.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:sized_context/sized_context.dart';
import 'package:time/time.dart';
import 'package:timezone/timezone.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:goramp/generated/l10n.dart';
import '../../index.dart';
import '../../../models/index.dart';
import '../../utils/index.dart';

class CallTime extends StatelessWidget {
  final DateTime? scheduledAt;
  final TextStyle? style;
  final TextStyle? dotStyle;
  CallTime(this.scheduledAt, {this.style, this.dotStyle});
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TimeOfDay start =
        TimeOfDay(hour: scheduledAt!.hour, minute: scheduledAt!.minute);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          '${DateFormat('MMM d, yyyy').format(scheduledAt!)}',
          style: style ?? theme.textTheme.caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Icon(MdiIcons.circleSmall,
            size: 16, color: dotStyle?.color ?? theme.textTheme.caption!.color),
        Text(
          '${IntervalHelper.formatTimeL(MaterialLocalizations.of(context), start)}',
          style: style ?? theme.textTheme.caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class DummyGridTile extends StatelessWidget {
  final Color? color;
  final bool useShadow;
  final BorderRadius borderRadius;
  final double? itemExtent;
  DummyGridTile(
      {this.color,
      this.itemExtent,
      this.useShadow = false,
      this.borderRadius = kBorderRadius});

  BoxDecoration _buildShadowAndRoundedCorners(BuildContext context) {
    ThemeData theme = Theme.of(context);
    BorderSide side = BorderSide(color: theme.dividerColor, width: 0.5);
    return BoxDecoration(
      color: color ?? Theme.of(context).disabledColor,
      borderRadius: borderRadius,
      border: Border(top: side, left: side, right: side, bottom: side),
      boxShadow: useShadow
          ? <BoxShadow>[
              BoxShadow(
                spreadRadius: 2.0,
                blurRadius: 8.0,
                color: Colors.black26,
              ),
            ]
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        children: [
          Container(
            width: itemExtent,
            height: itemExtent,
            decoration: _buildShadowAndRoundedCorners(context),
          )
        ],
      ),
    );
  }
}

class CallThumbnail extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double iconSize;
  final Widget? child;
  final bool useShadow;
  final double radius;
  CallThumbnail(this.imageUrl,
      {this.width,
      this.height,
      this.child,
      this.useShadow = false,
      this.iconSize = 18.0,
      this.radius = 6});

  BoxDecoration _buildShadowAndRoundedCorners(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = isDark ? Colors.white10 : Colors.black54;
    BorderSide side = BorderSide(color: color, width: 0.5);
    return BoxDecoration(
      color: Theme.of(context).disabledColor,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      border: Border(top: side, left: side, right: side, bottom: side),
      boxShadow: useShadow
          ? <BoxShadow>[
              BoxShadow(
                  spreadRadius: 2.0,
                  blurRadius: 8.0,
                  color: isDark ? Colors.black26 : Colors.black54),
            ]
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: _buildShadowAndRoundedCorners(context),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image(
                image: CachedNetworkImageProvider(imageUrl!),
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: IconS(
                    Icons.play_arrow_outlined,
                    size: iconSize,
                    color: Colors.white,
                    shadows: ICON_SHADOW,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class SimpleCallListTile extends StatelessWidget {
  final Call? schedule;
  final User? user;
  final double? parentWidth;
  final bool showDividers;
  final bool isLast;

  SimpleCallListTile(
      {Key? key,
      required this.schedule,
      required this.user,
      this.parentWidth,
      this.isLast = false,
      this.showDividers = true})
      : super(key: key);

  bool get headerMode => schedule == null;

  Widget _buildThumb() {
    Widget thumb = CallThumbnail(
      schedule?.video?.thumbnail?.url,
      width: 64,
      height: 64,
    );
    if (UniversalPlatform.isWeb) {
      return thumb;
    }
    return Hero(tag: "${kCallPreviewTag}_${schedule?.id}", child: thumb);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MyAppModel model = Provider.of<MyAppModel>(context, listen: false);
    bool isHost = model.currentUser?.id == schedule?.hostId;
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildThumb(),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 64.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                if (schedule != null) CallTitleArea(schedule!),
                                if (schedule != null)
                                  Row(
                                    children: [
                                      CallListDuration(schedule),
                                      if (schedule!.hasRecording != null &&
                                          schedule!.hasRecording!)
                                        CallListRecord(),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          if (schedule != null)
                            CallLinkGridAvatar(
                              name: isHost
                                  ? (schedule!.guestName ??
                                      schedule!.guestUsername)
                                  : (schedule!.hostName ??
                                      schedule!.hostUsername),
                              imageUrl: isHost
                                  ? schedule!.guestImageUrl
                                  : schedule!.hostImageUrl,
                              showIcon: false,
                              style: theme.textTheme.caption!
                                  .copyWith(color: theme.colorScheme.primary),
                              onPressed: () {
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  if (schedule != null) CallListTimer(schedule!)
                ],
              ),
            ),
          ),
          // if (!headerMode && showDividers && !isLast)
          //   Divider(
          //     height: context.dividerHairLineWidth,
          //     thickness: context.dividerHairLineWidth,
          //     indent: (isLast || headerMode) ? 0.0 : 88.0, // isCompact ? 88.0 :
          //     endIndent: (isLast || headerMode) ? 0.0 : 12.0,
          //   )
        ],
      ),
    );
  }
}

class CallListRow extends StatelessWidget {
  final Call? schedule;
  final User? user;
  final double? parentWidth;
  final bool showDividers;
  final bool isLast;
  CallListRow({
    Key? key,
    this.schedule,
    this.user,
    this.parentWidth,
    this.showDividers = true,
    this.isLast = false,
  }) : super(key: key);

  bool get headerMode => schedule == null;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Widget rowText(String value) => OneLineText(value,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: FontSizes.s12)
            .withCanvaskitFontFix);
    double width = parentWidth ?? context.widthPx;
    int colCount = 1;
    if (width > 450) colCount = 2;
    if (width > 600) colCount = 3;
    if (width > 1000) colCount = 4;
    if (width > 1300) colCount = 5;
    MyAppModel model = Provider.of<MyAppModel>(context, listen: false);
    bool isHost = model.currentUser?.id == schedule!.hostId;
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  (headerMode
                          ? rowText(S.of(context).call_link)
                          : CallProfile(schedule!, user!))
                      .constrained(minWidth: 300)
                      .expanded(flex: 20 * 100),
                  _FadingFlexContent(
                      flex: 11,
                      isVisible: colCount > 1,
                      child: headerMode
                          ? rowText(
                              isHost ? S.of(context).guest : S.of(context).host)
                          : Container(
                              alignment: Alignment.centerLeft,
                              child: CallLinkGridAvatar(
                                name: isHost
                                    ? (schedule!.guestName ??
                                        schedule!.guestUsername)
                                    : (schedule!.hostName ??
                                        schedule!.hostUsername),
                                imageUrl: isHost
                                    ? schedule!.guestImageUrl
                                    : schedule!.hostImageUrl,
                                showIcon: true,
                                style: theme.textTheme.caption!
                                    .copyWith(color: theme.colorScheme.primary),
                                onPressed: () {
                                },
                              ),
                            )),
                  _FadingFlexContent(
                    flex: 10,
                    isVisible: colCount > 2,
                    child: (headerMode
                        ? rowText(S.of(context).time)
                        : CallListRowTime(schedule!)),
                  ),
                  //spacer,
                  _FadingFlexContent(
                      flex: 10,
                      isVisible: colCount > 3,
                      child: (headerMode
                          ? rowText(S.of(context).duration)
                          : CallListDuration(schedule))),
                ],
              ),
            ),
          ),
          // if (!headerMode && showDividers && !isLast)
          //   Divider(
          //     height: context.dividerHairLineWidth,
          //     thickness: context.dividerHairLineWidth,
          //     indent: (isLast || headerMode) ? 0.0 : 64.0, // isCompact ? 88.0 :
          //     endIndent: (isLast || headerMode) ? 0.0 : 12.0,
          //   )
        ],
      ),
    );
  }
}

class CallProfile extends StatelessWidget {
  final Call? schedule;
  final User user;
  final double avatarWidth;
  final double avatarHeight;
  final String heroPrefix;
  CallProfile(this.schedule, this.user,
      {this.avatarWidth = 40.0,
      this.avatarHeight = 40.0,
      this.heroPrefix = ""});

  Widget _buildThumb() {
    Widget thumb = CallThumbnail(
      schedule?.video?.thumbnail?.url,
      width: avatarWidth,
      height: avatarHeight,
    );
    if (UniversalPlatform.isWeb) {
      return thumb;
    }
    return Hero(tag: "${kCallPreviewTag}_${schedule?.id}", child: thumb);
  }

  Widget build(BuildContext context) {
    final spacer = HSpace(
      Insets.l,
    );
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildThumb(),
        spacer,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (schedule != null) CallTitleArea(schedule!),
              if (schedule != null)
                Row(
                  children: [
                    // CallListDuration(schedule),
                    if (schedule?.hasRecording != null &&
                        schedule!.hasRecording!)
                      CallListRecord(),
                  ],
                ),
            ],
          ),
        ),
        HSpace(
          Insets.m,
        ),
      ],
    );
  }
}

class CallTitleArea extends StatelessWidget {
  final Call schedule;
  const CallTitleArea(this.schedule);
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CallLinkGridTitle(
          title: schedule.title,
          maxLines: 1,
          style: isDesktop
              ? theme.textTheme.bodyText1!.withCanvaskitFontFix
              : theme.textTheme.subtitle1!.withCanvaskitFontFix,
        ),
      ],
    );
  }
}

class CallListTimer extends StatelessWidget {
  final Call schedule;
  const CallListTimer(this.schedule);
  @override
  Widget build(BuildContext context) {
    final MyAppModel model = Provider.of(context, listen: false);
    bool isHost = model.currentUser?.id == schedule.hostId;
    final timezone = isHost ? schedule.hostTimezone : schedule.guestTimezone;
    final location = timeZoneDatabase.get(timezone!);
    final scheduledAt = TZDateTime.from(schedule.scheduledAt!, location);
    ThemeData theme = Theme.of(context);
    TimeOfDay start =
        TimeOfDay(hour: scheduledAt.hour, minute: scheduledAt.minute);
    final textStyle = schedule.endAt != null
        ? theme.textTheme.caption!.copyWith(fontWeight: FontWeight.bold)
        : theme.textTheme.caption!.copyWith(
            color: theme.colorScheme.primary, fontWeight: FontWeight.bold);
    return Container(
      width: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${IntervalHelper.formatTimeS(MaterialLocalizations.of(context), start)}',
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
          Text(
            '${IntervalHelper.formatAnteMeridian(MaterialLocalizations.of(context), start, capitalize: true)}',
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
          // const SizedBox(
          //   height: 8.0,
          // ),
        ],
      ),
    );
  }
}

class CallListRowTime extends StatelessWidget {
  final Call schedule;
  const CallListRowTime(this.schedule);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);
    MyAppModel model = Provider.of<MyAppModel>(context, listen: false);
    bool isHost = model.currentUser?.id == schedule.hostId;
    final timezone = isHost ? schedule.hostTimezone : schedule.guestTimezone;
    final location = timeZoneDatabase.get(timezone!);
    final scheduledAt = TZDateTime.from(schedule.scheduledAt!, location);
    TimeOfDay start =
        TimeOfDay(hour: scheduledAt.hour, minute: scheduledAt.minute);
    final textStyle = schedule.endAt != null
        ? isDesktop
            ? theme.textTheme.bodyText2
            : theme.textTheme.caption!.copyWith(fontWeight: FontWeight.bold)
        : isDesktop
            ? theme.textTheme.bodyText2!
                .copyWith(color: theme.colorScheme.primary)
            : theme.textTheme.caption!.copyWith(
                color: theme.colorScheme.primary, fontWeight: FontWeight.bold);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${IntervalHelper.formatTimeS(MaterialLocalizations.of(context), start)}',
          style: textStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
        Text(
          '${IntervalHelper.formatAnteMeridian(MaterialLocalizations.of(context), start, capitalize: true)}',
          style: textStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
        // const SizedBox(
        //   height: 8.0,
        // ),
      ],
    );
  }
}

class CallListRecord extends StatelessWidget {
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(MdiIcons.circleSmall,
            size: 16, color: theme.textTheme.caption!.color),
        Icon(Icons.archive, size: 14, color: theme.textTheme.caption!.color),
        const SizedBox(width: 2.0),
        Text(
          S.of(context).recorded.toLowerCase(),
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

class CallListDuration extends StatelessWidget {
  final Call? schedule;
  CallListDuration(this.schedule);

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(MdiIcons.clock, size: 14, color: theme.textTheme.caption!.color),
        const SizedBox(width: 2.0),
        Text(
          '${schedule!.duration?.inMinutes} ${S.of(context).mins}',
          style: isDesktop
              ? theme.textTheme.bodyText2!.withCanvaskitFontFix
              : theme.textTheme.caption!.withCanvaskitFontFix,
        ),
      ],
    );
  }
}

class SimpleCallGridTile extends StatelessWidget {
  final Call schedule;
  final User user;
  final VoidCallback? onTap;
  final double? itemExtent;
  SimpleCallGridTile(
      {Key? key,
      required this.schedule,
      required this.user,
      this.onTap,
      this.itemExtent})
      : super(key: key);

  Widget _buildTop(BuildContext context) {
    ThemeData theme = ThemeHelper.buildMaterialAppThemeWithContext(context,
        brightness: Brightness.dark);
    return Theme(
      data: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.black38),
                child: CallLinkGridDuration(
                  duration: schedule.duration,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white, shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(180, 0, 0, 0),
                    )
                  ]),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle style =
        theme.textTheme.caption!.copyWith(color: theme.colorScheme.primary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CallLinkGridTitle(
          title: schedule.title,
          maxLines: 1,
        ),
        CallTime(
          schedule.scheduledAt,
          style: style,
          dotStyle: style,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Hero(
                    tag: "${kCallPreviewTag}_${schedule.id}",
                    child: CallThumbnail(
                      schedule.video?.display?.url,
                      height: itemExtent,
                      width: itemExtent,
                      child: _buildTop(context),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Expanded(child: _buildBottom(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CallGridDetail extends StatelessWidget {
  final Call? schedule;
  final User? user;
  final VoidCallback? onTap;
  CallGridDetail(
      {Key? key, required this.schedule, required this.user, this.onTap})
      : super(key: key);

  Widget _buildTop(BuildContext context) {
    ThemeData theme = ThemeHelper.buildMaterialAppThemeWithContext(context,
        brightness: Brightness.dark);
    return Theme(
      data: theme,
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            CallLinkGridDuration(
              duration: schedule!.duration,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white, shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(180, 0, 0, 0),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CallLinkGridTitle(title: schedule!.title),
          CallTime(schedule!.scheduledAt),
          CallLinkGridAvatar(
            name: schedule!.hostUsername,
            imageUrl: schedule!.hostImageUrl,
            onPressed: () {
              print("show profile ");
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTop(context),
          _buildBottom(context),
        ],
      ),
    );
  }
}

class CallPageTile extends StatelessWidget {
  final Call? schedule;
  final User? user;
  final VoidCallback? onTap;
  final bool? isSelected;
  final double? width;

  CallPageTile(
      {Key? key,
      this.schedule,
      this.onTap,
      this.user,
      this.isSelected,
      this.width})
      : super(key: key);

  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CallLinkDuration(
          duration: schedule!.duration,
        ),
        Expanded(child: SizedBox.expand()),
        CallLinkTitle(title: schedule!.title),
        CallLinkAvatar(
          imageUrl: schedule!.hostImageUrl,
          name: schedule!.hostUsername,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseCallLinkPageTile(
      child: CallGridDetail(
        schedule: schedule,
        user: user,
      ),
      imageUrl: schedule?.video?.thumbnail?.url,
      onTap: onTap,
      isSelected: isSelected,
      width: width,
    );
  }
}

//BaseCallLinkPageTile
class _FadingFlexContent extends StatelessWidget {
  final Widget? child;
  final int? flex;
  final bool isVisible;
  final bool enableAnimations;

  const _FadingFlexContent(
      {Key? key,
      this.child,
      this.flex,
      this.isVisible = true,
      this.enableAnimations = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isVisible == false) return Container();
    int targetFlex = 1 + flex! * 100;
    if (enableAnimations) {
      return TweenAnimationBuilder<double>(
          curve: !isVisible ? Curves.easeOut : Curves.easeIn,
          tween:
              Tween<double>(begin: isVisible ? 1 : 0, end: isVisible ? 1 : 0),
          duration: (isVisible ? .5 : .2).seconds,
          builder: (_, value, child) {
            if (value == 0 && !isVisible) return Container();
            return child!
                .opacity(value)
                .expanded(flex: (targetFlex * value).round());
//
          },
          child: Container(child: child, alignment: Alignment.centerLeft));
    }

    return Container(
      child: child,
      alignment: Alignment.centerLeft,
    ).expanded(flex: targetFlex);
  }
}
