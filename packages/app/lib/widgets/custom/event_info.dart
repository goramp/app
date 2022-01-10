import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/widgets/custom/circle_popup_button.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:browser_adapter/browser_adapter.dart';
import '../../app_config.dart';
import '../../models/index.dart';
import '../../services/index.dart';
import '../../utils/index.dart';
import 'package:goramp/generated/l10n.dart';

enum CallLinkOptions { edit, delete, activate, cancel, report, qr }

const kInfoRadius = const BorderRadius.all(Radius.circular(4.0));
const kInfoPadding = 12.0;
const kInfoAllPadding = EdgeInsets.all(kInfoPadding);

const List<Shadow> kInfoShadow = const [
  Shadow(
    blurRadius: 3.0,
    color: Color.fromRGBO(0, 0, 0, 0.45),
  )
];

class LikeButton extends StatelessWidget {
  final CallLink? callLink;
  LikeButton(this.callLink);
  @override
  Widget build(BuildContext context) {
    MyAppModel model = Provider.of<MyAppModel>(context);
    User? user = model.currentUser;
    if (user == null) return const SizedBox.shrink();
    return StreamBuilder(
      stream: CallLinkService.userLikedCallLinkStream(callLink!.id, user.id),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) return SizedBox.shrink();
        bool liked = snapshot.hasData ? snapshot.data! : false;
        final icon = liked ? Icons.favorite : Icons.favorite_outline_outlined;
        return TextButton(
          style: context.roundedButtonStyle,
          child: SizedBox(
            width: 48.0,
            height: 48.0,
            child: Center(
              child: AnimatedSwitcher(
                duration: kThemeAnimationDuration,
                child: IconS(
                  icon,
                  shadows: ICON_SHADOW,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onPressed: snapshot.hasData
              ? () {
                  CallLinkService.updateLike(user.id, callLink!, like: !liked);
                }
              : null,
        );
      },
    );
  }
}

class ShareButton extends StatelessWidget {
  final CallLink callLink;
  ShareButton(this.callLink);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: context.roundedButtonStyle,
      child: SizedBox(
        width: 48.0,
        height: 48.0,
        child: Center(
          child: IconS(
            Icons.share_outlined,
            shadows: ICON_SHADOW,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        LinkHelper.shareCallLink(context, callLink.linkId);
      },
    );
  }
}

class CallLinkPublisher extends StatelessWidget {
  final CallLink callLink;
  CallLinkPublisher(this.callLink);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: callLink,
      stream: CallLinkService.getCallLinkStream(callLink.id),
      builder: (BuildContext context, AsyncSnapshot<CallLink> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        CallLink newCallLink = snapshot.data!;
        return CallLinkInfoTop(
          newCallLink.hostId,
          newCallLink.hostUsername,
          hostImageUrl: newCallLink.hostImageUrl,
        );
      },
    );
  }
}

class CallMoreButton extends StatelessWidget {
  final bool isHost;
  final VoidCallback? onCancel;
  final VoidCallback? onReport;

  CallMoreButton({this.isHost = false, this.onCancel, this.onReport});

