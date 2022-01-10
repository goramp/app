import 'package:flutter/material.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/generated/l10n.dart';

typedef FuturePageItemBuilder<T> = Widget Function(
    BuildContext context, T item);

class FuturePage<T> extends StatefulWidget {
  final T? initialItem;
  final Future<T> future;
  final FuturePageItemBuilder<T> contentBuilder;
  FuturePage(this.future, this.contentBuilder, {this.initialItem});

  @override
  State<StatefulWidget> createState() {
    return _FuturePageLoaderState<T>();
  }
}

class _FuturePageLoaderState<T> extends State<FuturePage<T?>> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    if (widget.initialItem != null) {
      return widget.contentBuilder(context, widget.initialItem);
    }
    return FutureBuilder<T?>(
      initialData: widget.initialItem,
      future: widget.future,
      builder: (context, snapshot) {
        Widget body;
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            body = widget.contentBuilder(context, snapshot.data);
          } else {
            body = Scaffold(
              appBar: AppBar(),
              body: EmptyContent(
                title: Text(
                  S.of(context).default_error_title2,
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
                icon: Icon(
                  Icons.warning,
                  size: 96.0,
                  color: isDark ? Colors.white38 : Colors.grey[300],
                ),
                action: TextButton(
                  child: Text(S.of(context).retry.toUpperCase()),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ),
            );
          }
        } else {
          body = Scaffold(
            body: const FeedLoader(),
          );
        }
        return AnimatedSwitcher(
          child: body,
          duration: kThemeAnimationDuration,
        );
      },
    );
  }
}
