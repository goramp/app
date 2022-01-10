import 'package:flutter/material.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:goramp/widgets/index.dart';

class LoginErrors extends StatelessWidget {
  final List<String> errors;
  final VoidCallback? onClear;
  LoginErrors(this.errors, {this.onClear});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: kInputBorderRadius, color: theme.errorColor),
        width: context.panelMaxWidth,
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.only(bottom: 16.0),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: errors
                    .map((e) => Text(
                          e,
                          style: theme.textTheme.caption
                              ?.copyWith(color: theme.colorScheme.onError),
                        ))
                    .toList(),
              ),
            ),
            if (onClear != null)
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                      iconSize: 16,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: theme.colorScheme.onError,
                      ),
                      onPressed: onClear),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
