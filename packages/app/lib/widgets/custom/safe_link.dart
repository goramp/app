import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class SafeLink extends StatelessWidget {
  /// Called at build time to construct the widget tree under the link.
  final LinkWidgetBuilder builder;

  /// The destination that this link leads to.
  final Uri? uri;

  /// The target indicating where to open the link.
  final LinkTarget target;

  /// Whether the link is disabled or not.
  bool get isDisabled => uri == null;

  /// Creates a widget that renders a real link on the web, and uses WebViews in
  /// native platforms to open links.
  SafeLink({
    Key? key,
    required this.uri,
    this.target = LinkTarget.defaultTarget,
    required this.builder,
  });

  @override
  build(BuildContext context) {
    // if (UniversalPlatform.isWeb && !isDesktopBrowser() && isSafariBrowser()) {
    //   return builder(context, () async {
    //     launch(uri.toString());
    //   });
    // }
    return Link(uri: uri, target: target, builder: builder);
  }
}
