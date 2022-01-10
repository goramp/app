import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/bloc/wallet/claims_cubit.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:goramp/services/wallets/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/wallets/transactions/utils.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../models/index.dart';

const kMaxCards = 3;

class _ClaimItem extends StatefulWidget {
  final RewardClaim claim;
  _ClaimItem(this.claim);
  @override
  State<StatefulWidget> createState() {
    return _ClaimItemState();
  }
}

class _ClaimItemState extends State<_ClaimItem> {
  ValueNotifier<bool> _loading = ValueNotifier(false);
  late ClaimService _service;

  Future<void> _claim() async {
    try {
      if (_loading.value) return;
      _loading.value = true;
      WalletCubit walletCubit = context.read();
      await _service.claim(widget.claim.id,
          walletAddress: walletCubit.state.wallet?.publicKey);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Your claim has been accepted and we are now processing it."),
        ),
      );
    } on ClaimException catch (error) {
      print('ERROR: ${error.message}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? StringResources.DEFAULT_ERROR_TITLE)));
    } catch (error, stack) {
      print('ERROR: ${error}');
      print('STACK: $stack');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringResources.DEFAULT_ERROR_TITLE)));
    } finally {
      _loading.value = false;
    }
  }

  Future<void> showSuccess(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    final paddingScaleFactor =
        WalletHelper.paddingScaleFactor(MediaQuery.of(context).textScaleFactor);
    final TextDirection? textDirection = Directionality.maybeOf(context);

    return showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final EdgeInsets effectiveTitlePadding =
            const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0)
                .resolve(textDirection);
        final titleWidget = Padding(
          padding: EdgeInsets.only(
            left: effectiveTitlePadding.left * paddingScaleFactor,
            right: effectiveTitlePadding.right * paddingScaleFactor,
            top: effectiveTitlePadding.top * paddingScaleFactor,
            bottom: effectiveTitlePadding.bottom,
          ),
          child: DefaultTextStyle(
            style: DialogTheme.of(context).titleTextStyle ??
                theme.textTheme.headline6!,
            child: Semantics(
              namesRoute: false,
              container: true,
              child: Text(
                'Thank you!',
                // textAlign: TextAlign.center,
              ),
            ),
          ),
        );
        final EdgeInsets effectiveContentPadding =
            const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 16.0)
                .resolve(textDirection);
        Widget contentWidget = Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: effectiveContentPadding.left * paddingScaleFactor,
              right: effectiveContentPadding.right * paddingScaleFactor,
              top: effectiveContentPadding.top * paddingScaleFactor,
              bottom: effectiveContentPadding.bottom * paddingScaleFactor,
            ),
            child: Column(children: [
              const SizedBox(
                height: 24.0,
              ),
              Center(
                child: Icon(
                  Icons.check_circle,
                  size: 96.0,
                  color: isDark ? Colors.green[200] : Colors.green[400],
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Text(
                "Your claim has been accepted and we are now processing it.",
              ),
            ]),
          ),
        );

        Widget dialogChild = IntrinsicWidth(
          stepWidth: 56.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                titleWidget,
                contentWidget,
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  constraints: const BoxConstraints(minHeight: 56.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OverflowBar(
                    spacing: 8,
                    //alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                          child: Text("Dismiss"),
                          onPressed: () => Navigator.of(context).pop())
                    ],
                  ),
                )
              ],
            ),
          ),
        );
        return Dialog(
            // titleTextStyle: theme.textTheme.headline6,
            child: dialogChild);
      },
    );
  }

  initState() {
    _service = ClaimService(
      client: context.read(),
      config: context.read(),
    );
    super.initState();
  }

  dispose() {
    super.dispose();
  }

  Color? _colorForClaim(BuildContext context, RewardClaim claim) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Color? color = Colors.black87;
    if (claim.status == 'pending') {
      color = isDark ? Colors.amber[200]! : Colors.amber[400]!;
    } else if (claim.status == 'claimed') {
      color = isDark ? Colors.green[200]! : Colors.green[400]!;
    } else if (claim.status == 'failed') {
      color = isDark ? Colors.red[200]! : Colors.red[400]!;
    } else {
      color = isDark ? Colors.amber[200]! : Colors.amber[400]!;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 16,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              height: 40,
              width: 40,
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.surface,
                child: PlatformSvg.asset(COINS.KURO, width: 40, height: 40),
              ),
            ),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.claim.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  HSpace(Insets.ls),
                  Text(
                    toFormattedAmount(widget.claim.amount, widget.claim.decimal,
                        widget.claim.currency),
                    style: theme.textTheme.subtitle1!
                        .copyWith(color: _colorForClaim(context, widget.claim)),
                    textAlign: TextAlign.right,
                  )
                ]),
            subtitle: Text(
              '${intl.DateFormat('MMM d, yyyy').format(widget.claim.createdAt!)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.caption,
            ),
          ),
          if (widget.claim.description != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url,
                        webOnlyWindowName: '_blank',
                        forceSafariVC: true,
                        forceWebView: true,
                        enableJavaScript: true);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: widget.claim.description!,
                style: theme.textTheme.bodyText1,
                linkStyle: theme.textTheme.bodyText1
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
            ),
          if (widget.claim.photoUrl != null)
            Container(
              height: 200,
              color: widget.claim.backgroundColor != null
                  ? ColorsExtensions.fromHex(widget.claim.backgroundColor!)
                  : null,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: widget.claim.photoUrl!,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              widget.claim.status != 'claimed'
                  ? ValueListenableBuilder(
                      builder: (context, bool loading, child) {
                        return TextButton(
                          style: context.stadiumRoundTextStyle,
                          child: loading
                              ? child!
                              : const Text(
                                  'CLAIM',
                                ),
                          onPressed: loading ? null : _claim,
                        );
                      },
                      valueListenable: _loading,
                      child: EllipsisLoader(
                        color: theme.colorScheme.primary,
                        size: 14.0,
                      ),
                    )
                  : Chip(
                      avatar: Container(
                        height: 24.0,
                        width: 24.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 24.0,
                          color: isDark ? Colors.green[200] : Colors.green[400],
                        ),
                      ),
                      label: Text("Claimed"),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: theme.dividerColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class Claims extends StatefulWidget {
  final VoidCallback? onClose;
  const Claims({this.onClose, Key? key}) : super(key: key);

  @override
  _ClaimsState createState() => _ClaimsState();
}

class _ClaimsState extends State<Claims> {
  ScrollController _scrollController = ScrollController();

  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    ClaimsCubit cubit = context.read();
    bool hasReachedMax = cubit.state.hasReachedMax;
    if (hasReachedMax) return;
    // print("on scroll check: ${maxScroll - currentScroll} vs $kFeedScrollThreshold");
    if (maxScroll - currentScroll <= kFeedScrollThreshold) {
      cubit.loadMore();
    }
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: EmptyContent(
        title: Text(
          "Nothing here",
          style: theme.textTheme.caption,
          textAlign: TextAlign.center,
        ),
        icon: const EmptyIcons(),
      ),
    );
  }

  Widget _buildLoader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 64.0,
            ),
            const FeedLoader(),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              'Fetching claims...',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSliver(BuildContext context, List<RewardClaim> claims) {
    return SliverPadding(
      padding: EdgeInsets.all(12.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, i) => Container(
                  alignment: Alignment.center,
                  child: _ClaimItem(claims[i]),
                ),
            childCount: claims.length),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return SliverToBoxAdapter(
      child: SliverToBoxAdapter(
        child: CenteredWidget(
          FeedErrorView(
            error: 'Failed to fetch claims...',
            onRefresh: () {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder<ClaimsCubit, ClaimsCubitState>(
        builder: (context, state) {
      final List<Widget> slivers = [
        SliverAppBar(
          title: Text('Claims'),
          elevation: 0,
          actions: [const SizedBox.shrink()],
          leading: widget.onClose != null
              ? BackButton(onPressed: widget.onClose)
              : BackButton(onPressed: () => Navigator.of(context).pop()),
        )
      ];
      if (state.claims != null) {
        if (state.claims!.isEmpty) {
          slivers.add(_buildEmpty(context));
        } else {
          slivers.add(_buildResultsSliver(context, state.claims!));
        }
      } else if (state.error != null) {
        slivers.add(_buildError(context));
      } else {
        slivers.add(_buildLoader(context));
      }
      if (state.loading && !state.hasReachedMax) {
        slivers.add(
          SliverSafeArea(
            top: false,
            bottom: true,
            sliver: Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: PlatformCircularProgressIndicator(
                      Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ),
        );
      }
      return Scaffold(
        body: CustomScrollView(
          slivers: slivers,
        ),
      );
    });
  }
}
