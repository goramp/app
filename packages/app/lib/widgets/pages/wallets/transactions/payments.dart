import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:goramp/bloc/payment_transactions.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/wallets/transactions/grouped.dart';
import 'package:goramp/widgets/pages/wallets/transactions/payment_transaction_item.dart';
import 'package:goramp/generated/l10n.dart';
import '../../../../models/index.dart';

const _kMaxWidth = 400.0;
const kMaxCards = 3;

class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
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
    PaymentTransactionsCubit cubit = context.read();
    bool hasReachedMax = cubit.state.hasReachedMax;
    if (hasReachedMax) return;
    // print("on scroll check: ${maxScroll - currentScroll} vs $kFeedScrollThreshold");
    if (maxScroll - currentScroll <= kFeedScrollThreshold) {
      cubit.loadMore();
    }
  }

  List<List<GroupedPaymentTransactionItem>> _group(
      List<PaymentTransaction> transactions,
      {bool borderBottom = true,
      bool borderTop = true}) {
    List<List<GroupedPaymentTransactionItem>> sections = [];
    Map<DateTime, List<PaymentTransaction>> groupedTransactions =
        groupBy<PaymentTransaction, DateTime>(
            transactions,
            (obj) => DateTime(
                obj.createdAt!.year, obj.createdAt!.month, obj.createdAt!.day));

    groupedTransactions.entries
        .forEach((MapEntry<DateTime, List<PaymentTransaction>> entry) {
      List<GroupedPaymentTransactionItem> grouped = [];
      bool isFirst = true;
      grouped.add(GroupedPaymentTransactionHeaderItem(
          dateTime: entry.key,
          transactions: entry.value,
          borderBottom: borderBottom,
          borderTop: isFirst ? false : borderTop));
      isFirst = false;
      //grouped.add(GroupedScheduleDividerItem());
      grouped.addAll(
        entry.value.map(
          (PaymentTransaction transaction) => GroupedPaymentTransactionListItem(
              transaction,
              transactions: entry.value),
        ),
      );
      // grouped.add(GroupedScheduleDividerItem());
      sections.add(grouped);
      // grouped.add(GroupedScheduleDividerItem());
    });
    return sections;
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: EmptyContent(
        title: Text(
          S.of(context).nothing_here,
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
              '${S.of(context).fetching_payments}...',
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildResultsSliver(
      BuildContext context, List<PaymentTransaction> transactions) {
    final items = _group(transactions);
    return items.map((e) {
      return SliverStickyHeader.builder(
        sticky: true,
        builder: (context, state) {
          return Container(
            height: 30,
            color: Theme.of(context).colorScheme.background,
            child: PaymentTransactionItem(
              e.first,
            ),
          );
        },
        sliver: SliverFixedExtentList(
          itemExtent: 80.0,
          delegate: SliverChildBuilderDelegate(
              (context, i) => Container(
                    alignment: Alignment.center,
                    child: PaymentTransactionItem(
                      e[i + 1],
                      isLast: i == e.length - 2,
                    ),
                  ),
              childCount: e.length - 1),
        ),
      );
    }).toList();
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
    return BlocBuilder<PaymentTransactionsCubit, PaymentTransactionsState>(
        builder: (context, state) {
      final List<Widget> slivers = [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
      ];
      if (state.transactions != null) {
        if (state.transactions!.isEmpty) {
          slivers.add(_buildEmpty(context));
        } else {
          slivers.addAll(_buildResultsSliver(context, state.transactions!));
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
    });
  }
}