  Widget build(BuildContext context) {
    return CirclePopupMenuButton<CallLinkOptions>(
      icon: Icon(Icons.more_horiz, color: Colors.white),
      offset: Offset(0, -56),
      onSelected: (CallLinkOptions result) {
        if (result == CallLinkOptions.cancel) {
          if (onCancel != null) {
            onCancel!();
          }
        } else if (result == CallLinkOptions.report) {
          if (onReport != null) {
            onReport!();
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<CallLinkOptions>>[
        PopupMenuItem<CallLinkOptions>(
          value: CallLinkOptions.cancel,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.cancel,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                S.of(context).cancel,
              )
            ],
          ),
        ),
        if (!isHost)
          PopupMenuItem<CallLinkOptions>(
            value: CallLinkOptions.report,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.flag,
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

class CallLinkMoreButton extends StatelessWidget {
  final bool isPublisher;
  final ValueChanged<CallLinkOptions>? onChanged;
  CallLinkMoreButton({this.onChanged, this.isPublisher = false});

  Widget build(BuildContext context) {
    return CirclePopupMenuButton<CallLinkOptions>(
      icon: IconS(
        Icons.more_horiz,
        shadows: ICON_SHADOW,
        color: Colors.white,
      ),
      onSelected: this.onChanged,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<CallLinkOptions>>[
        if (isPublisher)
          PopupMenuItem<CallLinkOptions>(
            value: CallLinkOptions.edit,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.create,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  S.of(context).edit,
                ),
              ],
            ),
          ),
        // PopupMenuItem<CallLinkOptions>(
        //   value: CallLinkOptions.qr,
        //   child: Row(
        //     children: <Widget>[
        //       Icon(Icons.qr_code_outlined),
        //       SizedBox(
        //         width: 8.0,
        //       ),
        //       Text(
        //         "Show QR code",
        //       )
        //     ],
        //   ),
        // ),
        if (isPublisher)
          PopupMenuItem<CallLinkOptions>(
            value: CallLinkOptions.delete,
            child: Row(
              children: <Widget>[
                Icon(Icons.delete_outline_outlined),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  S.of(context).delete,
                )
              ],
            ),
          ),
        if (!isPublisher)
          PopupMenuItem<CallLinkOptions>(
            value: CallLinkOptions.report,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.flag_outlined,
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

class CallLinkInfoClose extends StatelessWidget {
  final VoidCallback onClose;
  CallLinkInfoClose(this.onClose);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: getExtraPadding(),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 56.0,
              height: 56.0,
              child: IconButton(
                color: Colors.white,
                icon: IconS(
                  Icons.close_outlined,
                  shadows: ICON_SHADOW,
                ),
                iconSize: 32.0,
                onPressed: onClose,
              ),
            ),
          ],
        ),
        alignment: Alignment.topRight,
      ),
    );
  }
}

class DurationInfo extends StatelessWidget {
  final Duration? duration;
  final TextStyle? style;
  DurationInfo(this.duration, {this.style});
  @override
  Widget build(BuildContext context) {
    return Text(
      '${duration?.inMinutes} ${S.of(context).mins}',
      style: style ?? Theme.of(context).textTheme.bodyText1,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class PriceInfo extends StatelessWidget {
  final String? price;
  final int? decimals;
  final String? currency;
  final TextStyle? style;
  final String? paymentTerms;
  final TextAlign? textAlign;
  PriceInfo({
    this.style,
    this.paymentTerms,
    this.price,
    this.currency,
    this.textAlign,
    this.decimals,
  });

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (price == null || price == 0) {
      body = Text(
        S.of(context).free,
        style: style ?? Theme.of(context).textTheme.bodyText1,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      );
    } else {
      body = CurrencyPriceItem(
        price!,
        currency!,
        decimals!,
        (context, val) => Text(
          val,
          style: style ?? Theme.of(context).textTheme.bodyText1,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
        ),
      );
    }
    if (paymentTerms != null && paymentTerms!.isNotEmpty) {
      body = Tooltip(
        message: paymentTerms!,
        child: body,
        margin: EdgeInsets.all(kInfoPadding),
        padding: EdgeInsets.all(kInfoPadding),
      );
    }
    return body;
  }
}

class PublisherInfo extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final String? userId;
  final TextStyle? style;
  final bool showImage;
  final bool? verified;
  final VoidCallback? onPress;
  PublisherInfo(this.userId, this.userName,
      {this.imageUrl,
      this.style,
      this.showImage = true,
      this.onPress,
      this.verified = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = style ??
        theme.textTheme.bodyText1!.copyWith(
          color: Colors.white,
          shadows: kInfoShadow,
        );

    bool isDark = theme.brightness == Brightness.dark;
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
      ),
    );
    return TextButton(
      style: buttonStyle,
      onPressed: onPress,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (showImage)
            SizedBox(
              width: 32,
              height: 32,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor:
                        isDark ? theme.canvasColor : Colors.grey[200],
                    backgroundImage: imageUrl != null
                        ? CachedNetworkImageProvider(imageUrl!)
                        : null,
                    child: imageUrl != null
                        ? null
                        : Icon(
                            Icons.person_outline,
                            color: theme.colorScheme.primary,
                            size: 16.0,
                          ),
                  ),
                  if (verified != null && verified!)
                    VeirifedBadge(
                      size: 12,
                    )
                ],
              ),
            ),
          if (showImage)
            SizedBox(
              width: 8.0,
            ),
          Text(
            userName ?? '',
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Icon(
            Icons.chevron_right_outlined,
            color: textStyle.color,
            size: 18,
          ),
          if (showImage)
            SizedBox(
              width: 8.0,
            ),
        ],
      ),
    );
  }
}

