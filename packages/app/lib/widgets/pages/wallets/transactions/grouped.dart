import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:intl/intl.dart';

abstract class GroupedPaymentTransactionItem extends Equatable {}

class GroupedPaymentDividerItem extends GroupedPaymentTransactionItem {
  List<Object> get props => [];
}

class GroupedPaymentTransactionHeaderItem
    extends GroupedPaymentTransactionItem {
  final bool active;
  final bool borderTop;
  final bool borderBottom;
  GroupedPaymentTransactionHeaderItem(
      {this.dateTime,
      List<PaymentTransaction>? transactions,
      this.active = false,
      this.borderTop = false,
      this.borderBottom = false});
  final DateTime? dateTime;
  List<Object?> get props => [
        dateTime,
        active,
        borderTop,
        borderTop,
      ];
}

class GroupedPaymentTransactionSectionHeaderItem
    extends GroupedPaymentTransactionItem {
  GroupedPaymentTransactionSectionHeaderItem(
      {this.key, this.description, this.showSeeAll = true});
  final String? key;
  final String? description;
  final bool showSeeAll;
  List<Object?> get props => [key, description, showSeeAll];
}

class GroupedPaymentTransactionListItem extends GroupedPaymentTransactionItem {
  GroupedPaymentTransactionListItem(this.paymentTransaction,
      {required List<PaymentTransaction> transactions})
      : this.isFirst =
            paymentTransaction.transactionId == transactions[0].transactionId,
        this.isLast = paymentTransaction.transactionId ==
            transactions[transactions.length - 1].transactionId;
  final PaymentTransaction paymentTransaction;
  final bool isFirst;
  final bool isLast;
  List<Object> get props => [paymentTransaction, isFirst, isLast];
}

class GroupedPaymentTransactionHeaderItemView extends StatelessWidget {
  final GroupedPaymentTransactionHeaderItem headerItem;
  const GroupedPaymentTransactionHeaderItemView(this.headerItem);
  @override
  Widget build(BuildContext context) {
    return GroupCallSectionHeader(
      title: '${DateFormat('MMM d, yyyy').format(headerItem.dateTime!)}',
      active: headerItem.active,
      borderBottom: headerItem.borderBottom,
      borderTop: headerItem.borderTop,
    );
  }
}

class GroupedPaymentTransactionSectionHeaderItemView extends StatelessWidget {
  final GroupedPaymentTransactionSectionHeaderItem headerItem;
  const GroupedPaymentTransactionSectionHeaderItemView(this.headerItem);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Divider(
          height: context.dividerHairLineWidth,
          thickness: context.dividerHairLineWidth,
        ),
        Expanded(
          child: Container(
            padding:
                EdgeInsets.only(left: 12.0, top: 0.0, bottom: 0.0, right: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  headerItem.description!,
                  style: theme.textTheme.headline5!.copyWith(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
