import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/widgets/custom/progress_button.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/cluster.dart';
import 'package:goramp/widgets/pages/wallets/crypto/detail.dart';
import 'package:goramp/widgets/pages/wallets/crypto/wallet_security.dart';
import 'package:intl/intl.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:qr_utils/qr_utils.dart';

class SendFundsPage extends StatelessWidget {
  final String token;
  final TokenAccount? tokenAccount;
  final VoidCallback? onClose;
  SendFundsPage(this.token, {this.tokenAccount, this.onClose});

  @override
  Widget build(BuildContext context) {
    return TokenLoaderPage(
      token,
      (context, tokenAccount) {
        return SendFunds(tokenAccount, onClose: onClose);
      },
      tokenAccount: tokenAccount,
    );
  }
}

class SendFunds extends StatefulWidget {
  final TokenAccount? tokenAccount;
  final VoidCallback? onClose;
  SendFunds(this.tokenAccount, {this.onClose, Key? key}) : super(key: key);

  @override
  _SendFundState createState() => _SendFundState();
}

class _SendFundState extends State<SendFunds> {
  TextEditingController? _amountInputController;
  TextEditingController? _addressInputController;
  ValueNotifier<BigInt?> _amount = ValueNotifier<BigInt?>(null);
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  ValidationBloc? _addressValidator;
  StreamSubscription? _addressState;
  late WalletService _service;

  initState() {
    _amountInputController = TextEditingController();
    _addressInputController = TextEditingController();
    _amount.addListener(_validate);
    _addressInputController!.addListener(_validate);
    _addressValidator = ValidationBloc<String?>(
      AddressValidator('address', context.read(),
          mint: widget.tokenAccount!.token!.mintAddress, context:context),
    );
    _addressInputController!.addListener(() {
      _addressValidator!.onTextChanged.add(_addressInputController!.text);
    });
    _addressState = _addressValidator!.state.listen((state) {
      _validate();
    });
    WalletCubit cubit = context.read();
    _service = WalletService(
        client: context.read(),
        wallet: cubit.state.wallet!,
        config: context.read());
    super.initState();
  }

  dispose() {
    _addressState?.cancel();
    _addressValidator?.dispose();
    _amount.removeListener(_validate);
    _addressInputController!.removeListener(_validate);
    _amountInputController?.dispose();
    _addressInputController?.dispose();
    super.dispose();
  }

  bool get canShowQR =>
      (UniversalPlatform.isWeb && isQRScanningSupported()) ||
      (UniversalPlatform.isAndroid || UniversalPlatform.isIOS);

  void _showQRScanner() async {
    if (!canShowQR) {
      return;
    }
    // final address = await Navigator.of(context).push<String>(
    //   MaterialPageRoute(
    //       builder: (BuildContext context) {
    //         return QRCapture(
    //             // validator: (String result) {
    //             //   final isValid = isValidAddress(result);
    //             //   return isValid;
    //             // },
    //             );
    //       },
    //       fullscreenDialog: true),
    // );
    // if (address != null) {
    //   _addressInputController!.text = address;
    // }
  }

  void _updateAmountOnChaged(String value) {
    final double amount = double.tryParse(value) ?? 0.0;
    _amount.value =
        BigInt.from(amount * pow(10, widget.tokenAccount!.decimals!));
  }

  void _validate() {
    final bool amountValid = _amount.value != null &&
        _amount.value! <= widget.tokenAccount!.amount! &&
        _amount.value! > BigInt.zero;
    final addressState = _addressValidator!.state.value;
    final bool addressValid =
        (addressState is ValidationResult && addressState.isValid);
    _isValid.value = amountValid && addressValid;
  }

