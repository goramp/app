import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/utils/functions.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/cluster.dart';
import 'package:goramp/widgets/pages/wallets/crypto/detail.dart';
import 'package:goramp/widgets/pages/wallets/crypto/wallet_security.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:goramp/generated/l10n.dart';

Widget _showToast(BuildContext context, String text) {
  final theme = Theme.of(context);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    margin: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: theme.snackBarTheme.backgroundColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check,
          color: theme.snackBarTheme.contentTextStyle!.color,
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(
          text,
          style: theme.snackBarTheme.contentTextStyle,
        ),
      ],
    ),
  );
}

void showDepositDialog(BuildContext context, TokenAccount tokenAccount,
    {String amount = "", bool isTopUp = false}) async {
  final data = tokenAccount.walletAddress;
  final qrCode = QrCode(4, QrErrorCorrectLevel.L);
  qrCode.addData(data);
  qrCode.make();
  final fToast = FToast();
  fToast.init(context);
  await showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            isTopUp
                ? Text(
                    '${toTitleCase(S.of(context).top_up)} ${tokenAccount.token!.tokenSymbol}')
                : Text(
                    '${S.of(context).deposit} ${tokenAccount.token!.tokenSymbol}'),
            const ClusterChip(),
          ]),
          //contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
          content: Scrollbar(
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: _QRAddress(
                      qrCode,
                      size: 250,
                    ),
                    height: 250,
                    width: 250,
                  ),
                  ListTile(
                    minLeadingWidth: 32.0,
                    leading: SizedBox(
                      height: 40.0,
                      width: 32.0,
                      child: Center(
                        child: SizedBox(
                          height: 32.0,
                          width: 32.0,
                          child: PlatformSvg.asset(
                            tokenAccount.token!.icon!,
                            height: 32.0,
                            width: 32.0,
                          ),
                        ),
                      ),
                    ),
                    title: isTopUp
                        ? Text(
                            S.of(context).amount,
                            style: theme.textTheme.caption,
                          )
                        : Text(
                            '${tokenAccount.token!.tokenName}',
                          ),
                    subtitle: isTopUp
                        ? SelectableText(
                            '$amount ${tokenAccount.token!.tokenSymbol}',
                            style: theme.textTheme.subtitle1,
                          )
                        : null,
                    trailing: tokenAccount.token?.canBuy ?? false
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 28,
                                child: ElevatedButton(
                                  style: TextButton.styleFrom(
                                    elevation: 0,
                                    // primary: theme.colorScheme.primary,
                                    //backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: StadiumBorder(),
                                  ),
                                  child: Text(
                                    S.of(context).buy,
                                  ),
                                  onPressed: () {
                                    WalletHelper.buyQuick(
                                        context, tokenAccount);
                                  },
                                ),
                              )
                            ],
                          )
                        : SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: IconButton(
                              icon: Icon(Icons.copy),
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: amount));
                                fToast.showToast(
                                  child:
                                      _showToast(context, S.of(context).copied),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 2),
                                );
                              },
                            ),
                          ),
                  ),
                  ListTile(
                    title: Text(
                      'SOL ${S.of(context).address}',
                      style: theme.textTheme.caption,
                    ),
                    subtitle: SelectableText(
                      tokenAccount.walletAddress,
                      style: theme.textTheme.subtitle1,
                    ),
                    trailing: SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.copy),
                        onPressed: () async {
                          await Clipboard.setData(
                              ClipboardData(text: tokenAccount.walletAddress));
                          fToast.showToast(
                            child: _showToast(context, S.of(context).copied),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                          );
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "${S.of(context).send_only} ${tokenAccount.token!.friendlySymbol!} ${S.of(context).to_this_addres_any_digital_asset_loss}",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).done),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

class _TokentItem extends StatelessWidget {
  final TokenAccount? tokenAccount;
  const _TokentItem(this.tokenAccount);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: SizedBox(
        height: 40.0,
        width: 40.0,
        child: Center(
          child: SizedBox(
            height: 32.0,
            width: 32.0,
            child: PlatformSvg.asset(
              tokenAccount!.token!.icon!,
              height: 32.0,
              width: 32.0,
            ),
          ),
        ),
      ),
      title: Text(
        'SOL ${S.of(context).address}',
        style: theme.textTheme.caption,
      ),
      subtitle: SelectableText(
        tokenAccount!.walletAddress,
        style: theme.textTheme.subtitle1,
      ),
      trailing: IconButton(
        icon: Icon(Icons.copy),
        onPressed: () async {
          await Clipboard.setData(
              ClipboardData(text: tokenAccount!.walletAddress));
          await ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(S.of(context).copied)));
        },
      ),
      // onTap: () {
      //   final WalletState state = context.read();
      //   state.showTokenMethod(tokenAccount);
      // },
    );
  }
}

