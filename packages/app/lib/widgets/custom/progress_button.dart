import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';

class ProgressButton extends StatelessWidget {
  final ValueNotifier<bool> loading;
  final VoidCallback? onPressed;
  final Widget? label;
  final Widget icon;
  final ButtonStyle? style;
  ProgressButton(this.loading,
      {this.onPressed,
      this.label,
      this.icon = const SizedBox.shrink(),
      this.style});

  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final ButtonStyle raisedButtonStyle = style ?? context.raisedStyle;
    // ElevatedButton.styleFrom(
    //   elevation: 0,
    //   textStyle:
    //       theme.textTheme.button.copyWith(fontWeight: FontWeight.bold),
    //   // primary: _kStripeColor,
    //   // onPrimary: Colors.white,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: kInputBorderRadius,
    //   ),
    // );

    return ValueListenableBuilder(
      builder: (context, bool loading, child) {
        final iconWidget = loading ? child! : icon;
        return ElevatedButton.icon(
          style: raisedButtonStyle,
          icon: iconWidget,
          label: label!,
          onPressed: loading ? null : onPressed,
        );
      },
      valueListenable: loading,
      child: SizedBox(
        height: 18.0,
        width: 18.0,
        child: PlatformCircularProgressIndicator(
          theme.colorScheme.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
