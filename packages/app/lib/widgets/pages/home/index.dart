import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/home/view.dart';
import 'package:provider/provider.dart';
import '../../custom/index.dart';
import '../../../bloc/index.dart';

class Home extends StatefulWidget {
  final String title;
  final ValueNotifier<int>? orderTypeFilter;
  const Home(
    this.title, {
    this.orderTypeFilter,
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> _hasElevation = ValueNotifier<bool>(false);
  SearchBloc? _searchBloc;

  void initState() {
    _scrollController.addListener(_onScroll);
    AppConfig config = context.read();
    _searchBloc = SearchBloc(config: config);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  CallFeedBloc get bloc {
    return BlocProvider.of<CallFeedBloc>(context);
  }

  SearchBloc? get searchBloc {
    return _searchBloc;
  }

  ScrollController get scrollController => _scrollController;

  ValueNotifier<bool> get hasElevation => _hasElevation;

  _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    CallFeedState state = bloc.state;
    if (state is CallFeedLoaded) {
      bool hasReachedMax = state.hasReachedMax;
      if (hasReachedMax) return;
    }
    // print("on scroll check: ${maxScroll - currentScroll} vs $kFeedScrollThreshold");
    if (maxScroll - currentScroll <= kFeedScrollThreshold) {
      bloc.add(FetchCallFeedItems());
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (ScrollUpdateNotification notification) {
        if ((notification.metrics.pixels > 0)) {
          if (!_hasElevation.value) {
            _hasElevation.value = true;
          }
        } else if ((notification.metrics.pixels <= 0)) {
          if (_hasElevation.value) {
            _hasElevation.value = false;
          }
        }
        return false;
      },
      child: MultiProvider(
        providers: [
          Provider<HomeState>.value(value: this),
        ],
        child: HomeView(this),
      ),
    );
  }
}
