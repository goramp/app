import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/custom/custom_popup_button.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goramp/generated/l10n.dart';

const _kIconSize = 24.0;

class ShareDescription {
  final ShareType type;
  final String? title;
  final Widget? lightIcon;
  final Widget? darkIcon;
  final String baseUrl;
  const ShareDescription(this.type, this.baseUrl,
      {this.title, this.lightIcon, this.darkIcon});
  Uri uri(String shareLink) =>
      Uri.parse('$baseUrl${Uri.encodeComponent(shareLink)}');
}

enum ShareType { twitter, facebook, whatsapp, line, linkedin, copy }
final kShareList = [
  ShareDescription(
    ShareType.copy,
    '',
    title: 'Copy',
    lightIcon: Icon(Icons.copy, size: _kIconSize),
  ),
  ShareDescription(
    ShareType.twitter,
    'https://twitter.com/intent/tweet?url=',
    title: 'Share To Twitter',
    lightIcon: PlatformSvg.asset(
      SocialIcons.TWITTER,
      width: _kIconSize,
      height: _kIconSize,
    ),
  ),
  ShareDescription(
    ShareType.facebook,
    'https://www.facebook.com/sharer/sharer.php?app_id=1430770263795705&u=',
    title: 'Share To Facebook',
    lightIcon: PlatformSvg.asset(
      SocialIcons.FACEBOOK,
      width: _kIconSize,
      height: _kIconSize,
    ),
  ),
  ShareDescription(
    ShareType.whatsapp,
    'https://api.whatsapp.com/send/?phone&text=',
    title: 'Share To WhatsApp',
    lightIcon: PlatformSvg.asset(
      SocialIcons.WHATSAPP,
      width: _kIconSize,
      height: _kIconSize,
    ),
  ),
  ShareDescription(
    ShareType.line,
    'https://line.me/R/msg/text/?',
    title: 'Share To Line',
    lightIcon: Image.asset(
      SocialIcons.LINE,
      width: _kIconSize,
      height: _kIconSize,
    ),
  ),
  ShareDescription(
    ShareType.linkedin,
    'https://www.linkedin.com/shareArticle?url=',
    title: 'Share To LinkedIn',
    lightIcon: PlatformSvg.asset(
      SocialIcons.LinkedIn,
      width: _kIconSize,
      height: _kIconSize,
    ),
  ),
];

class SharePopUpButton extends StatelessWidget {
  final String url;
  final CustomPopUpButtonBuilder? builder;
  final bool? enabled;
  SharePopUpButton(this.url, {this.builder, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return CustomPopupMenuButton(
      onSelected: (type) async {
        if (type == ShareType.copy) {
          await Clipboard.setData(ClipboardData(text: url));
          await ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).copied),
            ),
          );
        }
      },
      itemBuilder: (context) =>
          kShareList.map<PopupMenuEntry<ShareType>>((ShareDescription desc) {
        return PopupMenuItem<ShareType>(
          value: desc.type,
          child: desc.type == ShareType.copy
              ? Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  isDark ? desc.darkIcon ?? desc.lightIcon! : desc.lightIcon!,
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: Text(
                      getShareTitle(desc.title!, context)!,
                    ),
                  )
                ])
              : Link(
                  uri: desc.uri(url),
                  target: LinkTarget.blank,
                  builder: (context, onTap) {
                    return GestureDetector(
                      onTap: () {
                        //onTap();
                        launch(desc.uri(url).toString());
                        Navigator.of(context).pop();
                      },
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            isDark
                                ? desc.darkIcon ?? desc.lightIcon!
                                : desc.lightIcon!,
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Text(
                                getShareTitle(desc.title!, context)!,
                              ),
                            )
                          ]),
                    );
                  },
                ),
        );
      }).toList(),
      buttonBuilder: builder ??
          (context, onTap) {
            final buttonStyle = OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: kInputBorderRadius,
              ),
            );
            return OutlinedButton.icon(
              style: buttonStyle,
              icon: Icon(
                CupertinoIcons.arrowshape_turn_up_right,
              ),
              label: Text(
                S.of(context).share,
              ),
              onPressed: enabled! ? onTap : null,
            );
          },
    );
  }
}

class ShareLinks extends StatelessWidget {
  final String url;
  final ButtonStyle style = TextButton.styleFrom(
    elevation: 0,
    primary: Colors.transparent,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: CircleBorder(),
  );
  ShareLinks(this.url);

  Widget _buildShareLink(BuildContext context, ShareDescription description) {
    final theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Link(
      uri: description.uri(url),
      target: LinkTarget.blank,
      builder: (context, onTap) {
        return Tooltip(
          message: getShareTitle(description.title!, context)!,
          child: InkWell(
            onTap: onTap,
            child: isDark
                ? description.darkIcon ?? description.lightIcon
                : description.lightIcon,
            borderRadius: BorderRadius.circular(_kIconSize),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final widgets = [
      ...kShareList.map(
        (item) => Padding(
          child: _buildShareLink(context, item),
          padding: EdgeInsets.only(left: 8.0),
        ),
      )
    ];
    return Container(
      height: 32,
      child: Row(
        children: [
          Text(
            S.of(context).share_to,
            style: theme.textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.caption!.color),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: widgets,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String? getShareTitle(String title, BuildContext context) {
  if (title == 'Share To Twitter') return S.of(context).share_to_twitter;
  if (title == 'Share To Facebook') return S.of(context).share_to_facebook;
  if (title == 'Share To WhatsApp') return S.of(context).share_to_whatsapp;
  if (title == 'Share To Line') return S.of(context).share_to_line;
  if (title == 'Share To LinkedIn') return S.of(context).share_to_linkedln;
  if (title == 'Copy') return S.of(context).copy_link;
}