class TitleInfo extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final int? maxLines;
  TitleInfo(this.title, {this.style, this.maxLines});
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      child: SelectableText(title,
          maxLines: maxLines,
          // overflow: TextOverflow.ellipsis,
          style: style ??
              Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(
                    fontWeight: FontWeight.bold,
                    //fontSize: 24,
                  )
                  .withCanvaskitFontFix),
    );
  }
}

class CallLinkLinkButton extends StatefulWidget {
  final CallLink callLink;
  CallLinkLinkButton(this.callLink, {Key? key}) : super(key: key);
  @override
  _CallLinkShareButtonState createState() => _CallLinkShareButtonState();
}

class _CallLinkShareButtonState extends State<CallLinkLinkButton> {
  final ValueNotifier<bool> _activating = ValueNotifier<bool>(false);

  Future<void> _generateLink(BuildContext context) async {
    try {
      if (_activating.value) {
        return;
      }
      _activating.value = true;
      if (widget.callLink.linkId != null) {
        await LinkHelper.shareCallLink(context, widget.callLink.linkId);
        return;
      }
      AppConfig config = Provider.of<AppConfig>(context, listen: false);
      final url = "${config.baseApiUrl}/events/${widget.callLink.id}/link";
      Link link = await LinkService.generateLink(url);
      await LinkHelper.shareCallLink(context, link.id);
    } on ConnectionException catch (error) {
      print('error ${error}');
      AlertHelper.showErrorLight(context,
          description: CONNECTION_ERROR_MESSAGE);
    } on SocketException catch (error) {
      print('error ${error}');
      AlertHelper.showErrorLight(context,
          description: CONNECTION_ERROR_MESSAGE);
    } on HandshakeException catch (error) {
      print('error ${error}');
      AlertHelper.showErrorLight(context,
          description: CONNECTION_ERROR_MESSAGE);
    } on TimeoutException catch (error) {
      print('error ${error}');
      AlertHelper.showErrorLight(context,
          description: CONNECTION_ERROR_MESSAGE);
    } catch (error, stacktrace) {
      print('error ${error}');
      ErrorHandler.report(error, stacktrace);
      AlertHelper.showErrorLight(context,
          description: S.of(context).default_error_title2);
    } finally {
      _activating.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // theme.outlinedButtonTheme.style.copyWith(shadowColor: Col),
    return OutlinedButton(
      child: ValueListenableBuilder(
        builder: (BuildContext context, bool value, Widget? child) {
          return AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: value
                      ? PlatformCircularProgressIndicator(
                          theme.colorScheme.onBackground)
                      : isDark
                          ? const IconS(
                              Icons.share_outlined,
                              shadows: ICON_SHADOW,
                            )
                          : const Icon(
                              Icons.share_outlined,
                            ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  S.of(context).share,
                  style: theme.textTheme.button!
                      .copyWith(shadows: isDark ? ICON_SHADOW : []),
                ),
              ],
            ),
          );
        },
        valueListenable: _activating,
      ),
      onPressed: () => _generateLink(context),
    );
  }
}

