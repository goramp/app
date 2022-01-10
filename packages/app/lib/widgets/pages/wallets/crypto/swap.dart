import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/services.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/bloc/wallet/swap.dart';
import 'package:goramp/models/token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/services/wallets/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/custom/progress_button.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/deposit.dart';
import 'package:goramp/widgets/pages/wallets/crypto/detail.dart';
import 'package:goramp/widgets/pages/wallets/crypto/wallet_security.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goramp/generated/l10n.dart';

const _kPercent = <int>[25, 50, 75, 100];

class WalletServiceUnavailable extends StatelessWidget {
  const WalletServiceUnavailable();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return EmptyContent(
      title: Text(
        S.of(context).service_unavailable,
        textAlign: TextAlign.center,
      ),
      icon: PlatformSvg.asset(
        Constants.SERVICE_UNAVAILABLE_WHITE_SVG,
        height: 96.0,
        width: 96.0,
        color: isDark ? Colors.white38 : Colors.grey[300],
      ),
      subtitle: Text(
        S.of(context).service_unavailable_region,
        style: theme.textTheme.caption,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SwapPage extends StatelessWidget {
  final VoidCallback? onClose;
  final Token? fromMint;
  final Token? toMint;
  final bool enabledMintSelection;

  const SwapPage({
    this.fromMint = KUROMain,
    this.toMint = USDCMain,
    this.enabledMintSelection = true,
    this.onClose,
  });

  Widget build(BuildContext context) {
    final error = WalletFetchError(
      onRetry: () {
        final walletCubit = BlocProvider.of<WalletCubit>(context);
        walletCubit.refresh();
      },
      onClose: onClose,
    );
    return BlocBuilder<WalletCubit, WalletsState>(
        buildWhen: (prevState, currState) {
      return prevState.wallet != currState.wallet;
    }, builder: (context, state) {
      Widget body;
      if (state.wallet != null) {
        if (state.tokenAccounts == null || state.tokenAccounts!.isEmpty) {
          body = WalletFetchError(
            onRetry: () {
              final walletCubit = BlocProvider.of<WalletCubit>(context);
              walletCubit.refresh();
            },
          );
        } else {
          body = _Swap(
            fromMint: fromMint,
            toMint: toMint,
            enabledMintSelection: enabledMintSelection,
            onClose: onClose,
          );
        }
      } else if (state.loadError != null) {
        body = error;
      } else {
        body = _Loader(
          onClose: onClose,
        );
      }
      return AnimatedSwitcher(duration: kThemeAnimationDuration, child: body);
    });
  }
}

class _Loader extends StatelessWidget {
  final VoidCallback? onClose;
  const _Loader({this.onClose});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: onClose != null
            ? BackButton(
                onPressed: onClose,
              )
            : null,
      ),
      body: FeedLoader(),
    );
  }
}

class PriceIcon extends StatelessWidget {
  final TokenAccount tokenAccount;
  final String price;
  const PriceIcon({
    required this.tokenAccount,
    required this.price,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CryptoIcon(
          tokenAccount: tokenAccount,
        ),
        const SizedBox(
          height: 16.0,
        ),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: 80),
            child: Text(
              "$price ${tokenAccount.token!.tokenSymbol}",
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}

class _CoinIcon extends StatelessWidget {
  final Token token;
  final double size;
  _CoinIcon(this.token, {this.size = 32.0});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: PlatformSvg.asset(token.icon!, width: size, height: size),
    );
  }
}

class _SwapCoin extends StatelessWidget {
  final Token mint;
  _SwapCoin(this.mint);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: kMinInteractiveDimension,
      padding: EdgeInsets.only(right: 8.0),
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(mint.tokenSymbol!,
              style:
                  theme.textTheme.subtitle1?.copyWith(color: theme.hintColor)),
          SizedBox(
            width: 8.0,
          ),
          _CoinIcon(
            mint,
            size: 24.0,
          ),
        ],
      ),
      //alignment: AlignmentDirectional.centerEnd,
    );
  }
}

class _CurrencyList extends StatelessWidget {
  final Token selectedMint;
  final List<Token> mints;
  final ValueChanged<Token?> onSelected;
  final bool enabled;

