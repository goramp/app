import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaystackCheckout extends StatefulWidget {
  const PaystackCheckout({
    this.successUrl,
    required this.paymentReference,
    this.onSuccess,
    this.onCancel,
    required this.amount,
    required this.currency,
    required this.paystackPublicKey,
    Key? key,
  }) : super(key: key);
  final String? successUrl;
  final String paystackPublicKey;
  final String paymentReference;
  final String amount;
  final String currency;
  final Function(BuildContext)? onSuccess;
  final VoidCallback? onCancel;
  @override
  _PaystackCheckoutState createState() => _PaystackCheckoutState();
}

class _PaystackCheckoutState extends State<PaystackCheckout> {
  late WebViewController _webViewController;
  ValueNotifier<bool> _loader = ValueNotifier<bool>(false);
  late String checkoutUrl;

  @override
  void initState() {
    AppConfig config = context.read();
    checkoutUrl = 'https://${config.webDomain}/payastack.html';
    if (UniversalPlatform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  Future<void> _openPaystack() async {
    final MyAppModel model = context.read();
    final openPaystackJs = '''
      var paystack = PaystackPop.setup({
        key: '${widget.paystackPublicKey}',
        amount: ${widget.amount},
        currency: ${widget.currency},
        email: "${model.currentUser!.email}",
        channels: ['bank_transfer'],
        ref: "${widget.paymentReference}", 
        metadata: {
           custom_fields: [
              {
                  userId: "${model.currentUser?.id}",
                  email: "${model.currentUser?.email}",
              }
           ]
        },
        onBankTransferConfirmationPending:  function(response){
            OnBankTransfer.postMessage(response.reference);
        },
        callback: function(response){
            OnSuccess.postMessage(response.reference);
         
        },
        onClose: function(){
            OnClose.postMessage();
          
        }
      });
      paystack.openIframe();
    ''';
    try {
      await _webViewController.evaluateJavascript(openPaystackJs);
    } on PlatformException catch (e) {
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
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
        title: InkWell(
          onTap: () => widget.onSuccess?.call(context),
          child: Text(
            'Checkout',
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: checkoutUrl,
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'OnSuccess',
                  onMessageReceived: (JavascriptMessage message) {
                    widget.onSuccess?.call(context);
                  }),
              JavascriptChannel(
                  name: 'OnClose',
                  onMessageReceived: (JavascriptMessage message) {
                    widget.onCancel?.call();
                  })
            ]),
            onWebViewCreated: (webViewController) {
              _webViewController = webViewController;
            },
            onPageFinished: (String url) {
              if (url == checkoutUrl) {
                _openPaystack();
              }
              _loader.value = false;
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
      ),
    );
  }
}
