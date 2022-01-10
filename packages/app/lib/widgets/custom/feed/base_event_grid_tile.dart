import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:goramp/bloc/index.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../services/index.dart';
import '../../../widgets/index.dart';
import '../../helpers/index.dart';
import '../../../models/index.dart';
import '../../utils/index.dart';

enum CallLinkGridMoreOptions { delete, report, edit, share }

class CallLinkGridThumbnail extends StatelessWidget {
  final String? imageUrl;
  final String? blurHash;

  CallLinkGridThumbnail({this.imageUrl, this.blurHash});
  @override
  Widget build(BuildContext context) {
    ;
    return SizedBox.expand(
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: blurHash != null
            ? (context, url) => BlurHash(hash: blurHash!)
            : null,
      ),
    );
  }
}

class CallLinkGridAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final VoidCallback? onPressed;
  final bool showIcon;
  final TextStyle? style;
  CallLinkGridAvatar(
      {this.name,
      this.imageUrl,
      this.onPressed,
      this.showIcon = true,
      this.style});
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);
    return CupertinoButton(
      color: Colors.transparent,
      minSize: 24.0,
      onPressed: onPressed,
      padding: EdgeInsets.all(0.0),
      borderRadius: BorderRadius.circular(24.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // if (showIcon)
            //   SizedBox(
            //     width: 8.0,
            //   ),
            if (showIcon)
              SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.surface,
                  backgroundImage: imageUrl != null
                      ? CachedNetworkImageProvider(imageUrl!)
                      : null,
                  child: imageUrl != null
                      ? null
                      : Icon(
                          Icons.person_outline,
                          size: 12.0,
                        ),
                ),
              ),
            if (name != null && showIcon)
              SizedBox(
                width: 8.0,
              ),
            if (name != null)
              Text(
                ReCase(name?.toLowerCase() ?? '').titleCase,
                style: style ??
                    (isDesktop
                        ? theme.textTheme.bodyText2
                        : theme.textTheme.caption),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (name != null)
              SizedBox(
                width: 8.0,
              ),
          ],
        ),
      ),
    );
  }
}

