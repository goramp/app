import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/models/token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/services/wallets/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/custom/progress_button.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/identity/verify.dart';
import 'package:goramp/widgets/pages/wallets/crypto/deposit.dart';
import 'package:goramp/widgets/pages/wallets/crypto/detail.dart';
import 'package:goramp/widgets/pages/wallets/crypto/wallet_security.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:intl/intl.dart' as intl;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:goramp/generated/l10n.dart';

const _kIconSize = 96.0;

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

class CountDownBox extends StatelessWidget {
  final String countText;
  final String? labelText;
  final double? size;
  final TextStyle? labelStyle;
  final TextStyle? countStyle;
  final double? labelMargin;
  final Color? backgroundColor;

  CountDownBox(
    this.countText, {
    this.labelText,
    this.size,
    this.labelStyle,
    this.countStyle,
    this.labelMargin,
    this.backgroundColor,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color =
        backgroundColor ?? (isDark ? Colors.grey[800] : Colors.grey[200]);

    return Column(
      children: [
        Container(
          width: size ?? 64,
          height: size ?? 64,
          decoration:
              BoxDecoration(color: color, borderRadius: kInputBorderRadius),
          //padding: EdgeInsets.all(16.0),
          child: Center(
            child:
                Text(countText, style: countStyle ?? theme.textTheme.subtitle1),
          ),
        ),
        if (labelText != null)
          SizedBox(
            height: labelMargin ?? 8.0,
          ),
        if (labelText != null)
          Text(
            labelText!,
            style: labelStyle ?? theme.textTheme.bodyText2,
          ),
      ],
    );
  }
}

class ContributionTimeRow extends StatelessWidget {
  final CurrentRemainingTime remainingTime;
  final TextStyle? countStyle;
  final TextStyle? labelStyle;
  final bool? showLabel;
  final double? dotSize;
  final Color? dotColor;
  final double? size;
  final double? labelMargin;
  final Color? backgroundColor;
  ContributionTimeRow(this.remainingTime,
      {this.labelStyle,
      this.countStyle,
      this.showLabel = true,
      this.dotSize = 24,
      this.size,
      this.dotColor,
      this.labelMargin,
      this.backgroundColor});
  String singleDigit(int n) {
    return "$n";
  }

  String twoDigits(int n) {
    if (n >= 10) return singleDigit(n);
    return "0$n";
  }

  Widget build(BuildContext context) {
    final min = twoDigits(remainingTime.min ?? 0);
    final sec = twoDigits(remainingTime.sec ?? 0);
    final hrs = remainingTime.hours ?? 0;
    final days = remainingTime.days ?? 0;
    var txt = '${min}m : ${sec}s';
    if (hrs > 0) {
      txt = '${hrs}h : $txt';
    }
    if (days > 0) {
      txt = '${days}d : $txt';
    }
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CountDownBox('${days}',
            labelText: showLabel! ? S.of(context).days : null,
            size: size,
            labelStyle: labelStyle,
            countStyle: countStyle,
            labelMargin: labelMargin,
            backgroundColor: backgroundColor),
        Icon(MdiIcons.circleSmall,
            size: dotSize, color: dotColor ?? theme.textTheme.caption!.color),
        CountDownBox(
          '${hrs}',
          labelText: showLabel! ? S.of(context).hours : null,
          labelStyle: labelStyle,
          countStyle: countStyle,
          size: size,
          labelMargin: labelMargin,
          backgroundColor: backgroundColor,
        ),
        Icon(MdiIcons.circleSmall,
            size: dotSize, color: dotColor ?? theme.textTheme.caption!.color),
        CountDownBox(
          '${min}',
          labelText: showLabel! ? toTitleCase(S.of(context).mins) : null,
          size: size,
          labelStyle: labelStyle,
          countStyle: countStyle,
          labelMargin: labelMargin,
          backgroundColor: backgroundColor,
        ),
        Icon(MdiIcons.circleSmall,
            size: dotSize, color: dotColor ?? theme.textTheme.caption!.color),
        CountDownBox(
          '${sec}',
          labelText: showLabel! ? S.of(context).secs : null,
          size: size,
          labelStyle: labelStyle,
          countStyle: countStyle,
          labelMargin: labelMargin,
          backgroundColor: backgroundColor,
        ),
      ],
    );
  }
}

