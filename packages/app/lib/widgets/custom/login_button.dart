import 'package:flutter/material.dart';
import 'package:goramp/widgets/utils/index.dart';

class LoginButton extends StatelessWidget {
  final String? text;
  final bool? loading;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final double? height;

  LoginButton(
      {Key? key,
      this.text,
      this.loading,
      this.onPressed,
      this.padding = const EdgeInsets.all(8.0),
      this.height = 48.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      elevation: onPressed == null ? 0 : 2.0,
      textStyle: theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold),
      shape: const RoundedRectangleBorder(
        borderRadius: kInputBorderRadius,
      ),
      primary: onPressed == null
          ? theme.colorScheme.surface
          : theme.colorScheme.primary,
      onPrimary: onPressed == null
          ? theme.colorScheme.onSurface.withOpacity(0.38)
          : theme.colorScheme.onPrimary,
    );
    return Container(
      child: SafeArea(
        top: false,
        child: Container(
          height: height,
          padding: padding,
          child: ElevatedButton(
              //padding: EdgeInsets.only(left: 16.0),
              style: raisedButtonStyle,
              child: Center(
                child: loading!
                    ? SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary),
                        ),
                      )
                    : Text(
                        text!,
                      ),
              ),
              onPressed: onPressed),
        ),
      ),
    );
  }
}
