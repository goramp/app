import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/wallet/wallet_provider/inapp_wallet.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';

Future<WalletProvider?> showPaymentMethodsDialog(BuildContext context) async {
  return await showDialog<WalletProvider>(
    context: context,
    builder: (context) {
      AppConfig config = Provider.of(context, listen: false);
      InAppWalletProvider defaultWalletProvider =
          Provider.of(context, listen: false);
      final providers = <WalletProvider>[
        defaultWalletProvider,
        ...WalletProvider.getExternalWalletProviders(
            network: config.solanaCluster!)
      ];
      final allWidgets = <Widget>[];
      final widgetCount = math.max(0, providers.length * 2 - 1);
      for (int i = 0; i < widgetCount; ++i) {
        final int itemIndex = i ~/ 2;
        const separator = Divider(
          indent: 72.0,
        );
        final Widget widget;
        if (i.isEven) {
          widget = ListTile(
            leading:
                PlatformImage.asset(providers[itemIndex].iconUrl, width: 32),
            title: Text('${providers[itemIndex].name}'),
            onTap: () {
              Navigator.of(context).pop(providers[itemIndex]);
            },
          );
        } else {
          widget = separator;
        }
        allWidgets.add(widget);
      }
      return SimpleDialog(title: Text('Select Wallet'), children: allWidgets);
    },
  );
}

class WalletConnectButton extends StatefulWidget {
  final ButtonStyle? style;
  final String? text;
  const WalletConnectButton({this.style, this.text});
  @override
  State<StatefulWidget> createState() {
    return WallerConnectState();
  }
}

class WallerConnectState extends State<WalletConnectButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletsState>(builder: (context, state) {
      final theme = Theme.of(context);
      final ButtonStyle raisedButtonStyle = widget.style ?? context.raisedStyle;
      return ElevatedButton.icon(
        style: raisedButtonStyle,
        icon: state.connecting
            ? SizedBox(
                height: 18.0,
                width: 18.0,
                child: PlatformCircularProgressIndicator(
                  theme.colorScheme.primary,
                  strokeWidth: 2,
                ),
              )
            : const SizedBox.shrink(),
        label: Text(state.connecting
            ? S.of(context).connecting
            : state.connected
                ? S.of(context).disconnect
                : S.of(context).connect),
        onPressed:
            state.connecting ? null : () => WalletHelper.connect(context, true),
      );
    });
  }
}