  _CurrencyList(
      {required this.selectedMint,
      this.enabled = true,
      required this.mints,
      required this.onSelected});

  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(right: 0.0),
      //margin: EdgeInsets.all(12.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Token>(
          value: selectedMint,
          icon: Icon(Icons.arrow_drop_down,
              color: enabled ? theme.disabledColor : theme.hintColor),
          iconSize: 24,
          selectedItemBuilder: (BuildContext context) {
            return mints.map<Widget>((Token item) {
              return _SwapCoin(item);
            }).toList();
          },
          onChanged: enabled ? onSelected : null,
          items: mints.map<DropdownMenuItem<Token>>(
            (Token value) {
              return DropdownMenuItem<Token>(
                value: value,
                child: Container(
                  height: kMinInteractiveDimension,
                  width: 100,
                  child: Row(
                    children: [
                      _CoinIcon(
                        value,
                        size: 24.0,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(value.tokenSymbol!, style: theme.textTheme.subtitle1)
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class _ButtonSelectors extends StatelessWidget {
  final List<int> percentages;
  final ValueChanged<int> onPercent;

  _ButtonSelectors(this.percentages, this.onPercent);

  Color _getFillColor(ThemeData themeData, bool enabled) {
    // dark theme: 10% white (enabled), 5% white (disabled)
    // light theme: 4% black (enabled), 2% black (disabled)
    const Color darkEnabled = Color(0x1AFFFFFF);
    const Color darkDisabled = Color(0x0DFFFFFF);
    const Color lightEnabled = Color(0x0A000000);
    const Color lightDisabled = Color(0x05000000);

    switch (themeData.brightness) {
      case Brightness.dark:
        return enabled ? darkEnabled : darkDisabled;
      case Brightness.light:
        return enabled ? lightEnabled : lightDisabled;
    }
  }

  Widget _buildButton(BuildContext context, int percent) {
    final theme = Theme.of(context);
    final style = TextButton.styleFrom(
      elevation: 0,
      // padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      primary: theme.colorScheme.primary,
      backgroundColor: _getFillColor(theme, true),
      // maximumSize: Size(64, 30),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(borderRadius: kInputBorderRadius),
    );
    return TextButton(
        style: style,
        onPressed: () {
          onPercent.call(percent);
        },
        child: Text("${percent}%"));
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Insets.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.start,
      children:
          percentages.map((percent) => _buildButton(context, percent)).toList(),
    );
  }
}

class _BuyButton extends StatelessWidget {
  const _BuyButton();
  @override
  Widget build(BuildContext context) {
    Swap swap = context.watch();
    return BlocBuilder<WalletCubit, WalletsState>(
        buildWhen: (prevState, currState) {
      final prevTokenAccount = prevState.tokenAccounts?.firstWhereOrNull(
          (element) =>
              element.token?.mintAddress == swap.fromMint?.mintAddress);
      final currentTokenAccount = currState.tokenAccounts?.firstWhereOrNull(
          (element) =>
              element.token?.mintAddress == swap.fromMint?.mintAddress);
      return prevTokenAccount != currentTokenAccount;
    }, builder: (context, state) {
      final currentTokenAccount = state.tokenAccounts?.firstWhereOrNull(
          (element) =>
              element.token?.mintAddress == swap.fromMint?.mintAddress);
      return TextButton(
        //tooltip: 'Deposit ${swap.fromMint?.tokenSymbol}',
        onPressed: currentTokenAccount != null &&
                currentTokenAccount.token!.canBuy &&
                currentTokenAccount.token != KUROMain
            ? () {
                Swap swap = context.read();
                WalletHelper.buy(context, currentTokenAccount,
                    amount: swap.fromAmount, onSuccess: () {
                  WalletCubit walletCubit = context.read();
                  walletCubit.refresh();
                });
                //showDepositDialog(context, currentTokenAccount);
              }
            : null,
        child: Text('${S.of(context).buy} ${swap.fromMint?.tokenSymbol}'),
      );
    });
  }
}

class _SwapField extends StatefulWidget {
  final bool from;
  final double? amount;
  final String label;
  final Token mint;
  final ValueChanged<double>? onChanged;
  final ValueChanged<Token>? onMintChanged;
  final List<Token>? swappables;

  _SwapField(
      {required this.mint,
      required this.label,
      this.amount = 0.0,
      required this.onChanged,
      this.onMintChanged,
      this.from = false,
      this.swappables});

  @override
  State<_SwapField> createState() => _SwapFieldState();
}

class _SwapFieldState extends State<_SwapField> {
  TextEditingController _controller = TextEditingController();
  late intl.NumberFormat _formatter;
  late intl.NumberFormat _amountFormatter;

  initState() {
    _setFormatter();
    _controller.text = _amountFormatter.format(widget.amount);
    super.initState();
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  _updateAmount() {
    final newValue = _amountFormatter.format(widget.amount);
    //_controller.text = newValue;
    _controller.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.fromPosition(
        TextPosition(offset: newValue.length),
      ),
    );
  }

  _setFormatter() {
    final digits =
        List.generate(widget.mint.decimals!, (index) => '#').join('');
    _formatter = intl.NumberFormat(
      '##,###.${digits}',
    );
    _amountFormatter = intl.NumberFormat(
      '###.${digits}',
    );
  }

  didUpdateWidget(_SwapField old) {
    if (old.mint.decimals != widget.mint.decimals) {
      _setFormatter();
    }
    if (old.amount != widget.amount) {
      _updateAmount();
    }
    super.didUpdateWidget(old);
  }

  Widget _buildTextInput(BuildContext context, {TokenAccount? account}) {
    final balance = (account?.amount ?? BigInt.zero) /
        BigInt.from(math.pow(10, widget.mint.decimals!));
    return TextFormField(
      controller: _controller,
      maxLines: 1,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^\d*\.?\d{0,' + '${widget.mint.decimals}' + '}'))
      ],
      onChanged: (String value) {
        final double amount = double.tryParse(value) ?? 0.0;
        widget.onChanged?.call(amount);
      },
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: false),
      decoration: InputDecoration(
          filled: true,
          labelText: widget.label,
          hintText: _formatter.format(0.0),
          suffixIcon: Container(
            height: kMinInteractiveDimension,
            child: widget.swappables != null
                ? _CurrencyList(
                    selectedMint: widget.mint,
                    mints: widget.swappables!,
                    onSelected: (Token? mint) {
                      if (mint == null || mint == widget.mint) {
                        return;
                      }
                      widget.onMintChanged?.call(mint);
                    })
                : _SwapCoin(widget.mint),
            padding: EdgeInsets.only(right: 16.0),
          ),
          helperText:
              '${S.of(context).balance}: ${balance.toStringAsFixed(widget.mint.decimals!)}'),
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletsState>(
        buildWhen: (prevState, currState) {
      final prevTokenAccount = prevState.tokenAccounts?.firstWhereOrNull(
          (element) => element.token?.mintAddress == widget.mint.mintAddress);
      final currentTokenAccount = currState.tokenAccounts?.firstWhereOrNull(
          (element) => element.token?.mintAddress == widget.mint.mintAddress);
      return prevTokenAccount != currentTokenAccount;
    }, builder: (context, state) {
      final currentTokenAccount = state.tokenAccounts?.firstWhereOrNull(
          (element) => element.token?.mintAddress == widget.mint.mintAddress);
      return _buildTextInput(context, account: currentTokenAccount);
    });
  }
}

class SwapRow extends StatelessWidget {
  final String labelText;
  final String labelValue;

  SwapRow({required this.labelText, required this.labelValue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              labelText,
              style: theme.textTheme.caption,
            ),
            Text(
              labelValue,
              style: theme.textTheme.caption,
            )
          ],
        ));
  }
}

class SlippageRow extends StatelessWidget {
  final num slippage;
  SlippageRow(this.slippage);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              text: '${S.of(context).slippage} ',
              style: theme.textTheme.caption,
              children: [
                WidgetSpan(
                  child: Tooltip(
                    message: S.of(context).swap_off_from_estimate,
                    child: Icon(
                      Icons.info_outline,
                      size: 14,
                      color: theme.textTheme.caption?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$slippage%',
            style: theme.textTheme.caption,
          )
        ],
      ),
    );
  }
}

class SOLBalance extends StatelessWidget {
  const SOLBalance();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var hasSufficientSOLBalance = context.select<WalletCubit, bool>((wallet) {
      final solTokenAccount = wallet.state.tokenAccounts
          ?.firstWhereOrNull((element) => element.token == NATIVE_SOL);
      final balance = (solTokenAccount?.amount ?? BigInt.zero) /
          BigInt.from(math.pow(10, NATIVE_SOL.decimals!));
      return balance >= 0.05;
    });
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: hasSufficientSOLBalance
          ? const SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(left: 12.0, right: 12.0, top: Insets.ls),
              child: Tooltip(
                padding: const EdgeInsets.all(8.0),
                message: S.of(context).low_sol_balance_info,
                child: Text.rich(
                  TextSpan(
                    text: S.of(context).low_sol_balance,
                    style: theme.textTheme.caption,
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.info_outline,
                          size: 14,
                          color: theme.textTheme.caption?.color,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}

class _SwapForm extends StatelessWidget {
  final bool enabledMintSelection;
  final ValueNotifier<bool> loading;
  final VoidCallback onSwap;
  const _SwapForm(
      {this.enabledMintSelection = true,
      required this.loading,
      required this.onSwap});

  void _mintPercent(BuildContext context, int percent, Token mint) {
    WalletCubit wallet = context.read();
    Swap swap = context.read();
    final currentTokenAccount = wallet.state.tokenAccounts?.firstWhereOrNull(
        (element) => element.token?.mintAddress == mint.mintAddress);
    final balance = (currentTokenAccount?.amount ?? BigInt.zero) /
        BigInt.from(math.pow(10, mint.decimals!));
    swap.fromAmount = (percent / 100) * balance;
  }

  @override
  Widget build(BuildContext context) {
    Swap swap = context.watch();
    final theme = Theme.of(context);
    var priceLabel = '-';
    if (swap.fair != null && swap.toMint != null && swap.fromMint != null) {
      priceLabel =
          '1 ${swap.fromMint!.tokenSymbol!} = ${(1 / swap.fair!).toStringAsFixed(swap.toMint!.decimals!)} ${swap.toMint!.tokenSymbol}';
    }
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark ? theme.hintColor : theme.dividerColor;

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.all(Insets.ls),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VSpace(Insets.ls),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  //tooltip: 'Deposit ${swap.fromMint?.tokenSymbol}',
                  onPressed: () {
                    WalletCubit walletCubit = context.read();
                    final currentTokenAccount = walletCubit.state.tokenAccounts
                        ?.firstWhereOrNull((element) =>
                            element.token?.mintAddress ==
                            swap.fromMint?.mintAddress);
                    if (currentTokenAccount != null)
                      showDepositDialog(context, currentTokenAccount);
                  },
                  child: Text(
                      '${S.of(context).deposit} ${swap.fromMint?.tokenSymbol}'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  height: 40,
                  child: VerticalDivider(
                    color: dividerColor,
                    width: 4.0,
                    thickness: context.dividerHairLineWidth,
                  ),
                ),
                const _BuyButton(),
              ],
            ),
            VSpace(Insets.sm),
            _SwapField(
              mint: swap.fromMint!,
              from: true,
              label: S.of(context).from,
              amount: swap.fromAmount,
              swappables: swap.toMint == USDCMain
                  ? swap.swappableTokens
                  : [swap.fromMint!],
              onChanged: (double amount) {
                swap.fromAmount = amount;
              },
              onMintChanged: enabledMintSelection
                  ? (mint) {
                      swap.fromMint = mint;
                    }
                  : null,
            ),
            VSpace(Insets.sm),
            _ButtonSelectors(_kPercent, (percent) {
              _mintPercent(context, percent, swap.fromMint!);
            }),
            VSpace(Insets.ls),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      swap.swap();
                    },
                    icon: Icon(Icons.import_export_outlined)),
              ],
            ),
            VSpace(Insets.ls),
            // _ButtonSelectors(_kPercent, (percent) {}),
            // VSpace(Insets.sm),
            _SwapField(
              from: false,
              mint: swap.toMint!,
              label: '${S.of(context).to} (${S.of(context).estimated})',
              amount: swap.toAmount,
              swappables: swap.fromMint == USDCMain
                  ? swap.swappableTokens
                  : [swap.toMint!],
              onChanged: (double amount) {
                swap.toAmount = amount;
              },
              onMintChanged: enabledMintSelection
                  ? (mint) {
                      swap.toMint = mint;
                    }
                  : null,
            ),
            VSpace(Insets.ls),
            SwapRow(
              labelText: '${S.of(context).current_price}:',
              labelValue: '$priceLabel',
            ),
            VSpace(Insets.ls),
            SlippageRow(swap.slippage),
            VSpace(Insets.ls),
            BlocBuilder<WalletCubit, WalletsState>(
                buildWhen: (prevState, currState) {
              final prevTokenAccount = prevState.tokenAccounts
                  ?.firstWhereOrNull((element) =>
                      element.token?.mintAddress == swap.fromMint?.mintAddress);
              final currentTokenAccount = currState.tokenAccounts
                  ?.firstWhereOrNull((element) =>
                      element.token?.mintAddress == swap.fromMint?.mintAddress);
              return prevTokenAccount != currentTokenAccount;
            }, builder: (context, state) {
              final currentTokenAccount = state.tokenAccounts?.firstWhereOrNull(
                  (element) =>
                      element.token?.mintAddress == swap.fromMint?.mintAddress);
              final balance = (currentTokenAccount?.amount ?? BigInt.zero) /
                  BigInt.from(math.pow(10, swap.fromMint!.decimals!));
              final hasEnoughBalance = balance >= swap.fromAmount;
              return ProgressButton(loading,
                  label: Text(
                    S.of(context).swap,
                  ),
                  style: context.raisedStyle,
                  //icon: Icon(Icons.send),
                  onPressed: swap.canSwap && hasEnoughBalance ? onSwap : null);
            }),
            const SOLBalance()
          ],
        ),
      ),
    );
  }
}

