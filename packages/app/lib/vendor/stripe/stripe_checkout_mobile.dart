import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goramp/models/checkout.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _kCheckoutHtml = '''
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script src="https://js.stripe.com/v3/"></script>
  </head>
  <body/>
</html>
''';

void redirectToCheckout(BuildContext context, Checkout checkout,
    {VoidCallback? onSuccess, VoidCallback? onCancel, String? title}) async {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckoutPage(
      checkout: checkout,
      onSuccess: onSuccess,
      onCancel: onCancel,
      title: title,
    ),
    fullscreenDialog: true,
  ));
}

class CheckoutPage extends StatefulWidget {
  final Checkout? checkout;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;
  final String? title;

  const CheckoutPage(
      {Key? key,
      this.checkout,
      this.onSuccess,
      this.onCancel,
      this.title = 'Checkout'})
      : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late WebViewController _webViewController;
  String? _initialUrl;
  ValueNotifier<bool> _loader = ValueNotifier<bool>(false);
  ValueNotifier<String?>? _url;

  @override
  void initState() {
    _initialUrl = Uri.dataFromString(
      _kCheckoutHtml,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf8'),
    ).toString();
    _url = ValueNotifier<String?>(_initialUrl);
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
          title: Text(
            widget.title!,
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: _initialUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (webViewController) {
                _webViewController = webViewController;
              },
              onPageFinished: (String url) {
                if (url == _initialUrl) {
                  _redirectToStripe(widget.checkout!.id);
                }
                _loader.value = false;
              },
              navigationDelegate: (NavigationRequest request) async {
                if (request.url.startsWith(widget.checkout!.successUrl!)) {
                  Navigator.of(context).pop();
                  widget.onSuccess?.call();
                } else if (request.url
                    .startsWith(widget.checkout!.cancelUrl!)) {
                  Navigator.of(context).pop();
                  widget.onCancel?.call();
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

  Future<void> _redirectToStripe(String? sessionId) async {
    String line = "";
    if (widget.checkout!.stripeAccountId != null) {
      line =
          'Stripe(\'${widget.checkout!.apiKey}\', {stripeAccount: \'${widget.checkout!.stripeAccountId}\'});';
    } else {
      line = 'Stripe(\'${widget.checkout!.apiKey}\');';
    }
    final redirectToCheckoutJs = '''
      var stripe = $line;
          
      stripe.redirectToCheckout({
        sessionId: '$sessionId'
      }).then(function (result) {
        result.error.message = 'Error'
      });
    ''';
    print('Pay: $redirectToCheckoutJs');
    try {
      await _webViewController.evaluateJavascript(redirectToCheckoutJs);
    } on PlatformException catch (e) {
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
  }
}