class CallLinkButtons extends StatelessWidget {
  final CallLink? callLink;
  final User? user;
  CallLinkButtons({
    this.user,
    this.callLink,
  });

  bool get isPublisher => callLink!.hostId == user?.id;

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // if (!isPublisher)
        //   SizedBox(
        //     width: 56,
        //     height: 56.0,
        //     child: Center(
        //       child: ShareButton(callLink),
        //     ),
        //   ),
        // if (!isPublisher) HSpace(Insets.m),
        if (!isPublisher && user != null && !user!.isAnonymous)
          SizedBox(
            width: 56,
            height: 56.0,
            child: Center(
              child: LikeButton(callLink),
            ),
          ),
      ],
    );
  }
}

class CallLinkPaymentTermsView extends StatefulWidget {
  final CallLink? callLink;

  CallLinkPaymentTermsView({this.callLink});

  @override
  _CallLinkPaymentTermsState createState() => _CallLinkPaymentTermsState();
}

class _CallLinkPaymentTermsState extends State<CallLinkPaymentTermsView> {
  bool _showFullText = false;

  bool get canShowFullText {
    final txt = widget.callLink!.paymentTerms ?? '';
    return txt.length > 300;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ButtonStyle style = TextButton.styleFrom(
        primary: theme.textTheme.caption!.color,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        textStyle:
            theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.callLink!.paymentTerms!,
          maxLines: _showFullText ? null : 3,
          overflow: TextOverflow.fade,
        ),
        if (canShowFullText) ...[
          VSpace(Insets.sm),
          TextButton(
            onPressed: () {
              setState(() {
                _showFullText = !_showFullText;
              });
            },
            child: SelectableText(
              _showFullText ? S.of(context).show_less : S.of(context).show_more,
            ),
            style: style,
          )
        ]
      ],
    );
  }
}

class CallLinkNotesView extends StatefulWidget {
  final CallLink? callLink;

  CallLinkNotesView({this.callLink});

  @override
  _CallLinkNotesViewState createState() => _CallLinkNotesViewState();
}

class _CallLinkNotesViewState extends State<CallLinkNotesView> {
  bool _showFullText = false;

  bool get canShowFullText {
    final txt = widget.callLink!.notes ?? '';
    return txt.length > 300;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ButtonStyle style = TextButton.styleFrom(
        primary: theme.textTheme.caption!.color,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        textStyle:
            theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.callLink!.notes!,
          maxLines: _showFullText ? null : 3,
          overflow: TextOverflow.fade,
        ),
        if (canShowFullText) ...[
          VSpace(Insets.sm),
          TextButton(
            onPressed: () {
              setState(() {
                _showFullText = !_showFullText;
              });
            },
            child: SelectableText(
              _showFullText ? S.of(context).show_less : S.of(context).show_more,
            ),
            style: style,
          )
        ]
      ],
    );
  }
}

class CallLinkDetailsInfo extends StatelessWidget {
  final CallLink? callLink;
  final TextStyle? style;
  final bool showCount;
  CallLinkDetailsInfo({this.callLink, this.style, this.showCount = false});

  bool isPublisher(User user) => callLink!.hostId == user.id;

  Widget _buildDot(BuildContext context) {
    return Icon(MdiIcons.circleSmall,
        size: 16, color: Theme.of(context).textTheme.caption!.color);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Theme.of(context).textTheme.caption;
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (callLink!.duration != null)
            DurationInfo(
              callLink!.duration,
              style: textStyle,
            ),
          if (callLink!.price != null) _buildDot(context),
          if (callLink!.price != null)
            Expanded(
              child: PriceInfo(
                price: callLink!.price,
                currency: callLink!.currency,
                style: textStyle,
                paymentTerms: callLink!.paymentTerms,
                decimals: callLink!.decimals,
              ),
            )
        ]);
  }
}

