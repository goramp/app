import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/services/wallets/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/deposit.dart';
import 'package:goramp/widgets/pages/wallets/crypto/price_builder.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';

class _TokenListItem extends StatefulWidget {
  final ValueNotifier<bool>? paymentLoading;
  final TokenAccount tokenAccount;
  final bool isPaying;

  _TokenListItem(this.tokenAccount, this.paymentLoading, this.isPaying);

  @override
  State<_TokenListItem> createState() => _TokenListItemState();
}

class _TokenListItemState extends State<_TokenListItem> {
  bool _isPaying = false;

  void _makepayment(
      BuildContext context, TokenAccount token, num amount) async {
    try {
      if (_isPaying) {
        return;
      }
      _isPaying = true;
      widget.paymentLoading!.value = _isPaying;
      final WalletCubit walletCubit = context.read();
      final walletService = WalletPaymentService(
          config: context.read(),
          wallet: walletCubit.state.wallet!,
          client: context.read());
      final Order order = context.read();
      await walletService.orderPayment(order, token);
      Navigator.of(context).pop(true);
    } on WalletPaymentException catch (error) {
      if (error.code == WalletPaymentExceptionCode.OrderExpired ||
          error.code == WalletPaymentExceptionCode.OrderInProgress ||
          error.code == WalletPaymentExceptionCode.DuplicateOrder) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message!)));
    } catch (error) {
      print('error_code: ${error}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).default_error_title2)));
    } finally {
      _isPaying = false;
      widget.paymentLoading!.value = _isPaying;
    }
  }

  void _showPaymentDialog(BuildContext context, BigInt amount) {
    final topupAmount = (amount - widget.tokenAccount.amount!) /
        BigInt.from(math.pow(10, widget.tokenAccount.decimals!));
    showDepositDialog(
      context,
      widget.tokenAccount,
      isTopUp: true,
      amount: cryptoFormatter.format(topupAmount),
    );
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checkout = Provider.of<CryptoCheckout>(context, listen: false);
    final expo = BigInt.from(math.pow(10, widget.tokenAccount.decimals!));
    final amount = (BigInt.tryParse(checkout
            .coins![widget.tokenAccount.token!.tokenSymbol!]!.amount!) ??
        BigInt.zero);
    final amountToPay = amount / expo;
    final bool canPay = widget.tokenAccount.amount! >= amount;
    final style = context.stadiumRoundButtonStyle.copyWith(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 16.0)));
    final text = Text(
      '${S.of(context).pay}  ${cryptoFormatter.format(amountToPay)} ${widget.tokenAccount.token!.tokenSymbol}',
    );

    final price =
        checkout.coins![widget.tokenAccount.token!.tokenSymbol!]?.rate ?? 0;
    final format = NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 2);
    final balance = widget.tokenAccount.amount! / expo;

    final usdVal = balance * price;
    return ListTile(
      leading: SizedBox(
          height: 24.0,
          width: 24.0,
          child: PlatformSvg.asset(
            widget.tokenAccount.token!.icon!,
            width: 40.0,
            height: 40.0,
          )),
      title: Text(
          '${cryptoFormatter.format(balance)} ${widget.tokenAccount.token!.tokenSymbol}'),
      subtitle: canPay
          ? Text('${format.format(usdVal)}')
          : Text(S.of(context).insufficient_funds),
      onTap: canPay
          ? _isPaying
              ? null
              : widget.isPaying
                  ? null
                  : () {
                      _makepayment(context, widget.tokenAccount, amountToPay);
                    }
          : widget.isPaying
              ? null
              : () {
                  _showPaymentDialog(context, amount);
                },
      trailing: canPay
          ? _isPaying
              ? ElevatedButton.icon(
                  onPressed: null,
                  style: style,
                  icon: SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: PlatformCircularProgressIndicator(
                      theme.colorScheme.primary,
                      strokeWidth: 2,
                    ),
                  ),
                  label: text)
              : ElevatedButton(
                  style: style,
                  child: text,
                  onPressed: widget.isPaying
                      ? null
                      : () {
                          _makepayment(
                              context, widget.tokenAccount, amountToPay);
                        },
                )
          : OutlinedButton(
              style: context.stadiumRoundOutlineStyle,
              child: Text(
                S.of(context).top_up,
              ),
              onPressed: widget.isPaying
                  ? null
                  : () {
                      _showPaymentDialog(context, amount);
                    }),
    );
  }
}

class CryptoPaymentMethodHeader extends StatelessWidget {
  final bool isExpanded;
  const CryptoPaymentMethodHeader({required this.isExpanded});