  Widget? _buildScanner() {
    if (canShowQR) {
      final theme = Theme.of(context);
      return Material(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 48.0,
          height: 48.0,
          child: IconButton(
            icon: Icon(Icons.qr_code_scanner_outlined),
            visualDensity: VisualDensity.compact,
            onPressed: _showQRScanner,
            color: theme.colorScheme.primary,
            tooltip: '${S.of(context).scan} QR',
          ),
        ),
      );
    }
    return null;
  }

  double get balance =>
      widget.tokenAccount!.amount! /
      BigInt.from(pow(10, widget.tokenAccount!.decimals!));

  Future<void> _send() async {
    try {
      if (_loading.value) return;
      _loading.value = true;
      FocusScope.of(context).unfocus();
      final address = _addressInputController!.text.trim();
      await _service.transferTokens(widget.tokenAccount!.address, address,
          _amount.value!, widget.tokenAccount!.token!.mintAddress!);
      WalletCubit cubit = context.read();
      cubit.refresh();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).transaction_successful)));
      await Future.delayed(
          Duration(
            milliseconds: 400,
          ),
          () => Navigator.of(context).pop());
    } on WalletServiceException catch (error) {
      WalletHelper.handleError(context, error);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).default_error_title)));
    } finally {
      _loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final formatter = NumberFormat(
      '##,###.####',
    );
    final decimals = widget.tokenAccount!.decimals;
    final balance = widget.tokenAccount!.amount! /
        BigInt.from(pow(10, widget.tokenAccount!.decimals!));
    final space = VSpace(Insets.ls);
    final enabled = widget.tokenAccount!.amount! > BigInt.zero;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${S.of(context).send} ${widget.tokenAccount!.token!.tokenSymbol}'),
        elevation: 0,
        leading: widget.onClose != null
            ? BackButton(onPressed: widget.onClose)
            : BackButton(onPressed: () => Navigator.of(context).pop()),
        actions: [const ClusterChip()],
      ),
      body: Scrollbar(
        child: LayoutBuilder(builder:
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
                      child: Container(
                        color: theme.scaffoldBackgroundColor,
                        padding: EdgeInsets.all(Insets.ls),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            VSpace(Insets.ls),
                            TextFormField(
                              controller: _amountInputController,
                              maxLines: 1,
                              validator: (String? val) {
                                final double? amount = double.tryParse(val!);
                                if (amount == null) {
                                  return S.of(context).invalid_amount;
                                } else {
                                  return null;
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'^\d*\.?\d{0,' +
                                        decimals.toString() +
                                        '}'))
                              ],
                              onChanged: (String value) {
                                _updateAmountOnChaged(value);
                              },
                              enabled: enabled,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: false),
                              decoration: InputDecoration(
                                filled: true,
                                enabled: enabled,
                                labelText: S.of(context).amount,
                                helperText:
                                    '${S.of(context).max}: ${formatter.format(balance)}',
                                suffixIcon: enabled
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            child: Text(S
                                                .of(context)
                                                .max
                                                .toUpperCase()),
                                            style: TextButton.styleFrom(
                                              elevation: 0,
                                              primary:
                                                  theme.colorScheme.primary,
                                              padding: EdgeInsets.all(0),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity:
                                                  VisualDensity.compact,
                                            ),
                                            onPressed: () {
                                              _amountInputController!.text =
                                                  '$balance';
                                              _updateAmountOnChaged(
                                                  _amountInputController!.text);
                                            },
                                          )
                                        ],
                                      )
                                    : null,
                              ),
                            ),
                            space,
                            StreamBuilder<ValidationState>(
                              stream: _addressValidator!.state,
                              initialData: ValidationNoTerm(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<ValidationState> snapshot) {
                                final state = snapshot.data;
                                String? _errorText;
                                if (state is ValidationResult &&
                                    !state.isValid) {
                                  _errorText =
                                      state.fieldError!.errors[0].message;
                                }
                                return TextFormField(
                                  controller: _addressInputController,
                                  maxLines: 1,
                                  validator: (String? val) {
                                    if (val == null) {
                                      return S.of(context).invalid_address;
                                    } else {
                                      return null;
                                    }
                                  },
                                  autofocus: false,
                                  enabled: enabled,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      filled: true,
                                      enabled: enabled,
                                      labelText:
                                          S.of(context).destination_address,
                                      helperText:
                                          '${S.of(context).enter} Solana ${S.of(context).address}',
                                      suffixIcon:
                                          enabled ? _buildScanner() : null,
                                      errorText: _errorText),
                                );
                              },
                            ),
                            space,
                            ValueListenableBuilder(
                              valueListenable: _isValid,
                              builder: (context, dynamic valid, child) =>
                                  ProgressButton(
                                _loading,
                                label: Text(
                                  S.of(context).send.toUpperCase(),
                                ),
                                style: context.raisedStyle,
                                icon: Icon(Icons.send),
                                onPressed: valid ? _send : null,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    VSpace(Insets.ls),
                    const WalletSecurityFooter(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
