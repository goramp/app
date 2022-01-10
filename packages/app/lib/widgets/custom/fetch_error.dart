import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/generated/l10n.dart';

class FetchError extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onClose;
  final String message;
  const FetchError(this.message, {this.onRetry, this.onClose, Key? key})
      : super(key: key);
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    return EmptyContent(
      title: Text(
        message,
        style: Theme.of(context).textTheme.caption,
        textAlign: TextAlign.center,
      ),
      icon: Icon(
        Icons.warning,
        size: 96.0,
        color: isDark ? Colors.white38 : Colors.grey[300],
      ),
      action: onRetry != null
          ? TextButton(
              child: Text(S.of(context).retry.toUpperCase()),
              onPressed: onRetry,
            )
          : SizedBox.shrink(),
    );
  }
}