class ContributionTimeView extends StatelessWidget {
  final CurrentRemainingTime remainingTime;
  final TextStyle? textStyle;
  ContributionTimeView(this.remainingTime, {this.textStyle});
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 48.0,
        ),
        Text(
          "Wen KURO?",
          textAlign: TextAlign.center,
        ),
        Container(
            padding: EdgeInsets.all(Insets.ls),
            child: ContributionTimeRow(
              remainingTime,
              labelStyle: textStyle,
            ))
      ],
    );
  }
}

class _ConributionEnded extends StatelessWidget {
  final Contribution contribution;
  _ConributionEnded({required this.contribution});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    final style = Theme.of(context).textTheme.caption;
    return Column(
      children: <Widget>[
        SizedBox(
          height: 64.0,
        ),
        Icon(
          Icons.check_circle,
          size: _kIconSize,
          color: isDark ? Colors.green[200] : Colors.green[400],
        ),
        SizedBox(
          height: 24.0,
        ),
        Text('${S.of(context).thank_you_participating}!!!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5),
        Center(
          child: Text(
            "${contribution.subTitle ?? ''}",
            style: style,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
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

class ContributeFunds extends StatelessWidget {
  final VoidCallback? onClose;
  final Contribution? contribution;
  final UserContribution? userContribution;

  const ContributeFunds({
    this.onClose,
    this.contribution,
    this.userContribution,
  });

  Widget build(BuildContext context) {
    final error = WalletFetchError(
      onRetry: () {
        final walletCubit = BlocProvider.of<WalletCubit>(context);
        walletCubit.refresh();
      },
      onClose: onClose,
    );

    Tuple2 turple = context.select<MyAppModel, Tuple2>(
        (model) => Tuple2(model.profile, model.userKYC));
    return BlocBuilder<WalletCubit, WalletsState>(
        //     buildWhen: (prevState, currState) {
        //   return prevState.latest != currState.latest;
        // },
        builder: (context, state) {
      final contrib = null;
      Widget body;
      // if (contrib == null) {
      //   body = const _Loader();
      // } else {
      body = BlocBuilder<WalletCubit, WalletsState>(
          buildWhen: (prevState, currState) {
        final prevSourceTokenAccount = prevState.tokenAccounts
            ?.firstWhereOrNull((tokenAccount) =>
                tokenAccount.token?.tokenSymbol == contrib.sourceToken);
        final currSourceTokenAccount = currState.tokenAccounts
            ?.firstWhereOrNull((tokenAccount) =>
                tokenAccount.token?.tokenSymbol == contrib.sourceToken);

        final prevDstTokenAccount = prevState.tokenAccounts?.firstWhereOrNull(
            (tokenAccount) =>
                tokenAccount.token?.tokenSymbol == contrib.destinationToken);
        final currDstTokenAccount = currState.tokenAccounts?.firstWhereOrNull(
            (tokenAccount) =>
                tokenAccount.token?.tokenSymbol == contrib.destinationToken);
        return (prevSourceTokenAccount != currSourceTokenAccount) ||
            (prevDstTokenAccount != currDstTokenAccount);
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
            body = StreamBuilder<UserContribution?>(
              initialData: userContribution,
              stream: WalletService.getUserContributionStream(
                  contrib.contributionId!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return error;
                } else {
                  final dstTokenAccount = state.tokenAccounts?.firstWhereOrNull(
                      (tokenAccount) =>
                          tokenAccount.token?.tokenSymbol ==
                          contrib.destinationToken);
                  final sourceTokenAccount = state.tokenAccounts
                      ?.firstWhereOrNull((tokenAccount) =>
                          tokenAccount.token?.tokenSymbol ==
                          contrib.sourceToken);
                  if (sourceTokenAccount == null || dstTokenAccount == null) {
                    return error;
                  } else {
                    return _ContributeFunds(
                      sourceTokenAccount,
                      dstTokenAccount,
                      contrib,
                      userContribution: snapshot.data,
                      onClose: onClose,
                      profile: turple.item1,
                      kyc: turple.item2,
                    );
                  }
                }
              },
            );
          }
        } else if (state.loadError != null) {
          body = error;
        } else {
          body = _Loader(
            onClose: onClose,
          );
        }
        return body;
      });

      return AnimatedSwitcher(duration: kThemeAnimationDuration, child: body);
    });
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

class Count extends StatelessWidget {
  final String value;
  final String label;
  const Count({
    required this.value,
    required this.label,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          "$value",
          style: theme.textTheme.subtitle1,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          "$label",
          style: theme.textTheme.caption,
        )
      ],
    );
  }
}

class _ContributeFunds extends StatefulWidget {
  final TokenAccount sourceTokenAccount;
  final TokenAccount destinationTokenAccount;
  final Contribution contribution;
  final UserContribution? userContribution;
  final UserProfile? profile;
  final UserKYC? kyc;
  final VoidCallback? onClose;

  _ContributeFunds(
      this.sourceTokenAccount, this.destinationTokenAccount, this.contribution,
      {this.onClose, this.userContribution, this.profile, this.kyc, Key? key})
      : super(key: key);

  @override
  _ContributeFundState createState() => _ContributeFundState();
}

class _ContributeFundState extends State<_ContributeFunds> {
  late TextEditingController _srcInputController;
  late TextEditingController _dstInputController;
  ValueNotifier<BigInt?> _amount = ValueNotifier<BigInt?>(null);
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  ValidationBloc? _addressValidator;
  StreamSubscription? _addressState;
  late ContributionsService _service;
  late CountdownTimerController _startCountDown;
  late WalletCubit _walletCubit;
  final inputFormatter = intl.NumberFormat(
    '##,###.####',
  );
  final dispFormatter = intl.NumberFormat(
    '##,###.###',
  );

  initState() {
    _srcInputController = TextEditingController();
    _dstInputController = TextEditingController();
    _amount.addListener(_validate);
    _srcInputController.addListener(_updateAmount);
    _walletCubit = context.read();
    _service = ContributionsService(
      client: context.read(),
      wallet: _walletCubit.state.wallet!,
      config: context.read(),
    );
    _startCountDown = CountdownTimerController(
        endTime: widget.contribution.startAt!.millisecondsSinceEpoch);
    _startCountDown.start();
    _initialize();
    super.initState();
  }

  Future<void> showSuccess(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    final paddingScaleFactor =
        WalletHelper.paddingScaleFactor(MediaQuery.of(context).textScaleFactor);
    final TextDirection? textDirection = Directionality.maybeOf(context);

    return showDialog(
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
                '${S.of(context).thank_you_participating}!',
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
                child: Icon(
                  Icons.check_circle,
                  size: _kIconSize,
                  color: isDark ? Colors.green[200] : Colors.green[400],
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Text(
                S.of(context).your_contribution_accepted_proccessing,
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
                          child: Text(S.of(context).dismiss),
                          onPressed: () => Navigator.of(context).pop())
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

  dispose() {
    _addressState?.cancel();
    _addressValidator?.dispose();
    _amount.removeListener(_validate);
    _srcInputController.removeListener(_validate);
    _srcInputController.dispose();
    _dstInputController.dispose();
    _startCountDown.dispose();
    super.dispose();
  }

  void _initialize() {
    final initialValue = widget.contribution.minAmount;
    _srcInputController.text = '${initialValue}';
    _updateAmountOnChaged(_srcInputController.text);
  }

  void _updateAmountOnChaged(String value) {
    final double amount = double.tryParse(value) ?? 0.0;
    _amount.value =
        BigInt.from(amount * math.pow(10, widget.sourceTokenAccount.decimals!));
  }

  _updateAmount() {
    final double amount = double.tryParse(_srcInputController.text) ?? 0.0;
    _dstInputController.text = '${inputFormatter.format(convert(amount))}';
    _amount.value =
        BigInt.from(amount * math.pow(10, widget.sourceTokenAccount.decimals!));
    _validate();
  }

  didUpdateWidget(_ContributeFunds old) {
    if (old.contribution != widget.contribution ||
        old.userContribution != widget.userContribution ||
        old.sourceTokenAccount != widget.sourceTokenAccount) {
      _updateAmount();
    }
    super.didUpdateWidget(old);
  }

  num convert(amount) {
    return amount * widget.contribution.rate;
  }

  void _validate() {
    final min = BigInt.from(
        minAmount * math.pow(10, widget.sourceTokenAccount.decimals!));
    final max = BigInt.from(
        safeMaxAmount * math.pow(10, widget.sourceTokenAccount.decimals!));
    final bool amountValid = _amount.value != null &&
        _amount.value! <= widget.sourceTokenAccount.amount! &&
        _amount.value! >= min &&
        _amount.value! <= max &&
        _amount.value! > BigInt.zero;
    _isValid.value = amountValid;
  }

  double get balance =>
      widget.sourceTokenAccount.amount! /
      BigInt.from(math.pow(10, widget.sourceTokenAccount.decimals!));

  Future<void> _send() async {
    try {
      if (maxContrubtionReached) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${S.of(context).sorry_target_contribution} ${inputFormatter.format(widget.contribution.targetAmountSourceToken)} ${widget.sourceTokenAccount.token!.tokenSymbol!}. Thank you for participating...")));
        return;
      }
      if (_loading.value) return;
      _loading.value = true;
      FocusScope.of(context).unfocus();
      await _service.deposit(
          _amount.value!.toInt(), widget.contribution.contributionId!);
      WalletCubit cubit = context.read();
      cubit.refresh();
      await showSuccess(context);
      _initialize();
      _validate();
    } on ContributionException catch (error) {
      print('ERROR: ${error.message}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? S.of(context).default_error_title)));
    } catch (error) {
      print('ERROR: ${error}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).default_error_title2)));
    } finally {
      _loading.value = false;
    }
  }

  Future<void> _claim() async {
    try {
      if (_loading.value) return;
      _loading.value = true;
      FocusScope.of(context).unfocus();
      await _service.claim();
      WalletCubit cubit = context.read();
      cubit.refresh();
    } on ContributionException catch (error) {
      print('ERROR: ${error.message}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? S.of(context).default_error_title)));
    } catch (error) {
      print('ERROR: ${error}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).default_error_title)));
    } finally {
      _loading.value = false;
    }
  }

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

  double get minAmount => widget.contribution.minAmount.toDouble();

  double get maxAmount => widget.contribution.maxAmount.toDouble();

  bool get maxContrubtionReached =>
      widget.contribution.totalAmountSourceToken >=
      widget.contribution.targetAmountSourceToken;

  double get safeMaxAmount {
    final maximumUserContrib = BigInt.from(widget.contribution.maxAmount *
        math.pow(10, widget.sourceTokenAccount.decimals!));
    final totalUserContrib =
        BigInt.from(widget.userContribution?.totalAmountSourceToken ?? 0);
    return (maximumUserContrib - totalUserContrib <
                widget.sourceTokenAccount.amount!
            ? maximumUserContrib - totalUserContrib
            : widget.sourceTokenAccount.amount!) /
        BigInt.from(math.pow(10, widget.sourceTokenAccount.decimals!));
  }

  Widget _buildInputs() {
    final theme = Theme.of(context);

    final decimals = widget.sourceTokenAccount.decimals;
    final balance = widget.sourceTokenAccount.amount! /
        BigInt.from(math.pow(10, widget.sourceTokenAccount.decimals!));
    final space = VSpace(Insets.ls);
    final enabled = widget.sourceTokenAccount.amount! > BigInt.zero;

    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _srcInputController,
            maxLines: 1,
            validator: (String? val) {
              final double? amount = double.tryParse(val!);
              if (amount == null) {
                return S.of(context).invalid_amount;
              } else if (amount < minAmount) {
                if (amount < balance) {
                  return '${S.of(context).minimum_contribution_of} ${inputFormatter.format(widget.contribution.minAmount)} ${widget.sourceTokenAccount.token!.tokenSymbol!} ${S.of(context).required}.';
                } else {
                  return '${S.of(context).minimum_contribution_of} ${inputFormatter.format(widget.contribution.minAmount)} ${widget.sourceTokenAccount.token!.tokenSymbol!} ${S.of(context).required}. ${S.of(context).balance} ${inputFormatter.format(balance)} ${widget.sourceTokenAccount.token!.tokenSymbol!}';
                }
              } else if (amount > balance) {
                return '${S.of(context).insufficient_funds}. ${S.of(context).balance} ${inputFormatter.format(balance)} ${widget.sourceTokenAccount.token!.tokenSymbol!}';
              } else if (amount > maxAmount) {
                return '${S.of(context).exceeded_maximum_amount} ${inputFormatter.format(maxAmount)} ${widget.sourceTokenAccount.token!.tokenSymbol!}';
              } else if (amount > safeMaxAmount) {
                return '${S.of(context).exceeded_remaining_amount} ${inputFormatter.format(safeMaxAmount)} ${widget.sourceTokenAccount.token!.tokenSymbol!} ${S.of(context).to_contribute}';
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,' + decimals.toString() + '}'))
            ],
            onChanged: (String value) {
              _updateAmountOnChaged(value);
            },
            //enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: false),
            decoration: InputDecoration(
              filled: true,
              // enabled: enabled,
              labelText: S.of(context).deposit,
              helperText:
                  '${S.of(context).balance}: ${inputFormatter.format(balance)}',
              suffixIcon: enabled
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: Text(S.of(context).max.toUpperCase()),
                              style: TextButton.styleFrom(
                                elevation: 0,
                                primary: theme.colorScheme.primary,
                                padding: EdgeInsets.all(0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: minAmount <= balance
                                  ? () {
                                      _srcInputController.text =
                                          '$safeMaxAmount';
                                      _updateAmountOnChaged(
                                          _srcInputController.text);
                                    }
                                  : null,
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          height: kMinInteractiveDimension,
                          child: Text(
                              '${widget.sourceTokenAccount.token!.tokenSymbol}',
                              style: theme.textTheme.subtitle1
                                  ?.copyWith(color: theme.hintColor)),
                          alignment: AlignmentDirectional.centerStart,
                          padding: EdgeInsets.only(right: 16.0),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          space,
          TextFormField(
            controller: _dstInputController,
            maxLines: 1,
            validator: (String? val) {
              if (val == null) {
                return S.of(context).invalid_address;
              } else {
                return null;
              }
            },
            autofocus: false,
            enabled: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: _getFillColor(theme, true),
              enabled: enabled,
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.brightness == Brightness.light
                      ? Colors.grey[200]!
                      : Colors.grey[800]!,
                ),
              ),
              labelText: S.of(context).you_receive,
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: kMinInteractiveDimension,
                    child: Text(
                        '${widget.destinationTokenAccount.token!.tokenSymbol}',
                        style: theme.textTheme.subtitle1
                            ?.copyWith(color: theme.hintColor)),
                    alignment: AlignmentDirectional.centerStart,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  )
                ],
              ),
            ),
          ),
          space,
          ValueListenableBuilder(
            valueListenable: _isValid,
            builder: (context, dynamic valid, child) => ProgressButton(
              _loading,
              label: Text(S.of(context).contribute.toUpperCase()),
              style: context.raisedStyle,
              //icon: Icon(Icons.send),
              onPressed: valid ? _send : null,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildClaim() {
    final theme = Theme.of(context);
    final totalUserContribution =
        (widget.userContribution?.totalAmountSourceToken ?? 0) /
            math.pow(10, widget.sourceTokenAccount.decimals!);
    final totalDstContribution =
        (widget.userContribution?.totalAmountDestinationTokenClaim ?? 0) /
            math.pow(10, widget.destinationTokenAccount.decimals!);
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark ? theme.hintColor : theme.dividerColor;
    final divider = Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      height: 40,
      child: VerticalDivider(
        color: dividerColor,
        width: 4.0,
        thickness: context.dividerHairLineWidth,
      ),
    );
    final style = Theme.of(context).textTheme.caption;
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.all(Insets.ls),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                borderRadius: kInputBorderRadius,
                color: _getFillColor(theme, true)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Count(
                    label: S.of(context).deposit,
                    value:
                        '${dispFormatter.format(totalUserContribution)} ${widget.contribution.sourceToken}',
                  ),
                ),
                divider,
                Expanded(
                  child: Count(
                    label: S.of(context).claims,
                    value:
                        '${dispFormatter.format(totalDstContribution)} ${widget.contribution.destinationToken}',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 64.0,
          ),
          Icon(
            Icons.check_circle,
            size: _kIconSize,
            color: isDark ? Colors.green[200] : Colors.green[300],
          ),
          SizedBox(
            height: 24.0,
          ),
          Text('${S.of(context).thank_you_participating}!!!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6),
          if (widget.userContribution != null &&
              widget.userContribution!.hasClaimed)
            Text(S.of(context).kuro_claimed_see_wallet,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption),
          if (widget.userContribution != null &&
              !widget.userContribution!.hasClaimed &&
              widget.userContribution!.hasContributed)
            Text(
                widget.contribution.claimMessage ??
                    S.of(context).kuro_will_distributed_sales_end,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption),
          Center(
            child: Text(
              "${widget.contribution.subTitle ?? ''}",
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          VSpace(Insets.ls),
          if (widget.userContribution != null &&
              !widget.userContribution!.hasClaimed &&
              widget.userContribution!.hasContributed)
            ProgressButton(_loading,
                label: Text(
                  S.of(context).claim_now,
                ),
                style: context.raisedStyle,
                //icon: Icon(Icons.send),
                onPressed: widget.contribution.canClaim ? _claim : null)
        ],
      ),
    );
  }

  Widget _buildForm() {
    final theme = Theme.of(context);
    final totalUserContribution =
        (widget.userContribution?.totalAmountSourceToken ?? 0) /
            math.pow(10, widget.sourceTokenAccount.decimals!);
    final totalDstContribution =
        (widget.userContribution?.totalAmountDestinationTokenClaim ?? 0) /
            math.pow(10, widget.destinationTokenAccount.decimals!);
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark ? theme.hintColor : theme.dividerColor;
    final divider = Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      height: 40,
      child: VerticalDivider(
        color: dividerColor,
        width: 4.0,
        thickness: context.dividerHairLineWidth,
      ),
    );
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.all(Insets.ls),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                borderRadius: kInputBorderRadius,
                color: _getFillColor(theme, true)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Count(
                    label: S.of(context).deposit,
                    value:
                        '${dispFormatter.format(totalUserContribution)} ${widget.contribution.sourceToken}',
                  ),
                ),
                divider,
                Expanded(
                  child: Count(
                    label: S.of(context).claims,
                    value:
                        '${dispFormatter.format(totalDstContribution)} ${widget.contribution.destinationToken}',
                  ),
                ),
              ],
            ),
          ),
          VSpace(Insets.ls),
          _buildBottom()
        ],
      ),
    );
  }

