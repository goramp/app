import 'package:flutter/material.dart';
import 'package:goramp/widgets/index.dart';

class FeedErrorView extends StatelessWidget {
  final String error;
  final bool center;
  final VoidCallback? onRefresh;

  FeedErrorView({this.error = "", this.onRefresh, this.center = true});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment:
              center ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              error,
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: theme.errorColor,
                  ),
            ),
            SizedBox(
              height: Insets.ls,
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
              ),
              onPressed: onRefresh,
            ),
          ],
        ),
      ),
    );
  }
}