class _Swap extends StatefulWidget {
  final VoidCallback? onClose;
  final Token? fromMint;
  final Token? toMint;
  final bool enabledMintSelection;

  _Swap(
      {required this.fromMint,
      required this.toMint,
      this.enabledMintSelection = true,
      this.onClose,
      Key? key})
      : super(key: key);

  @override
  _SwapState createState() => _SwapState();
}

class _SwapState extends State<_Swap> {
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  late Swap _swap;
  late WalletService _service;

  initState() {
    _swap = Swap(fromMint: widget.fromMint, toMint: widget.toMint);
    WalletCubit cubit = context.read();
    _service = WalletService(
        client: context.read(),
        wallet: cubit.state.wallet!,
        config: context.read());
    super.initState();
  }

  didUpdateWidget(_Swap old) {
    if (old.fromMint != widget.fromMint || old.toMint != widget.toMint) {
      _swap.fromMint = widget.fromMint;
      _swap.toMint = widget.toMint;
    }
    super.didUpdateWidget(old);
  }

  dispose() {
    _swap.dispose();
    super.dispose();
  }

  Future<void> _onSwap() async {
    try {
      if (_loading.value) return;
      _loading.value = true;
      FocusScope.of(context).unfocus();

      WalletCubit wallet = context.read();
      if (_swap.toMint?.mintAddress == null ||
          _swap.fromMint?.mintAddress == null ||
          _swap.fair == null) {
        return;
      }
      final fromWallet = wallet.state.tokenAccounts?.firstWhereOrNull(
          (element) =>
              element.token?.mintAddress == _swap.fromMint?.mintAddress);
      if (fromWallet == null) {
        return;
      }
      final toWallet = wallet.state.tokenAccounts?.firstWhereOrNull(
          (element) => element.token?.mintAddress == _swap.toMint?.mintAddress);
      if (toWallet == null) {
        return;
      }

      if (_swap.routes == null || _swap.routes!.isEmpty) {
        return;
      }
      final amount = BigInt.from(
          _swap.fromAmount * math.pow(10, _swap.fromMint!.decimals!));
      final fromMarket = _swap.routes![0];
      final quoteMint = fromMarket.quoteMintAddress;
      final quoteWallet =
          wallet.state.tokenAccounts?.firstWhereOrNull((element) {
        if (element.token?.mintAddress == NATIVE_SOL.mintAddress &&
            quoteMint == WSOL.mintAddress) {
          return true;
        }
        return element.token?.mintAddress == quoteMint;
      });
      final toMarket = _swap.routes!.length > 1 ? _swap.routes![1] : null;
      final toAmount = BigInt.from(
          (math.pow(10, _swap.toMint!.decimals!) * FEE_MULTIPLIER) /
              _swap.fair!);
      final minExpectedSwapAmount = BigInt.from(
          (toAmount * BigInt.from(100 - _swap.slippage) / BigInt.from(100)));
      final transactions = await _service.swapTransaction(
          fromWallet.address,
          toWallet.address,
          _swap.fromMint!.mintAddress!,
          _swap.toMint!.mintAddress!,
          fromMarket.quoteMintAddress,
          fromMarket.publicKey,
          minExpectedSwapAmount,
          amount,
          fromWallet.token!.decimals!,
          quoteWallet!.token!.decimals!,
          toMarketAddress: toMarket?.publicKey,
          quoteWalletAddress: quoteWallet.address);
      WalletCubit cubit = context.read();
      final futures = transactions.map((tx) async {
        final controller = ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).transaction_confirmed),
          action: SnackBarAction(
            label: '${S.of(context).view_on} Solana',
            onPressed: () async {
              final url = WalletHelper.transactionUrl(context, tx);
              if (await canLaunch(url)) {
                launch(url,
                    webOnlyWindowName: '_blank',
                    enableJavaScript: true,
                    forceSafariVC: true,
                    forceWebView: true);
              }
            },
          ),
        ));
        await controller.closed;
      });
      await cubit.refresh();
      await Future.wait(futures);
    } on WalletServiceException catch (error) {
      WalletHelper.handleError(context, error);
    } catch (error, stack) {
      print('stack: ${stack}');
      print('ERROR: ${error}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).default_error_title)));
    } finally {
      _loading.value = false;
    }
  }

  Future<void> _displaySlippageDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).settings),
            content: TextFormField(
              initialValue: _swap.slippage.toString(),
              maxLines: 1,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,5}'))
              ],
              onChanged: (String value) {
                final double amount = double.tryParse(value) ?? 0.0;
                _swap.slippage = amount;
              },
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: false),
              decoration: InputDecoration(
                  filled: true,
                  labelText:
                      '${S.of(context).slippage} ${S.of(context).tolerance}(%)',
                  hintText: '0.0',
                  helperMaxLines: 3,
                  helperText: S.of(context).swap_off_from_estimate),
            ),
            actions: [
              TextButton(
                  child: Text(S.of(context).dismiss),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Returning true to _onWillPop will pop again.
                  })
            ],
          );
        });
  }

  Widget _buildPopUpButton(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      icon: Icon(Icons.settings_outlined),
      // offset: Offset(0, -160),
      onSelected: (String result) async {
        if (result == 'slippage') {
          await _displaySlippageDialog(context);
          return;
        }
        if (result == 'dex') {
          if (_swap.routes == null || _swap.routes!.isEmpty) {
            return;
          }
          final fromMarket = _swap.routes![0];
          final url = WalletHelper.raydiumDexUrl(context, fromMarket.publicKey);
          if (await canLaunch(url)) {
            launch(url,
                webOnlyWindowName: '_blank',
                enableJavaScript: true,
                forceSafariVC: true,
                forceWebView: true);
          }
          return;
        }
      },

      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'slippage',
          child: Text('${S.of(context).slippage} ${S.of(context).tolerance}'),
        ),
        PopupMenuItem<String>(value: 'dex', child: Text(S.of(context).trade)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final isDark = theme.brightness == Brightness.dark;
    return ChangeNotifierProvider.value(
      value: _swap,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).swap),
          elevation: 0,
          centerTitle: true,
          leading: widget.onClose != null
              ? BackButton(onPressed: widget.onClose)
              : BackButton(onPressed: () => Navigator.of(context).pop()),
          actions: [_buildPopUpButton(context)],
        ),
        body: Scrollbar(
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Expanded(
                          child: _SwapForm(
                            loading: _loading,
                            onSwap: _onSwap,
                          ),
                        ),
                        const WalletSecurityFooter()
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
