import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../bloc/index.dart';
import '../../../models/index.dart';
import 'call_tile.dart';
import 'base_page_feed.dart';
import '../feed/index.dart';
import '../../utils/index.dart';

class CallScrollableList extends BaseFeedWidget {
  final ValueChanged<Call>? onCallSlected;
  final BaseFeedBloc<Call> bloc;
  final BaseFeedItemBuilder<Call>? itemBuilder;
  CallScrollableList(this.bloc,
      {Key? key,
      ValueNotifier<int>? page,
      ValueChanged<int>? onSelected,
      EdgeInsets padding = kHorizontalListPadding,
      double itemExtent = TILE_ITEM_WIDTH,
      this.itemBuilder,
      this.onCallSlected})
      : assert(itemExtent != null),
        super(
            page: page,
            key: key,
            onSelected: onSelected,
            padding: padding,
            itemExtent: itemExtent);

  @override
  _CallScrollableList createState() {
    return _CallScrollableList();
  }
}

class _CallScrollableList extends BasePageFeedState<CallScrollableList, Call> {
  _CallScrollableList();

  BaseFeedBloc<Call> getBloc() {
    return widget.bloc;
  }

  int compare(Call a, Call b) {
    return a.scheduledAt!.compareTo(b.scheduledAt!);
  }

  Widget buildLoader(FeedUninitialized state) {
    return FeedLoader();
  }

  handlePreviewStateChange(BuildContext context, PreviewState previewState) {}

  Widget buildError(FeedError state) {
    return FeedErrorView(
      error: S.of(context).failed_to_fetch_schedules,
      onRefresh: refresh,
    );
  }

  Widget buildEmpty(FeedLoaded state) {
    return EmptyPageFeed(S.of(context).no_upcoming_event);
  }

  bool hasState(PageControllerPreviewState state) {
    return state is CallPreviewState;
  }

  bool equal(Call a, Call b) {
    return a.id == b.id;
  }

  Widget buildItem(BuildContext context, FeedLoaded state, int index,
      bool isSelected, double width) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, state.items[index], index);
    }
    MyAppModel model = Provider.of<MyAppModel>(context);
    User? user = model.currentUser;
    return CallPageTile(
      key: ObjectKey(state.items[index]),
      schedule: state.items[index],
      isSelected: isSelected,
      user: user,
      onTap: () {
        onSelected(state, index);
        if (widget.onCallSlected != null) {
          widget.onCallSlected!(state.items[index]);
        }
      },
    );
  }
}
