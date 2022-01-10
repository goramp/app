import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:browser_adapter/browser_adapter.dart';
import 'package:goramp/widgets/custom/fetch_error.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/me/tabs.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../services/index.dart';
import '../../../bloc/index.dart';
import '../../../models/index.dart';

class ProfilePage extends StatefulWidget {
  final String? username;
  final UserProfile? profile;
  final VoidCallback? onClose;
  ProfilePage(
    this.username, {
    Key? key,
    this.profile,
    this.onClose,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  _handleClose() {
    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? body;
    return FutureBuilder<UserProfile?>(
      initialData: widget.profile,
      future: UserService.getProfileByUsername(widget.username!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          body = _Profile(
            profile: snapshot.data,
            onClose: _handleClose,
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            body = Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: _handleClose,
                ),
                elevation: 0,
              ),
              body: FetchError(
                S.of(context).failed_to_load_profile,
                onRetry: () {
                  setState(() {});
                },
              ),
            );
          } else if (snapshot.data == null) {
            body = Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: _handleClose,
                ),
                elevation: 0,
              ),
              body: FetchError(
                S.of(context).profile_not_found,
                onRetry: () {
                  setState(() {});
                },
              ),
            );
          }
        } else {
          body = Scaffold(
            appBar: AppBar(
              elevation: 0,
            ),
            body: const FeedLoader(),
          );
        }
        return AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          child: body,
        );
      },
    );
  }
}

class _Profile extends StatefulWidget {
  final UserProfile? profile;
  final VoidCallback? onClose;

  const _Profile({Key? key, this.profile, this.onClose}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> with TickerProviderStateMixin {
  TabController? _tabController;
  PublicCallLinksBloc? _publicCallLinksBloc;
  MyCallLinksBloc? _likedCallLinksBloc;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    _publicCallLinksBloc =
        PublicCallLinksBloc(useUsername: false, userId: widget.profile!.uid);
    MyAppModel appModel = context.read();
    if (widget.profile != null && appModel.currentUser != null) {
      _likedCallLinksBloc = MyCallLinksBloc(
        authBloc: BlocProvider.of<AuthenticationBloc>(context),
        fetchFilter: MyCallLinksFetchFilter.LIKED_EVENTS,
        useUsername: false,
        hostId: appModel.currentUser!.id == widget.profile!.uid
            ? null
            : widget.profile!.uid,
        userId: appModel.currentUser!.id,
      );
    }
  }

  dispose() {
    _tabController?.dispose();
    _publicCallLinksBloc?.close();
    _controller.dispose();
    super.dispose();
  }

  handleClose() {
    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      Navigator.of(context).pop();
    }
  }

