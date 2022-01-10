import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:goramp/widgets/pages/wallets/crypto/buy/interface.dart' as inter;
import 'package:goramp/generated/l10n.dart';

void buyWithTransack(BuildContext context, inter.TransackOptions options,
    {VoidCallback? onSuccess, VoidCallback? onCancel}) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckoutPage(
      url: options.url,
      redirectUrl: options.redirectURL,
      onSuccess: onSuccess,
      onCancel: onCancel,
    ),
    fullscreenDialog: true,
  ));
}

void buyWithFTXPay(BuildContext context, inter.FTXOptions options,
    {VoidCallback? onSuccess, VoidCallback? onCancel}) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckoutPage(
      url: options.url,
      redirectUrl: options.redirectURL,
      onSuccess: onSuccess,
      onCancel: onCancel,
    ),
    fullscreenDialog: true,
  ));
}

void buyWithRamp(BuildContext context, inter.RampOptions options,
    {VoidCallback? onSuccess, VoidCallback? onCancel}) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckoutPage(
      url: options.url,
      redirectUrl: options.finalUrl,
      onSuccess: onSuccess,
      onCancel: onCancel,
    ),
    fullscreenDialog: true,
  ));
}

String encodeMap(Map data) {
  return data.keys
      .where((element) => data[element] != null)
      .map((key) =>
          "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key]?.toString() ?? '')}")
      .join("&");
}

class CheckoutPage extends StatefulWidget {
  //final inter.TransackOptions? options;
  final String? redirectUrl;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;
  final String? url;
  const CheckoutPage(
      {Key? key, this.url, this.redirectUrl, this.onSuccess, this.onCancel})
      : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ValueNotifier<bool> _loader = ValueNotifier<bool>(false);

  @override
  void initState() {
    if (UniversalPlatform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  Widget _buildLoader() {
    return Container(
      constraints: BoxConstraints(maxHeight: 2.0),
      child: LinearProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).checkout),
          elevation: 0,
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) {
                _loader.value = false;
              },
              navigationDelegate: (NavigationRequest request) async {
                if (widget.redirectUrl != null &&
                    request.url.startsWith(widget.redirectUrl!)) {
                  Navigator.of(context).pop();
                  widget.onSuccess?.call();
                }
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                _loader.value = true;
              },
              gestureNavigationEnabled: true,
            ),
            ValueListenableBuilder(
              valueListenable: _loader,
              builder: (context, dynamic loading, child) {
                return AnimatedSwitcher(
                  duration: kThemeAnimationDuration,
                  child: loading ? child : const SizedBox.shrink(),
                );
              },
              child: _buildLoader(),
            )
          ],
        ));
  }
}
