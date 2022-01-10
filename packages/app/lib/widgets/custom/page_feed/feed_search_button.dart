import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/custom/page_feed/recent_search_delegate.dart';
import 'package:goramp/widgets/index.dart';
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';

class FeedSearchButton extends StatefulWidget {
  final CallFeedBloc bloc;

  const FeedSearchButton(this.bloc);

  @override
  _FeedSearchButtonState createState() => _FeedSearchButtonState();
}

class _FeedSearchButtonState extends State<FeedSearchButton> {
  SearchBloc? _searchBloc;

  initState() {
    AppConfig config = context.read();
    _searchBloc = SearchBloc(config: config);
    super.initState();
  }

  dispose() {
    _searchBloc?.close();
    super.dispose();
  }

  Widget _feedSearchButton(BuildContext context, VoidCallback onPressed) {
    ThemeData theme = Theme.of(context);
    final radius = const BorderRadius.all(Radius.circular(6.0));
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return Material(
      elevation: 0.0,
      color: isDark ? theme.dividerColor : Colors.grey[300],
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 12.0),
              Icon(Icons.search, color: theme.textTheme.caption!.color),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  S.of(context).search,
                  style: theme.textTheme.subtitle1!
                      .copyWith(color: theme.textTheme.caption!.color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: OpenContainer<Call>(
        transitionType: ContainerTransitionType.fade,
        openColor: Theme.of(context).colorScheme.background,
        closedColor: Colors.transparent,
        openBuilder: (BuildContext context, VoidCallback _) {
          return FeedSearchPage(
            delegate: RecentCallDelegate(_searchBloc),
          );
        },
        tappable: false,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return _feedSearchButton(context, openContainer);
        },
        onClosed: (Call? schedule) {},
        closedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        closedElevation: 0,
      ),
    );
  }
}