  Widget _buildBottom() {
    Widget body;
    if (widget.contribution.ended) {
      body = _ConributionEnded(contribution: widget.contribution);
    } else {
      body = _buildInputs();
    }

    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: body,
    );
  }

  Widget _buildMainContent() {
    final kycRequired = widget.contribution.kycRequired != null &&
        widget.contribution.kycRequired!;
    final loader = Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: const FeedLoader(),
      ),
    );
    Widget body;
    if (widget.profile == null) {
      body = loader;
    } else if (kycRequired && !widget.profile!.kycVerified) {
      body = const UnVerified();
    } else if (kycRequired &&
        widget.profile!.kycVerified &&
        widget.kyc == null) {
      body = loader;
    } else if (kycRequired &&
        widget.kyc != null &&
        _walletCubit.state.serviceAvailability!.serviceUnavailableRegions
            .contains(widget.kyc!.country)) {
      body = const WalletServiceUnavailable();
    } else if (widget.contribution.ended) {
      body = _buildClaim();
    } else {
      final formView = _buildForm();
      body = CountdownTimer(
        controller: _startCountDown,
        endWidget: formView,
        widgetBuilder: (_, CurrentRemainingTime? time) {
          return time != null ? ContributionTimeView(time) : formView;
        },
      );
    }
    return AnimatedSwitcher(duration: kThemeAnimationDuration, child: body);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${S.of(context).contribute} ${widget.sourceTokenAccount.token!.tokenSymbol}'),
        elevation: 0,
        centerTitle: true,
        leading: widget.onClose != null
            ? BackButton(onPressed: widget.onClose)
            : BackButton(onPressed: () => Navigator.of(context).pop()),
        actions: [
          IconButton(
              tooltip:
                  '${S.of(context).buy} ${widget.sourceTokenAccount.token!.tokenSymbol}',
              onPressed: () {
                //WalletHelper.buy(context, widget.sourceTokenAccount);
                showDepositDialog(context, widget.sourceTokenAccount);
              },
              icon: Icon(CupertinoIcons.purchased))
        ],
      ),
      body: Scrollbar(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        color: theme.appBarTheme.backgroundColor,
                        child: Column(
                          children: [
                            VSpace(Insets.xl),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PriceIcon(
                                  tokenAccount: widget.sourceTokenAccount,
                                  price: '1',
                                ),
                                HSpace(Insets.ls),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.grey[300],
                                ),
                                HSpace(Insets.ls),
                                PriceIcon(
                                  tokenAccount: widget.destinationTokenAccount,
                                  price:
                                      '${dispFormatter.format(widget.contribution.rate)}',
                                ),
                              ],
                            ),
                            VSpace(Insets.xl),

                            // VSpace(Insets.xl),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _buildMainContent(),
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
    );
  }
}