  List<Widget> _buildHeaderSlivers(
    BuildContext context,
    bool innerBoxIsScrolled,
  ) {
    return <Widget>[
      SliverToBoxAdapter(
        child: Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: StreamBuilder(
            stream: UserService.getProfileStream(widget.profile!.uid),
            initialData: widget.profile,
            builder:
                (BuildContext context, AsyncSnapshot<UserProfile?> snapshot) {
              return ProfileUserDetail(snapshot.data);
            },
          ),
        ),
      ),
      SliverOverlapAbsorber(
        // This widget takes the overlapping behavior of the SliverAppBar,
        // and redirects it to the SliverOverlapInjector below. If it is
        // missing, then it is possible for the nested "inner" scroll view
        // below to end up under the SliverAppBar even when the inner
        // scroll view thinks it has not been scrolled.
        // This is not necessary if the "headerSliverBuilder" only builds
        // widgets that do not overlap the next sliver.
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverPersistentHeader(
          pinned: true,
          delegate: MyProfileTabBarDelegate(
              controller: _tabController, isScrolled: innerBoxIsScrolled),
        ),
      ),
    ];
  }

  Widget _buildTabContent(User user, UserProfile? profile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MyFavoriteTab(
      key: PageStorageKey('favorites'),
      emptyContent: profile?.uid == user.id
          ? null
          : EmptyContent(
              title: Text(
                S.of(context).no_likes_here,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                "${S.of(context).not_like_any_call_link} @${profile!.username}",
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),
              icon: Icon(
                Icons.event_note_outlined,
                size: 96.0,
                color: isDark ? Colors.white38 : Colors.grey[300],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = isDisplayDesktop(context);
    final user =
        context.select<MyAppModel, User?>((model) => model.currentUser);
    final tabs = [
      Selector<MyAppModel, UserProfile?>(
          builder: (context, profile, child) {
            Widget body;
            if (user == null) {
              body = BlocProvider.value(
                value: _publicCallLinksBloc!,
                child: PublicCallLinksTab(
                  key: PageStorageKey('public_call_links'),
                ),
              );
            } else if (profile == null) {
              body = const FeedLoader();
            } else if (profile.uid == widget.profile!.uid) {
              body = CallLinksTab(
                key: PageStorageKey('my_call_links'),
              );
            } else {
              body = BlocProvider.value(
                value: _publicCallLinksBloc!,
                child: PublicCallLinksTab(
                  key: PageStorageKey('public_call_links'),
                ),
              );
            }
            return AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: body,
            );
          },
          selector: (context, appModel) => appModel.profile),
      user == null
          ? EmptyContent(
              title: Text(
                S.of(context).login_view_liked_calls,
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),
              icon: Icon(
                Icons.event_note_outlined,
                size: 96.0,
                color: isDark ? Colors.white38 : Colors.grey[300],
              ),
              action: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  textStyle: theme.textTheme.button!
                      .copyWith(fontWeight: FontWeight.bold),
                  shape: const RoundedRectangleBorder(
                    borderRadius: kInputBorderRadius,
                  ),
                ),
                icon: Icon(Icons.upload_rounded),
                label: Text(
                  S.of(context).log_in,
                ),
                onPressed: () async {
                  await showLoginDialog(
                    context: context,
                  );
                },
              ),
            )
          : _likedCallLinksBloc != null
              ? BlocProvider.value(
                  value: _likedCallLinksBloc!,
                  child: _buildTabContent(user, widget.profile))
              : Selector<MyAppModel, UserProfile?>(
                  builder: (context, profile, child) {
                    if (profile == null) {
                      return const FeedLoader();
                    }
                    return BlocProvider(
                        create: (context) {
                          return MyCallLinksBloc(
                            authBloc:
                                BlocProvider.of<AuthenticationBloc>(context),
                            fetchFilter: MyCallLinksFetchFilter.LIKED_EVENTS,
                            useUsername: false,
                            hostId: widget.profile!.uid == profile.uid
                                ? null
                                : widget.profile!.uid,
                            userId: user.id,
                          );
                        },
                        child: _buildTabContent(user, profile));
                  },
                  selector: (context, appModel) => appModel.profile)
    ];
    Widget tab = isDesktop
        ? TabBarSwitcher(
            controller: _tabController,
            // These are the contents of the tab views, below the tabs.
            children: tabs)
        : TabBarView(
            controller: _tabController,
            // These are the contents of the tab views, below the tabs.
            children: tabs);
    tab = SafeArea(
      top: false,
      bottom: false,
      left: true,
      right: true,
      child: tab,
      minimum: getExtraPadding(),
    );

    return Provider.value(
      value: widget.profile,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: StreamBuilder<UserProfile?>(
            initialData: widget.profile,
            stream: UserService.getProfileStream(widget.profile!.uid),
            builder: (_, snapshot) {
              return Text(
                snapshot.data?.username ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              );
            },
          ),
          elevation: 0,
          leading: BackButton(
            onPressed: handleClose,
          ),
        ),
        body: Scrollbar(
          controller: _controller,
          child: NestedScrollView(
              controller: _controller,
              headerSliverBuilder: _buildHeaderSlivers,
              body: tab),
        ),
      ),
    );
  }
}
