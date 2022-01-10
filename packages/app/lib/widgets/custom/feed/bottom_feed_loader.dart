import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/index.dart';
import '../platform_circular_progress_indicator.dart';

class BottomFeedLoader extends StatefulWidget {
  final BaseFeedBloc bloc;
  BottomFeedLoader(this.bloc);
  @override
  State<StatefulWidget> createState() {
    return _BottomFeedLoaderState();
  }
}

class _BottomFeedLoaderState extends State<BottomFeedLoader> {
  @override
  void initState() {
    super.initState();
    _handleLoadMore(widget.bloc.state);
  }

  _handleBlocState(BuildContext context, FeedState feedState) {
    _handleLoadMore(feedState);
  }

  _handleLoadMore(FeedState feedState) {
    if (feedState is FeedLoaded) {
      if (!feedState.hasReachedMax) {
        widget.bloc.add(FetchFeedItems());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.bloc,
      listener: _handleBlocState,
      child: BlocBuilder(
        bloc: widget.bloc,
        builder: (BuildContext context, FeedState state) {
          if (state is FeedLoaded && !state.hasReachedMax) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: PlatformCircularProgressIndicator(
                      Theme.of(context).colorScheme.secondary),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class BottomCallFeedLoader extends StatefulWidget {
  final CallFeedBloc bloc;
  BottomCallFeedLoader(this.bloc);
  @override
  State<StatefulWidget> createState() {
    return _BottomCallFeedLoaderState();
  }
}

class _BottomCallFeedLoaderState extends State<BottomCallFeedLoader> {
  @override
  void initState() {
    super.initState();
    _handleLoadMore(widget.bloc.state);
  }

  _handleBlocState(BuildContext context, CallFeedState feedState) {
    _handleLoadMore(feedState);
  }

  _handleLoadMore(CallFeedState feedState) {
    if (feedState is CallFeedLoaded) {
      if (!feedState.hasReachedMax) {
        widget.bloc.add(FetchCallFeedItems());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.bloc,
      listener: _handleBlocState,
      child: BlocBuilder(
        bloc: widget.bloc,
        builder: (BuildContext context, CallFeedState state) {
          if (state is CallFeedLoaded && !state.hasReachedMax) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: PlatformCircularProgressIndicator(
                      Theme.of(context).colorScheme.secondary),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
