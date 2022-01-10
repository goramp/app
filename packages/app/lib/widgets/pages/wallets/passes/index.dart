import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/models/customer.dart';
import 'package:goramp/widgets/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../../bloc/index.dart';
import '../../../../models/index.dart';

const _kMaxWidth = 400.0;
const kMaxCards = 3;

class TimePasses extends StatefulWidget {
  const TimePasses({Key? key}) : super(key: key);

  @override
  _TimePassesState createState() => _TimePassesState();
}

class _TimePassesState extends State<TimePasses> {
  ValueNotifier<bool> _loadingCheckout = ValueNotifier<bool>(false);

  void _add() async {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text('NFT ${S.of(context).timepass_coming_soon}')));
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // final style = ElevatedButton.styleFrom(
    //   elevation: 0,
    //   textStyle: theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: kInputBorderRadius,
    //   ),
    // );

    return SliverToBoxAdapter(
      child: EmptyContent(
        title: Text(
          "${S.of(context).your} NFT ${S.of(context).time_passes_appear_here}",
          style: theme.textTheme.caption,
          textAlign: TextAlign.center,
        ),
        icon: Icon(
          MdiIcons.creditCardMultipleOutline,
          size: 96.0,
          color: isDark ? Colors.white38 : Colors.grey[300],
        ),
        // action: ProgressButton(_loadingCheckout,
        //     label: Text(
        //       'Add NFT Time Pass',
        //     ),
        //     style: style,
        //     icon: Icon(MdiIcons.creditCardPlusOutline),
        //     onPressed: _add),
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
              '${S.of(context).fetching_card}...',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCardButton(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: ValueListenableBuilder(
        valueListenable: _loadingCheckout,
        builder: (_, dynamic loading, __) {
          return ListTile(
            leading: SizedBox(
              height: 32.0,
              width: 32.0,
              child: Icon(
                MdiIcons.creditCardPlusOutline,
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              S.of(context).add_payment_method,
              style: theme.textTheme.subtitle2!
                  .copyWith(color: theme.colorScheme.primary),
            ),
            trailing: loading
                ? SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: PlatformCircularProgressIndicator(
                      theme.colorScheme.primary,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.primary,
                  ),
            onTap: loading ? null : _add,
          );
        },
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return SliverToBoxAdapter(
      child: SliverToBoxAdapter(
        child: CenteredWidget(
          FeedErrorView(
            error: '${S.of(context).fail_fetch_card}...',
            onRefresh: () {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    final List<Widget> slivers = [
      SliverOverlapInjector(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      ),
    ];
    slivers.add(_buildEmpty(context));
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: Material(
        color: Colors.transparent,
        child: CenteredWidget(
            CustomScrollView(
              slivers: slivers,
            ),
            maxWidth: _kMaxWidth),
      ),
    );
  }
}
