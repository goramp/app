import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/widgets/router/routes/public_route_path.dart';
import 'package:provider/provider.dart';
import 'package:nanoid/nanoid.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/index.dart';
import '../../services/index.dart';
import '../../utils/index.dart';
import '../../app_config.dart';
import 'package:goramp/generated/l10n.dart';

const alphabet =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

class LinkHelper {
  static void sendInviteToContact(BuildContext context, String phoneNumber) {
    SendSMSPlugin.sendSMS(
        body: getPublicInviteLinkWithMessage(context),
        recipients: [phoneNumber]);
  }

  static String? generateUserInviteLink(BuildContext context) {
    AppConfig config = Provider.of<AppConfig>(context, listen: false);
    MyAppModel model = Provider.of<MyAppModel>(context);
    User? currentUser = model.currentUser;
    if (currentUser == null) {
      return null;
    }
    final String id = customAlphabet(alphabet, 10);
    // Firestore.instance.collection('invites').doc(id).setData({
    //   'createdAt': FieldValue.serverTimestamp(),
    //   'fromUserId': currentUser.id,
    //   'toUserId': null,
    //   'acceptedAt': null,
    // });
    String webLink = 'https://${config.host}/$id';
    String appLink = '${config.scheme}://${config.host}/$id';
    String link = config.useAppLink! ? appLink : webLink;
    return link;
  }

  static Future<void> shareCallLink(BuildContext context, String? linkId) {
    AppConfig config = Provider.of<AppConfig>(context, listen: false);
    String webLink = 'https://${config.webDomain}/$linkId';
    String appLink = '${config.scheme}://${config.host}/$linkId';
    String link = config.useAppLink! ? appLink : webLink;
    return Share.share(link);
  }

  static String callLink(BuildContext context, String linkId,
      {bool useAppLink = false}) {
    final path = CallLinkDetailsPath(linkId);
    AppConfig config = Provider.of<AppConfig>(context, listen: false);
    String webLink = 'https://${config.webDomain}${path.location}';
    String appLink = '${config.scheme}:/${path.location}';
    String link = useAppLink ? appLink : webLink;
    return link;
  }

  static String link(BuildContext context, String path,
      {bool useAppLink = false}) {
    AppConfig config = Provider.of<AppConfig>(context, listen: false);
    String webLink = 'https://${config.webDomain}${path}';
    String appLink = '${config.scheme}://${config.webDomain}${path}';
    String link = useAppLink ? appLink : webLink;
    return link;
  }

  static getPrivateLinkWithMessage(BuildContext context) {
    String? link = generateUserInviteLink(context);
    return '${S.of(context).hey}, ${S.of(context).add_this_on_phone_record_watch} $link';
  }

  static getPublicInviteLinkWithMessage(BuildContext context, {String? name}) {
    String? link = generateUserInviteLink(context);
    if (name != null && name.isNotEmpty) {
      return '${toTitleCase(name)}, ${S.of(context).add_this_to_phone_watch_record} $link';
    }
    return '${S.of(context).hey}, ${S.of(context).add_this_to_phone_watch_record} $link';
  }

  static void sendPrivateInvite(BuildContext context, String phoneNumber,
      {String? name}) {
    SendSMSPlugin.sendSMS(
        body: getPublicInviteLinkWithMessage(context, name: name),
        recipients: [phoneNumber]);
  }

  static void openPrivateInvite(BuildContext context) {
    SendSMSPlugin.sendSMS(
        body: getPublicInviteLinkWithMessage(context), recipients: []);
  }

  static void sharePrivateInvite(BuildContext context) {
    Share.share(getPrivateLinkWithMessage(context));
  }

  // static void handleLinkNavigation(BuildContext context, Link link) async {
  //   print("handleLinkNavigation $link");
  //   if (link == null) {
  //     return;
  //   }
  //   if (link.resourceType == LinkResourceType.event) {
  //     PagenavigationHelper.showEventPreview(
  //         context, link.userId, link.resourceId);
  //   }
  //   print("should remove link $link");
  // }
}
