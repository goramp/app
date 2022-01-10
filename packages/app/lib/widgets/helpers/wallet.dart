import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/bloc/wallet/wallet_provider/inapp_wallet.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/wallets/wallet_service.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/identity/passbase/index.dart';
import 'package:goramp/widgets/pages/identity/verify.dart';
import 'package:goramp/widgets/pages/wallets/crypto/buy/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/buy/interface.dart';
import 'package:goramp/widgets/pages/wallets/crypto/deposit.dart';
import 'package:goramp/widgets/pages/wallets/crypto/swap.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:browser_adapter/browser_adapter.dart';
import 'package:provider/provider.dart';
import 'package:goramp/models/token.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart' as launcher;
import 'package:goramp/generated/l10n.dart';

class WalletHelper {
  static String shortAddress(String address) =>
      '${address.substring(0, 6)}...${address.substring(address.length - 6, address.length)}';

  static Future<void> _doConnect(
      BuildContext context, WalletProvider provider) async {
    try {
      WalletCubit walletCubit = context.read();
      bool shouldConnect = true;
      if (provider is InAppWalletProvider) {
        MyAppModel model = context.read();
        final email = model.currentUser?.email;
        final emailVerified = model.currentUser?.emailVerified ?? false;
        if (email == null || !emailVerified) {
          bool logoutRequired = false;
          if (email == null) {
            bool? updated = await showEmailUpdateDialog(context: context);
            logoutRequired = updated ?? false;
            shouldConnect = false;
          } else if (!emailVerified) {
            bool? updated = await showEmailUpdateDialog(
                context: context,
                title: S.of(context).verify_email,
                email: email);
            shouldConnect = updated ?? false;
          }
          if (logoutRequired) {
            await LoginHelper.logout(context,
                returnTo: GoRouter.of(context).location);
            SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
              SnackbarHelper.show(
                  S.of(context).please_log_in_again_to_continue, context);
            });
          }
        }
      }
      if (shouldConnect) {
        await walletCubit.connect(provider);
      }
    } catch (error, stack) {
      print('error:$error');
      print('stack:$stack');
    }
  }

  static Future<WalletProvider?> change(BuildContext context) async {
    WalletCubit walletCubit = context.read();
    if (walletCubit.state.connecting || walletCubit.state.connected) {
      await walletCubit.disconnect();
    }
    AppConfig config = context.read();
    if (WalletProvider.getExternalWalletProviders(
            network: config.solanaCluster!)
        .isEmpty) {
      InAppWalletProvider defaultWalletProvider = context.read();
      await _doConnect(context, defaultWalletProvider);
      return defaultWalletProvider;
    }
    final wallet = await showPaymentMethodsDialog(context);
    if (wallet != null) {
      await _doConnect(context, wallet);
      return wallet;
    }
  }

  static Future<WalletProvider?> connect(
      BuildContext context, bool connect) async {
    WalletCubit walletCubit = context.read();
    if (connect) {
      if (walletCubit.state.connecting || walletCubit.state.connected) {
        return null;
      }
      AppConfig config = context.read();
      if (WalletProvider.getExternalWalletProviders(
              network: config.solanaCluster!)
          .isEmpty) {
        InAppWalletProvider defaultWalletProvider = context.read();
        await _doConnect(context, defaultWalletProvider);
        return defaultWalletProvider;
      }
      final wallet = await showPaymentMethodsDialog(context);
      if (wallet != null) {
        await _doConnect(context, wallet);
        return wallet;
      }
    } else {
      await walletCubit.disconnect();
      return null;
    }
  }

  static void handleError(BuildContext context, WalletServiceException error) {
    switch (error.code) {
      case WalletServiceExceptionCode.InsufficientFunds:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).insufficient_sol_for_fees('SOL')),
            action: SnackBarAction(
              label: S.of(context).deposit_token('SOL'),
              onPressed: () {
                WalletCubit cubit = context.read();
                cubit.refresh();
                final token = cubit.state.tokenAccounts
                    ?.firstWhereOrNull((token) => token.token == NATIVE_SOL);
                if (token != null) showDepositDialog(context, token);
              },
            ),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error.message ?? S.of(context).default_error_title)));
    }
  }

  static String raydiumDexUrl(BuildContext context, String marketId) {
    AppConfig config = Provider.of(context, listen: false);
    return '${config.kuroMarketUrl!}/#/market/$marketId';
  }

  static String transactionUrl(BuildContext context, String transaction) {
    AppConfig config = Provider.of(context, listen: false);
    return '${config.solanaExploreUrl!}/tx/$transaction?cluster=${config.solanaCluster}';
  }

  static String addressUrl(BuildContext context, String address) {
    AppConfig config = Provider.of(context, listen: false);
    return '${config.solanaExploreUrl!}/address/$address?cluster=${config.solanaCluster}';
  }

  static void verifyKYC(BuildContext context) {
    if (UniversalPlatform.isWeb) {
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
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              return const VerifyPage();
            },
            fullscreenDialog: true),
      );
    }
  }

  static void buy(BuildContext context, TokenAccount tokenAccount,
      {num? amount, VoidCallback? onSuccess, VoidCallback? onCancel}) {
    if (tokenAccount.token!.tokenSymbol == 'KURO') {
      buyWithKURO(context, tokenAccount);
    } else if (tokenAccount.token!.tokenSymbol == 'USDT') {
      _showPaymentMethodsDialog(context, tokenAccount,
          amount: amount, onCancel: onCancel, onSuccess: onSuccess);
    } else if (tokenAccount.token!.tokenSymbol == 'USDC') {
      _showPaymentMethodsDialog(context, tokenAccount);
    } else if (tokenAccount.token!.tokenSymbol == 'SOL') {
      _showPaymentMethodsDialog(context, tokenAccount,
          amount: amount, onCancel: onCancel, onSuccess: onSuccess);
    }
  }

  static void buyQuick(BuildContext context, TokenAccount tokenAccount,
      {num? amount, VoidCallback? onSuccess, VoidCallback? onCancel}) {
    if (tokenAccount.token!.tokenSymbol == 'KURO') {
      buyWithKURO(context, tokenAccount);
    } else if (tokenAccount.token!.tokenSymbol == 'USDT') {
      _showPaymentMethodsDialog(context, tokenAccount,
          amount: amount, onCancel: onCancel, onSuccess: onSuccess);
    } else if (tokenAccount.token!.tokenSymbol == 'USDC') {
      _showPaymentMethodsDialog(context, tokenAccount);
    } else if (tokenAccount.token!.tokenSymbol == 'SOL') {
      _showPaymentMethodsDialog(context, tokenAccount,
          amount: amount, onCancel: onCancel, onSuccess: onSuccess);
    }
  }

  static void buyWithKURO(BuildContext context, TokenAccount tokenAccount,
      {num? amount, VoidCallback? onSuccess, VoidCallback? onCancel}) async {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) {
            return SwapPage(
              fromMint: USDCMain,
              toMint: tokenAccount.token!,
            );
          },
          fullscreenDialog: true),
    );
    // RoutePageManager pageManager = context.read();
    // pageManager.navigateTo(WalletDetailRoutePath(
    //     tokenAccount.token!.tokenSymbol!,
    //     tokenAccount: tokenAccount,
    //     path: WalletDetailPath.swap,
    //     swapFrom: NATIVE_SOL,
    //     swapTo: tokenAccount.token!));
    // AppConfig config = context.read();
    // if (config.kuroMarketUrl != null &&
    //     await canLaunch(config.kuroMarketUrl!)) {
    //   launch(config.kuroMarketUrl!,
    //       forceSafariVC: true,
    //       forceWebView: true,
    //       enableJavaScript: true,
    //       enableDomStorage: true,
    //       webOnlyWindowName: '_blank');
    // }
  }

  static void buyWithFTX(BuildContext context, TokenAccount tokenAccount,
      {String? amount, VoidCallback? onSuccess, VoidCallback? onCancel}) {
    _showFTXPaymentDialog(context, tokenAccount);
  }

  static void _buyWithTransack(
      BuildContext context, TokenAccount tokenAccount,
      {num? amount, VoidCallback? onSuccess, VoidCallback? onCancel}) {
    AppConfig config = context.read();
    MyAppModel model = context.read();
    buyWithTransack(
        context,
        TransackOptions(
          config.transackBaseUrl!,
          apiKey: config.transackAPIKey,
          walletAddress: '${tokenAccount.walletAddress}',
          cryptoCurrencyCode: tokenAccount.token!.tokenSymbol,
          environment: config.isDev ? 'STAGING' : 'PRODUCTION',
          email: model.currentUser!.email,
          redirectURL: 'https://${config.webDomain}',
          network: 'solana',
          defaultCryptoAmount: amount?.toString(),
          defaultCryptoCurrency: tokenAccount.token!.tokenSymbol,
        ),
        onSuccess: onSuccess,
        onCancel: onCancel);
  }

  static void _buyWithFTX(BuildContext context, TokenAccount tokenAccount) {
    AppConfig config = context.read();
    buyWithFTXPay(
      context,
      FTXOptions(config.ftxPayBaseUrl!,
          address: '${tokenAccount.address}',
          coin: tokenAccount.token!.tokenSymbol,
          wallet: 'sol',
          memoIsRequired: false),
    );
  }

  static void _buyWithRamp(BuildContext context, TokenAccount tokenAccount,
      {num? amount, VoidCallback? onSuccess, VoidCallback? onCancel}) {
    AppConfig config = context.read();
    MyAppModel model = context.read();
    var amountS;
    if (amount != null) {
      amountS =
          (BigInt.from(amount) * BigInt.from(pow(10, tokenAccount.decimals!)))
              .toString();
    }
    buyWithRamp(
        context,
        RampOptions(
          baseUrl: config.rampBaseUrl!,
          hostApiKey: config.rampAPIKey,
          userAddress: '${tokenAccount.address}',
          defaultAsset: tokenAccount.token!.tokenSymbol,
          swapAsset: tokenAccount.token!.tokenSymbol,
          swapAmount: amountS,
          hostAppName: 'Kurobi',
          hostLogoUrl: KUROMain.icon,
          userEmailAddress: model.currentUser!.email,
          finalUrl: 'https://${config.webDomain}',
        ),
        onSuccess: onSuccess,
        onCancel: onCancel);
  }

  static String _ftxText(BuildContext context, TokenAccount tokenAccount) {
    return S.of(context).deposit_fund_on_ftx_account;
  }

  static String _rampText(BuildContext context, TokenAccount tokenAccount) {
    return S.of(context).ramp_allows_you_to_buy_cryto;
  }

  static String _transakText(
      BuildContext context, TokenAccount tokenAccount) {
    return S.of(context).transak_supports_debit_card_bank_transfer;
  }

  static double paddingScaleFactor(double textScaleFactor) {
    final double clampedTextScaleFactor = textScaleFactor.clamp(1.0, 2.0);
    // The final padding scale factor is clamped between 1/3 and 1. For example,
    // a non-scaled padding of 24 will produce a padding between 24 and 8.
    return lerpDouble(1.0, 1.0 / 3.0, clampedTextScaleFactor - 1.0)!;
  }

  static Future<void> showServiceUnavailableDialog(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final TextStyle? dialogTitleTextStyle = theme.textTheme.headline6;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).service_unavailable,
              style: dialogTitleTextStyle),
          content: Text(S.of(context).service_unavailable_region),
          actions: <Widget>[
            TextButton(
                child: Text(S.of(context).dismiss),
                onPressed: () {
                  Navigator.of(context).pop(
                      true); // Returning true to _onWillPop will pop again.
                })
          ],
        );
      },
    );
  }

  static String _kuroTxt(Contribution contribution) {
    return contribution.canBuy
        ? contribution.buyInfo ?? ''
        : contribution.preBuyInfo;
  }

  static void _showKUROBuyDialog(BuildContext context,
      TokenAccount tokenAccount, Contribution contribution,
      {VoidCallback? onContribute}) async {
    final paddingScaleFactor =
        WalletHelper.paddingScaleFactor(MediaQuery.of(context).textScaleFactor);
    final TextDirection? textDirection = Directionality.maybeOf(context);

    await showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final EdgeInsets effectiveTitlePadding =
            const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0)
                .resolve(textDirection);
        final titleWidget = Padding(
          padding: EdgeInsets.only(
            left: effectiveTitlePadding.left * paddingScaleFactor,
            right: effectiveTitlePadding.right * paddingScaleFactor,
            top: effectiveTitlePadding.top * paddingScaleFactor,
            bottom: effectiveTitlePadding.bottom,
          ),
          child: DefaultTextStyle(
            style: DialogTheme.of(context).titleTextStyle ??
                theme.textTheme.headline6!,
            child: Semantics(
              namesRoute: false,
              container: true,
              child: Text(
                '${S.of(context).buy} ${tokenAccount.token!.tokenSymbol!}',
                // textAlign: TextAlign.center,
              ),
            ),
          ),
        );
        final EdgeInsets effectiveContentPadding =
            const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 16.0)
                .resolve(textDirection);
        Widget contentWidget = Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: effectiveContentPadding.left * paddingScaleFactor,
              right: effectiveContentPadding.right * paddingScaleFactor,
              top: effectiveContentPadding.top * paddingScaleFactor,
              bottom: effectiveContentPadding.bottom * paddingScaleFactor,
            ),
            child: Column(children: [
              const SizedBox(
                height: 24.0,
              ),
              Center(
                child: PlatformSvg.asset(COINS.KURO, width: 96, height: 83.625),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Text(
                _kuroTxt(contribution),
                //maxLines: 3,
                // textAlign: TextAlign.center,
              )
            ]),
          ),
        );

        Widget dialogChild = IntrinsicWidth(
          stepWidth: 56.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                titleWidget,
                contentWidget,
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  constraints: const BoxConstraints(minHeight: 56.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OverflowBar(
                    spacing: 8,
                    //alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (!contribution.canBuy)
                        TextButton(
                            child: Text(S.of(context).dismiss),
                            onPressed: () => Navigator.of(context).pop()),
                      if (contribution.canBuy)
                        TextButton(
                            child: Text(S.of(context).cancel),
                            onPressed: () => Navigator.of(context).pop()),
                      if (contribution.enabled && onContribute != null)
                        TextButton(
                            child: Text(S.of(context).contribute),
                            onPressed: () {
                              onContribute.call();
                              Navigator.of(context).pop();
                            }),
                      if (contribution.canBuy &&
                          contribution.marketName1 != null &&
                          contribution.marketUrl1 != null)
                        launcher.Link(
                          uri: Uri.parse(contribution.marketUrl1!),
                          target: launcher.LinkTarget.blank,
                          builder: (contex, follow) => TextButton(
                              child: Text(contribution.marketName1!),
                              onPressed: () {
                                follow?.call();
                                Navigator.of(context).pop();
                              }),
                        ),
                      if (contribution.canBuy &&
                          contribution.marketName2 != null &&
                          contribution.marketUrl2 != null)
                        launcher.Link(
                          uri: Uri.parse(contribution.marketUrl2!),
                          target: launcher.LinkTarget.blank,
                          builder: (contex, follow) => TextButton(
                              child: Text(contribution.marketName2!),
                              onPressed: () {
                                follow?.call();
                                Navigator.of(context).pop();
                              }),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
        return Dialog(
            // titleTextStyle: theme.textTheme.headline6,
            child: dialogChild);
      },
    );
  }

  static void _showFTXPaymentDialog(
      BuildContext context, TokenAccount tokenAccount) async {
    final paddingScaleFactor =
        WalletHelper.paddingScaleFactor(MediaQuery.of(context).textScaleFactor);
    final TextDirection? textDirection = Directionality.maybeOf(context);

    await showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final EdgeInsets effectiveTitlePadding =
            const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0)
                .resolve(textDirection);
        final titleWidget = Padding(
          padding: EdgeInsets.only(
            left: effectiveTitlePadding.left * paddingScaleFactor,
            right: effectiveTitlePadding.right * paddingScaleFactor,
            top: effectiveTitlePadding.top * paddingScaleFactor,
            bottom: effectiveTitlePadding.bottom,
          ),
          child: DefaultTextStyle(
            style: DialogTheme.of(context).titleTextStyle ??
                theme.textTheme.headline6!,
            child: Semantics(
              namesRoute: false,
              container: true,
              child: Text(
                '${S.of(context).buy} ${tokenAccount.token!.tokenSymbol!} ${S.of(context).with_ftx_pay}',
                // textAlign: TextAlign.center,
              ),
            ),
          ),
        );
        final EdgeInsets effectiveContentPadding =
            const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 16.0)
                .resolve(textDirection);
        Widget contentWidget = Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: effectiveContentPadding.left * paddingScaleFactor,
              right: effectiveContentPadding.right * paddingScaleFactor,
              top: effectiveContentPadding.top * paddingScaleFactor,
              bottom: effectiveContentPadding.bottom * paddingScaleFactor,
            ),
            child: Column(children: [
              const SizedBox(
                height: 24.0,
              ),
              Center(
                child:
                    PlatformSvg.asset(PARTNERS.FTX, width: 96, height: 83.625),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Text(
                _ftxText(context, tokenAccount),
                //maxLines: 3,
                // textAlign: TextAlign.center,
              )
            ]),
          ),
        );

        Widget dialogChild = IntrinsicWidth(
          stepWidth: 56.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                titleWidget,
                contentWidget,
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  constraints: const BoxConstraints(minHeight: 56.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OverflowBar(
                    spacing: 8,
                    //alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                          child: Text(S.of(context).cancel),
                          onPressed: () => Navigator.of(context).pop()),
                      TextButton(
                          child: Text(S.of(context).buy_now),
                          onPressed: () {
                            _buyWithFTX(context, tokenAccount);
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
        return Dialog(
            // titleTextStyle: theme.textTheme.headline6,
            child: dialogChild);
      },
    );
  }

  static void _showPaymentMethodsDialog(
      BuildContext context, TokenAccount tokenAccount,
      {num? amount, VoidCallback? onSuccess, VoidCallback? onCancel}) async {
    final paddingScaleFactor =
        WalletHelper.paddingScaleFactor(MediaQuery.of(context).textScaleFactor);
    final TextDirection? textDirection = Directionality.maybeOf(context);
    AppConfig config = Provider.of(context, listen: false);
    await showDialog(
      context: context,
      builder: (context) {
        final EdgeInsets effectiveContentPadding =
            const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0)
                .resolve(textDirection);
        Widget contentWidget = Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: effectiveContentPadding.left * paddingScaleFactor,
              right: effectiveContentPadding.right * paddingScaleFactor,
              top: effectiveContentPadding.top * paddingScaleFactor,
              bottom: effectiveContentPadding.bottom * paddingScaleFactor,
            ),
            child: ListBody(children: [
              if (config.isDev)
                ListTile(
                  leading: PlatformSvg.asset(PARTNERS.RAMP, width: 32),
                  title: Text(
                      '${S.of(context).buy} ${tokenAccount.token!.tokenSymbol!} ${S.of(context).with_ramp}'),
                  subtitle: Text(
                    _rampText(context, tokenAccount),
                    //maxLines: 3,
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.of(context).pop();
                    _buyWithRamp(context, tokenAccount,
                        amount: amount,
                        onSuccess: onSuccess,
                        onCancel: onCancel);
                  },
                ),
              if (config.isDev)
                Divider(
                  indent: 72.0,
                ),
              ListTile(
                leading: Image.asset(PARTNERS.TRANSACK, width: 32),
                title: Text(
                    '${S.of(context).buy} ${tokenAccount.token!.tokenSymbol!} ${S.of(context).with_transak}'),
                subtitle: Text(
                  _transakText(context, tokenAccount),
                  //maxLines: 3,
                ),
                isThreeLine: true,
                onTap: () {
                  Navigator.of(context).pop();
                  _buyWithTransack(context, tokenAccount,
                      amount: amount, onSuccess: onSuccess, onCancel: onCancel);
                },
              ),
              Divider(
                indent: 72.0,
              ),
              ListTile(
                leading: PlatformSvg.asset(PARTNERS.FTX, width: 32),
                title: Text(
                    '${S.of(context).buy} ${tokenAccount.token!.tokenSymbol!} ${S.of(context).with_ftx_pay}'),
                subtitle: Text(
                  _ftxText(context, tokenAccount),
                  //maxLines: 3,
                ),
                isThreeLine: true,
                onTap: () {
                  Navigator.of(context).pop();
                  _buyWithFTX(context, tokenAccount);
                },
              ),
            ]),
          ),
        );

        Widget dialogChild = IntrinsicWidth(
          stepWidth: 56.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[contentWidget],
            ),
          ),
        );
        return Dialog(
            // title: Text('Select Card'),
            // titleTextStyle: theme.textTheme.headline6,
            child: dialogChild);
      },
    );
  }

  static void _showMaterialBottomSheet(
      BuildContext context, TokenAccount tokenAccount) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        Widget el = Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ListTile(
              leading: PlatformSvg.asset(PARTNERS.FTX, width: 32),
              title: Text(
                  '${S.of(context).buy} ${tokenAccount.token!.tokenSymbol!} ${S.of(context).with_ftx_pay}'),
              subtitle: Text(
                _ftxText(context, tokenAccount),
                maxLines: 3,
              ),
              isThreeLine: true,
              onTap: () {
                _buyWithFTX(context, tokenAccount);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Image.asset(PARTNERS.TRANSACK, width: 32),
              title: Text(
                  '${S.of(context).buy} ${tokenAccount.token!.tokenSymbol!} ${S.of(context).with_transak}'),
              subtitle: Text(
                _transakText(context, tokenAccount),
                maxLines: 3,
              ),
              onTap: () {
                _buyWithTransack(context, tokenAccount);
                Navigator.of(context).pop();
              },
            ),
          ],
        );

        el = CenteredWidget(
          PhysicalModel(
            elevation: 8.0,
            clipBehavior: Clip.hardEdge,
            shadowColor: Colors.black45,
            color: Theme.of(context).canvasColor,
            borderRadius: kTopBorderRadius,
            child: Material(
              child: el,
            ),
          ),
          maxWidth: 400,
        );
        return el;
      },
    );
  }
}