class _QRAddress extends StatelessWidget {
  final QrCode? qrCode;
  final double size;
  const _QRAddress(this.qrCode, {this.size = 250});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return QrImage.withQr(
      qr: qrCode!,
      version: QrVersions.auto,
      padding: EdgeInsets.all(16.0),
      size: size,
      gapless: true,
      backgroundColor: isDark ? Colors.white : Colors.black,
      foregroundColor: isDark ? Colors.black : Colors.white,
      // embeddedImage: NetworkImage(callLink.video.thumbnail.url),
      // embeddedImageStyle: QrEmbeddedImageStyle(
      //   size: Size(80, 80),
      // ),
    );
  }
}

class TokenCard extends StatelessWidget {
  final TokenAccount? tokenAccount;
  final QrCode? qrCode;
  const TokenCard(this.tokenAccount, this.qrCode);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: ClipRRect(
                borderRadius: kMediumBorderRadius, child: _QRAddress(qrCode)),
          ),
        ),
        VSpace(Insets.ls),
        _TokentItem(tokenAccount)
      ],
    );
  }
}

class _FooterInfo extends StatelessWidget {
  final TokenAccount? tokenAccount;
  const _FooterInfo(this.tokenAccount);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.ls),
      margin: EdgeInsets.all(Insets.ls),
      child: Text(
        "${S.of(context).send_only} ${tokenAccount!.token!.friendlySymbol} ${S.of(context).to_this_addres_any_digital_asset_loss}",
        style: Theme.of(context).textTheme.caption,
        //textAlign: TextAlign.center,
      ),
    );
  }
}

class _WalletQRCard extends StatelessWidget {
  final TokenAccount? tokenAccount;
  final QrCode? qrCode;
  const _WalletQRCard(this.tokenAccount, this.qrCode);

  @override
  Widget build(BuildContext context) {
    return TokenCard(tokenAccount, qrCode);
  }
}

class DepositPage extends StatelessWidget {
  final String token;
  final TokenAccount? tokenAccount;
  final VoidCallback? onClose;
  DepositPage(this.token, {this.tokenAccount, this.onClose});

  @override
  Widget build(BuildContext context) {
    return TokenLoaderPage(
      token,
      (context, tokenAccount) {
        return DepositFunds(tokenAccount, onClose: onClose);
      },
      tokenAccount: tokenAccount,
    );
  }
}

class DepositFunds extends StatefulWidget {
  final TokenAccount? tokenAccount;
  final VoidCallback? onClose;
  DepositFunds(this.tokenAccount, {this.onClose, Key? key}) : super(key: key);

  @override
  _DepositFundState createState() => _DepositFundState();
}

class _DepositFundState extends State<DepositFunds> {
  QrCode? qrCode;

  initState() {
    final data = widget.tokenAccount!.walletAddress;
    qrCode = QrCode(4, QrErrorCorrectLevel.L);
    qrCode!.addData(data);
    qrCode!.make();
    super.initState();
  }

  _done() {
    WalletCubit cubit = context.read();
    cubit.refresh();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${S.of(context).deposit} ${widget.tokenAccount!.token!.tokenSymbol}'),
        elevation: 0,
        leading: widget.onClose != null
            ? BackButton(onPressed: () {
                WalletCubit cubit = context.read();
                cubit.refresh();
                widget.onClose!();
              })
            : BackButton(onPressed: _done),
        actions: [const ClusterChip()],
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VSpace(Insets.ls),
            Expanded(
              child: _WalletQRCard(widget.tokenAccount, qrCode),
            ),
            _FooterInfo(widget.tokenAccount),
            VSpace(Insets.ls),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: context.raisedStyle,
                child: Text(S.of(context).done.toUpperCase()),
                onPressed: _done,
              ),
            ),
            const WalletSecurityFooter(),
          ],
        ),
      ),
    );
  }
}