class CallLinkGridTitle extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final int maxLines;
  CallLinkGridTitle({this.title, this.style, this.maxLines = 2});

  Widget build(BuildContext context) {
    return Text(
      ReCase(title?.toLowerCase() ?? '').titleCase,
      style:
          style ?? Theme.of(context).textTheme.subtitle1!.withCanvaskitFontFix,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class CallLinkCount extends StatelessWidget {
  final String? text;
  final Icon? icon;
  final Stream<Counter>? counterStream;
  final TextStyle? style;
  CallLinkCount({this.text, this.icon, this.counterStream, this.style});

  Widget _buildCount(BuildContext context, String? text) {
    return Row(
      children: <Widget>[
        if (icon != null) icon!,
        if (icon != null)
          const SizedBox(
            width: 4.0,
          ),
        if (text != null)
          Expanded(
            child: Text(
              text,
              style: style ?? Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
      ],
    );
  }

  Widget build(BuildContext context) {
    if (counterStream != null)
      return StreamBuilder(
        stream: counterStream,
        builder: (BuildContext context, AsyncSnapshot<Counter> snapshot) {
          int? count = snapshot.hasData ? snapshot.data!.count : 0;
          final format = NumberFormat.compact();
          return AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            child: _buildCount(context, "${format.format(count)} $text"),
          );
        },
      );
    return _buildCount(context, text);
  }
}

class CallLinkGridDuration extends StatelessWidget {
  final Duration? duration;
  final TextStyle? style;
  CallLinkGridDuration({this.duration, this.style});

  Widget build(BuildContext context) {
    return Text(
      '${duration?.inMinutes} ${S.of(context).mins}',
      style: style ?? Theme.of(context).textTheme.bodyText1,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class CallLinkGridPrice extends StatelessWidget {
  final double? price;

  CallLinkGridPrice({this.price});

  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    return Text(
      '${formatter.format(price)}',
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
    );
  }
}

class CallLinkGridMoreButton extends StatelessWidget {
  final VoidCallback? onReport;
  final CallLink event;
  CallLinkGridMoreButton(this.event, {this.onReport});

  Widget build(BuildContext context) {
    // ignore: close_sinks
    MyAppModel model = Provider.of<MyAppModel>(context);
    User currentUser = model.currentUser!;
    bool isOwner = currentUser.id == event.hostId;
    return PopupMenuButton<CallLinkGridMoreOptions>(
      child: Icon(Icons.more_horiz),
      padding: EdgeInsets.zero,
      onSelected: (CallLinkGridMoreOptions result) {
        if (result == CallLinkGridMoreOptions.report) {
          if (onReport != null) {
            onReport!();
          }
        }
      },
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<CallLinkGridMoreOptions>>[
        PopupMenuItem<CallLinkGridMoreOptions>(
          value: CallLinkGridMoreOptions.edit,
          child: Row(
            children: <Widget>[
              Icon(
                MdiIcons.shareOutline,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                S.of(context).share,
              )
            ],
          ),
        ),
        if (isOwner)
          PopupMenuItem<CallLinkGridMoreOptions>(
            value: CallLinkGridMoreOptions.edit,
            child: Row(
              children: <Widget>[
                Icon(
                  MdiIcons.pencilOutline,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  S.of(context).edit,
                )
              ],
            ),
          ),
        if (isOwner)
          PopupMenuItem<CallLinkGridMoreOptions>(
            value: CallLinkGridMoreOptions.delete,
            child: Row(
              children: <Widget>[
                Icon(
                  MdiIcons.trashCanOutline,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  S.of(context).delete,
                )
              ],
            ),
          ),
        if (!isOwner)
          PopupMenuItem<CallLinkGridMoreOptions>(
            value: CallLinkGridMoreOptions.report,
            child: Row(
              children: <Widget>[
                Icon(
                  MdiIcons.flag,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  S.of(context).report,
                )
              ],
            ),
          ),
      ],
    );
  }
}

class CallLinkGridDetail extends StatelessWidget {
  final CallLink event;
  final bool showOwnerUserInfo;
  final bool showStats;
  CallLinkGridDetail(
      {Key? key,
      required this.event,
      this.showStats = false,
      this.showOwnerUserInfo = true})
      : super(key: key);

  Widget _buildTop(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CallLinkGridDuration(
          duration: event.duration,
        ),
        // CallLinkGridPrice(
        //   price: 100,
        // )
      ],
    );
  }

  Widget _buildCounts(BuildContext context) {
    return CallLinkCount(
      text: "${event.schedulesCount ?? 0} ${S.of(context).schedules}",
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: CallLinkGridTitle(title: event.title),
            ),
            // SizedBox(
            //   width: 8.0,
            // ),
            //CallLinkGridMoreButton(event)
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        if (showStats) _buildCounts(context),
        // if (showOwnerUserInfo)
        //   CallLinkGridAvatar(
        //     imageUrl: event.hostImageUrl,
        //     name: event.hostUsername,
        //   ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
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

class CallLinkGridCaption extends StatelessWidget {
  final CallLink? event;
  final bool showOwnerUserInfo;
  CallLinkGridCaption({Key? key, this.event, this.showOwnerUserInfo = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      width: double.infinity,
      padding: EdgeInsets.all(4.0),
      child: CallLinkGridTitle(
        title: event!.title,
        style: Theme.of(context).textTheme.caption!.withCanvaskitFontFix,
      ),
    );
  }
}

class CallLinkGridTile extends StatelessWidget {
  final CallLink? event;
  final VoidCallback? onTap;
  final bool showOwnerUserInfo;
  CallLinkGridTile(
      {Key? key, this.event, this.onTap, this.showOwnerUserInfo = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: CallLinkGridThumbnail(
                imageUrl: event!.video?.thumbnail?.url,
              ),
            ),
            // Container(
            //   child: CallLinkGridDetail(event: event),
            //   padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            // )
          ],
        ),
      ),
    );
  }
}

typedef ModelChange<T> = void Function(T before, T after);

class ProxyChangeCallLinkGridTile extends StatelessWidget {
  final CallLink event;
  final User? user;
  final VoidCallback? onTap;
  final ModelChange<CallLink?> onChanged;

  ProxyChangeCallLinkGridTile(
      {Key? key,
      required this.event,
      required this.user,
      required this.onChanged,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CallLink?>(
      initialData: event,
      stream: CallLinkService.getCallLinkStream(event.id),
      builder: (
        BuildContext context,
        AsyncSnapshot<CallLink?> snapshot,
      ) {
        CallLink? update = snapshot.data; //@todo use empty content view
        if (update != event) {
          onChanged(event, update);
        }
        if (update == null) {
          return SizedBox.shrink();
        }
        return SimpleCallLinkGridTile(
          event: update,
          user: user,
          onTap: onTap,
        );
      },
    );
  }
}

class SimpleCallLinkGridTile extends StatelessWidget {
  final CallLink event;
  final User? user;
  final VoidCallback? onTap;
  SimpleCallLinkGridTile(
      {Key? key, required this.event, required this.user, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeHelper.buildMaterialAppThemeWithContext(context,
        brightness: Brightness.dark);
    return Theme(
      data: theme,
      child: Container(
        color: theme.canvasColor,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: "${kCallLinkPreviewTag}_${event.id}",
              child: CallLinkGridThumbnail(
                imageUrl: event.video?.captionThumbnailUrl,
              ),
            ),
            Material(
              color: Colors.black45,
              child: InkWell(
                onTap: onTap,
              ),
            ),
            IgnorePointer(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: CallLinkGridDetail(
                  event: event,
                  showOwnerUserInfo: user?.id != event.hostId,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