  void _onChange(BuildContext context) async {
    final WalletCubit cubit = context.read();
    final wallet = await showPaymentMethodsDialog(context);
    if (wallet != null) {
      await cubit.connect(wallet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletsState>(builder: (context, state) {
      final bool enabled = state.connected;
      final ThemeData theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      final dividerColor = isDark ? theme.hintColor : theme.dividerColor;

      AppConfig config = Provider.of(context, listen: false);
      final providers = WalletProvider.getExternalWalletProviders(
          network: config.solanaCluster!);
      return ListTile(
        leading: SizedBox(
          height: 24.0,
          width: 24.0,
          child: Icon(Icons
              .account_balance_wallet_outlined), // Center( child: PlatformSvg.asset(COINS.SOL, width: 32.0),),
        ),
        title: Text(S.of(context).pay_with_crypto_wallet),
        subtitle: state.wallet != null
            ? Text(
                WalletHelper.shortAddress(state.wallet!.publicKey!),
              )
            : null,
        trailing: providers.isNotEmpty
            ? AnimatedSwitcher(
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                duration: kThemeAnimationDuration,
                child: enabled
                    ? Container(
                        constraints: BoxConstraints.tightFor(
                          width: 130.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            PlatformImage.asset(state.wallet!.iconUrl,
                                width: 24),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              height: 24,
                              child: VerticalDivider(
                                color: dividerColor,
                                width: 8.0,
                                thickness: context.dividerHairLineWidth,
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                child: Text(state.connected
                                    ? S.of(context).change
                                    : state.connecting
                                        ? S.of(context).connecting
                                        : S.of(context).connect),
                                style: TextButton.styleFrom(
                                  elevation: 0,
                                  primary: theme.colorScheme.primary,
                                  padding: EdgeInsets.all(0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: enabled
                                    ? () {
                                        _onChange(context);
                                      }
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              )
            : PlatformImage.asset(state.wallet!.iconUrl, width: 24),
      );
    });
  }
}

class CryptoPaymentMethodBody extends StatefulWidget {
  final CryptoCheckout checkout;
  const CryptoPaymentMethodBody({this.paymentLoading, required this.checkout});
  final ValueNotifier<bool>? paymentLoading;

  @override
  _CryptoPaymentMethodBodyState createState() =>
      _CryptoPaymentMethodBodyState();
}

class _CryptoPaymentMethodBodyState extends State<CryptoPaymentMethodBody> {
  Widget _buildLoader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: const FeedLoader(),
    );
  }

  Widget _buildError() {
    return FeedErrorView(
      error: '${S.of(context).failed_to_load_payment_method}...',
      center: false,
      onRefresh: () {
        final walletCubit = BlocProvider.of<WalletCubit>(context);
        walletCubit.refresh();
      },
    );
  }

  Widget _buildWalletConnect() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return EmptyContent(
      topSpacing: 0.0,
      title: Text(
        S.of(context).connect_your_wallet,
        style: theme.textTheme.headline6,
        textAlign: TextAlign.center,
      ),
      subtitle: Text(
        S.of(context).your_tokens_will_appear_to_make_payment,
        style: theme.textTheme.caption,
        textAlign: TextAlign.center,
      ),
      icon: Icon(
        MdiIcons.connection,
        size: 96.0,
        color: isDark ? Colors.white38 : Colors.grey[300],
      ),
      action: const WalletConnectButton(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: widget.checkout,
      child: BlocBuilder<WalletCubit, WalletsState>(builder: (context, state) {
        Widget body;
        if (state.connected) {
          if (state.tokenAccounts != null) {
            if (state.tokenAccounts!.isEmpty) {
              body = _buildError();
            } else {
              final items = state.tokenAccounts!
                  .where((account) =>
                      widget.checkout.coins![account.token!.tokenSymbol!] !=
                      null)
                  .toList();
              items.sort((a, b) {
                final aExp = BigInt.from(math.pow(10, a.decimals!));
                final aBalance = a.amount! / aExp;
                final aVal =
                    widget.checkout.coins![a.token!.tokenSymbol!]!.total!;
                final aRem = (aBalance - aVal) *
                    widget.checkout.coins![a.token!.tokenSymbol!]!.rate!;
                final bExp = BigInt.from(math.pow(10, b.decimals!));
                final bBalance = b.amount! / bExp;
                final bVal =
                    widget.checkout.coins![b.token!.tokenSymbol!]!.total!;
                final bRem = (bBalance - bVal) *
                    widget.checkout.coins![b.token!.tokenSymbol!]!.rate!;
                return -(aRem - bRem).toInt();
              });
              body = ValueListenableBuilder(
                valueListenable: widget.paymentLoading!,
                builder: (_, dynamic isPaying, __) => Column(
                  children: [
                    //const CryptoWalletConnect(),
                    ...items
                        .map(
                          (tokenAccount) => _TokenListItem(
                              tokenAccount, widget.paymentLoading, isPaying),
                        )
                        .toList()
                  ],
                ),
              );
            }
          } else if (state.loadError != null) {
            body = _buildError();
          } else {
            body = _buildLoader(context);
          }
        } else {
          body = _buildWalletConnect();
        }
        return AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          child: Material(
            color: Colors.transparent,
            child: CenteredWidget(body),
          ),
        );
      }),
    );
  }
}
