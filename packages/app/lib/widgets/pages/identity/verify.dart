import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/user.dart';
import 'package:browser_adapter/browser_adapter.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/identity/passbase/index.dart';
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';

// class PassbaseFooter extends StatelessWidget {
//   const PassbaseFooter();
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return CenteredWidget(
//         Container(
//           padding: EdgeInsets.all(Insets.ls),
//           margin: EdgeInsets.all(Insets.ls),
//           decoration: BoxDecoration(
//             borderRadius: kInputBorderRadius,
//             border: Border.all(
//               color: Theme.of(context).dividerColor,
//               width: 0.5, // One physical pixel.
//               style: BorderStyle.solid,
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.verify,
//                 color: Theme.of(context).textTheme.caption!.color,
//                 size: 18,
//               ),
//               HSpace(Insets.m),
//               Expanded(
//                 child: Text(
//                   "We use Passbase to verify your identity in order to commply with KYC/AML policiies.",
//                   style: Theme.of(context).textTheme.caption,
//                 ),
//               ),
//               const PlatformSvg.asset(
//       isDark
//           ? Constants.STRIPE_LOGO_WHITE_SVG
//           : Constants.STRIPE_LOGO_BLURPLE_SVG,
//       width: width,
//     ),
//             ],
//           ),
//         ),
//         maxWidth: 500);
//   }
// }

class _VerifyBtn extends StatelessWidget {
  const _VerifyBtn();
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: context.raisedStyle,
      child: Text(
        S.of(context).get_started,
      ),
      onPressed: () async {
        AppConfig config = context.read();

        MyAppModel model = context.read();
        var bytes = utf8.encode(json.encode({
          'prefill_attributes': {'email': model.currentUser?.email}
        }));
        final params = base64Encode(bytes);
        isDesktopBrowser()
            ? verifyIdentity(
                context, '${config.passbaseVerificationUrl!}?p=$params')
            : launch('${config.passbaseVerificationUrl!}?p=$params',
                webOnlyWindowName: '_self',
                forceSafariVC: true,
                forceWebView: true,
                enableJavaScript: true);
      },
    );
  }
}

class UnVerified extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const UnVerified({this.title, this.subTitle});

  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            VSpace(Insets.ls),
            Icon(
              Icons.verified_user,
              size: 96,
              color: isDark ? Colors.white38 : Colors.grey[300],
            ),
            SizedBox(
              height: 24.0,
            ),
            Text(title ?? S.of(context).verify_your_identity,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
            VSpace(Insets.ls),
            Text(
              subTitle ?? S.of(context).verify_identity_plaform_safe,
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            // ListTile(
            //   title: Text("Trust & Safety"),
            //   subtitle: Text(
            //       "Prevent bad actors, spammers, spam and fraud on our platform"),
            // ),
            // ListTile(
            //   title: Text("Regulatory Compliance"),
            //   subtitle: Text("To meet global KYC requirements"),
            // ),
            VSpace(Insets.xl),
            Center(
              child: UniversalPlatform.isWeb ? _VerifyBtn() : PassBaseButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class Verified extends StatelessWidget {
  const Verified();
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return SizedBox.expand(
      child: CenteredWidget(
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              VSpace(Insets.ls),
              Icon(
                Icons.verified_user,
                size: 96,
                color: isDark ? Colors.green[200] : Colors.green[400],
              ),
              SizedBox(
                height: 24.0,
              ),
              Text(S.of(context).identity_verified,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6),
              VSpace(Insets.ls),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).continue_string),
              ),
              VSpace(Insets.ls),
            ],
          ),
        ),
        maxWidth: 500,
      ),
    );
  }
}

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  _StripePricingState createState() => _StripePricingState();
}

class _StripePricingState extends State<Verify> {
  ValueNotifier<bool> loading = ValueNotifier<bool>(false);

  @override
  void initState() {
    //StripeService.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile =
        context.select<MyAppModel, UserProfile?>((model) => model.profile);
    Widget body;
    if (profile == null) {
      body = const FeedLoader();
    } else if (profile.kycVerified) {
      body = KeyedSubtree(
        key: ValueKey('verified'),
        child: const Verified(),
      );
    } else {
      body = KeyedSubtree(
        key: ValueKey('unverified'),
        child: UnVerified(),
      );
    }
    return Provider.value(
      value: this,
      child: AnimatedSwitcher(
        child: body,
        duration: kThemeAnimationDuration,
      ),
    );
  }
}

class VerifyPage extends StatelessWidget {
  const VerifyPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(""),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: const Verify(),
    );
  }
}
