import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../index.dart';
import '../../../bloc/index.dart';
import 'feed_search.dart';

class SearchCallFeedList extends StatelessWidget {
  final CallFeedBloc bloc;
  final String title;
  final ScrollController? controller;
  final String emptyText;
  final FeedSearchDelegate? delegate;
  SearchCallFeedList(this.bloc, this.title,
      {this.controller, this.emptyText = '', Key? key, this.delegate})
      : super(key: key);

  Widget _buildEmptySliver(BuildContext context, CallFeedLoaded state) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SliverToBoxAdapter(
      child: EmptyContent(
        title: AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          child: Text(
            emptyText,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
        ),
        icon: Icon(
          MdiIcons.calendarTextOutline,
          size: 96.0,
          color: isDark ? Colors.white38 : Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildErrorSliver(CallFeedError state) {
    return SliverToBoxAdapter(
      child: FeedErrorView(
        error: "Failed to fetch",
      ),
    );
  }

  Widget _buildLoadingSliver(CallFeedUninitialized state) {
    return SliverPadding(
      padding: EdgeInsets.all(24.0),
      sliver: SliverToBoxAdapter(
        child: FeedLoader(),
      ),
    );
  }

  Widget _buildResultsSliver(BuildContext context, CallFeedLoaded state) {
    return SliverList(
      //itemExtent: 116,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(); //CallFeedListItem(state.items[index]);
        },
        childCount: state.items.length,
      ),
    );
  }

  Widget _buildLoadMoreSliver(BuildContext context) {
    return SliverSafeArea(
      top: false,
      bottom: true,
      sliver: SliverToBoxAdapter(
        child: BottomCallFeedLoader(bloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadMore = _buildLoadMoreSliver(context);
    final fill = const SliverToBoxAdapter(
      child: SizedBox.shrink(),
    );
    return BlocBuilder(
      bloc: bloc,
      builder: (BuildContext context, CallFeedState state) {
        Widget body;
        if (state is CallFeedUninitialized) {
          body = _buildLoadingSliver(state);
        } else if (state is CallFeedError) {
          body = _buildErrorSliver(state);
        } else if (state is CallFeedLoaded) {
          if (state.isEmpty) {
            body = _buildEmptySliver(context, state);
          } else {
            body = _buildResultsSliver(context, state);
          }
        } else {
          body = fill;
        }

        return CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            body,
            loadMore,
          ],
        );
      },
    );
  }
}