class CallLinkInfoTop extends StatelessWidget {
  final String? hostId;
  final String? hostUsername;
  final String? hostImageUrl;

  CallLinkInfoTop(this.hostId, this.hostUsername, {this.hostImageUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: kInfoAllPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                PublisherInfo(
                  hostId,
                  hostUsername,
                  imageUrl: hostImageUrl,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 56.0,
          width: 56.0,
        ),
      ],
    );
  }
}

class PublishButton extends StatelessWidget {
  final CallLink callLink;

  PublishButton(
    this.callLink,
  );

  Future<bool?> showPublishDialog(BuildContext context, bool publish) async {
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subtitle1!
        .copyWith(color: theme.textTheme.caption!.color);
    final TextStyle? dialogTitleTextStyle = theme.textTheme.headline6;
    final titleText = publish
        ? S.of(context).publish_call_link
        : S.of(context).unpublish_call_link;
    final subText = publish
        ? "${S.of(context).call_link_live} "
        : "${S.of(context).call_link_not_visible}";

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText, style: dialogTitleTextStyle),
          content: Text(subText, style: dialogTextStyle),
          actions: <Widget>[
            TextButton(
                child: Text(S.of(context).cancel),
                onPressed: () {
                  Navigator.of(context).pop(
                      false); // Pops the confirmation dialog but not the page.
                }),
            TextButton(
              child: Text(
                  publish ? S.of(context).publish : S.of(context).unpublish),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Returning true to _onWillPop will pop again.
              },
            )
          ],
        );
      },
    );
  }

  void _publish(
    BuildContext context,
    bool publish,
  ) async {
    bool? canShow = await showPublishDialog(context, publish);
    if (canShow != null && canShow) {
      CallLinkService.publish(callLink, publish: publish);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder(
      initialData: callLink,
      stream: CallLinkService.getCallLinkStream(callLink.id),
      builder: (BuildContext context, AsyncSnapshot<CallLink> snapshot) {
        bool isPublished = snapshot.data!.published!;
        final style = OutlinedButton.styleFrom(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: kInputBorderRadius,
          ),
        );

        return OutlinedButton(
          style: style,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.upload_rounded),
                  HSpace(Insets.m),
                  Text(
                      //isPublished ? 'Unpublish' : 'Publish',
                      S.of(context).published),
                ],
              ),
              Row(
                children: [
                  Text(
                    isPublished ? S.of(context).yes : S.of(context).no,
                    style: theme.textTheme.caption,
                  ),
                  HSpace(Insets.m),
                  Switch(
                    value: isPublished,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (bool published) => _publish(context, published),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              )
            ],
          ),
          onPressed: () => _publish(context, !isPublished),
        );
        // return SwitchListTile(
        //   // tileColor: theme.canvasColor,
        //   selected: isPublished,
        //   selectedTileColor: theme.selectedRowColor,

        //   shape: RoundedRectangleBorder(
        //     borderRadius: kInputBorderRadius,
        //     side: BorderSide(
        //       color:
        //           isPublished ? theme.colorScheme.primary : theme.dividerColor,
        //       width: 1.0,
        //     ),
        //   ),
        //   title: Text(
        //     'Publish',
        //     maxLines: 1,
        //     overflow: TextOverflow.ellipsis,
        //     style: theme.textTheme.subtitle1
        //         .copyWith(color: theme.colorScheme.primary),
        //   ),
        //   contentPadding:
        //       EdgeInsets.only(left: 16.0, right: 0.0, top: 0.0, bottom: 0.0),
        //   value: isPublished,
        //   activeColor: theme.colorScheme.primary,
        //   onChanged: (bool published) {
        //     CallLinkService.publish(callLink, publish: published);
        //   },
        // );
      },
    );
  }
}
