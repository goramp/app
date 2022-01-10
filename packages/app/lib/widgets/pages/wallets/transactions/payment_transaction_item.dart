import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:goramp/widgets/index.dart';
import '../../../../models/index.dart';
import './grouped.dart';
import 'utils.dart';

class PaymentAmount extends StatelessWidget {
  final TextStyle? style;
  final PaymentTransaction transaction;

  PaymentAmount(this.transaction, {this.style});

  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final effectiveStyle = style ?? theme.textTheme.subtitle1!;
    return Text(
      amountString(transaction),
      style: effectiveStyle.copyWith(
          color: colorForTransaction(context, transaction.transactionType)),
      textAlign: TextAlign.right,
    );
  }
}

class PaymentTitle extends StatelessWidget {
  final TextStyle? style;
  final PaymentTransaction transaction;

  PaymentTitle(this.transaction, {this.style});

  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final effectiveStyle = style ?? theme.textTheme.subtitle1;
    return Text(
      transaction.name!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: effectiveStyle,
    );
  }
}

class PaymentSubTitle extends StatelessWidget {
  final TextStyle? style;
  final PaymentTransaction transaction;

  PaymentSubTitle(this.transaction, {this.style});

  Widget build(
    BuildContext context,
  ) {
    return Text(
      transaction.description ?? '',
      style: style?.withCanvaskitFontFix,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class PaymentType extends StatelessWidget {
  final TextStyle? style;
  final PaymentTransaction transaction;

  PaymentType(this.transaction, {this.style});

  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    final effectiveStyle = style ?? theme.textTheme.caption!;
    return Text(
      typeString(transaction),
      style: effectiveStyle.copyWith(
          color: colorForTransaction(context, transaction.transactionType)),
      textAlign: TextAlign.right,
    );
  }
}

class PaymentIcon extends StatelessWidget {
  final PaymentTransaction transaction;

  PaymentIcon(this.transaction);

  Widget build(
    BuildContext context,
  ) {
    Widget icon;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foregroundColor =
        colorForTransaction(context, transaction.transactionType);
    //theme.colorScheme.primaryVariant;
    if (transaction.transactionType == PaymentTransactionType.payment) {
      icon = Icon(
        CupertinoIcons.arrow_up_right,
      );
    } else if (transaction.transactionType == PaymentTransactionType.payout) {
      icon = Icon(
        CupertinoIcons.arrow_down_left,
      );
    } else {
      icon = Icon(
        CupertinoIcons.arrow_2_circlepath,
      );
    }
    return CircleAvatar(
      child: icon,
      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
      foregroundColor: foregroundColor,
    );
  }
}

class PaymentTransactionItemView extends StatelessWidget {
  final PaymentTransaction transaction;

  PaymentTransactionItemView(this.transaction);

  Widget build(
    BuildContext context,
  ) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: PaymentTitle(transaction),
        ),
        HSpace(Insets.ls),
        PaymentAmount(transaction)
      ]),
      subtitle:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: PaymentSubTitle(transaction),
        ),
        HSpace(Insets.ls),
        PaymentType(transaction)
      ]),
      leading: PaymentIcon(transaction),
      onTap: () {
        final WalletState state = context.read();
        state.showTransaction(transaction);
      },
    );
  }
}

class PayoutTransactionItemView extends StatelessWidget {
  final PaymentTransaction transaction;

  PayoutTransactionItemView(this.transaction);

  Widget build(
    BuildContext context,
  ) {
    return ListTile(
      title: Row(
        children: [],
      ),
    );
  }
}

class PaymentTransactionItem extends StatelessWidget {
  final GroupedPaymentTransactionItem item;
  final VoidCallback? onTapped;
  final PaymentTransaction? selectedTransaction;
  final double? parentWidth;
  final bool isCompact;
  final bool isLast;

  PaymentTransactionItem(this.item,
      {Key? key,
      this.selectedTransaction,
      this.onTapped,
      this.parentWidth,
      this.isCompact = false,
      this.isLast = false})
      : super(key: key);

  Widget build(
    BuildContext context,
  ) {
    if (item is GroupedPaymentTransactionSectionHeaderItem) {
      return GroupedPaymentTransactionSectionHeaderItemView(
        item as GroupedPaymentTransactionSectionHeaderItem,
      );
    }
    if (item is GroupedPaymentTransactionHeaderItem) {
      return GroupedPaymentTransactionHeaderItemView(
          item as GroupedPaymentTransactionHeaderItem);
    }
    if (item is GroupedPaymentTransactionListItem) {
      final myItem = item as GroupedPaymentTransactionListItem;
      return PaymentTransactionItemView(myItem.paymentTransaction);
    }
    if (item is GroupedScheduleDividerItem) {
      return Divider(
        height: context.dividerHairLineWidth,
        thickness: context.dividerHairLineWidth,
      );
    }
    return const SizedBox.shrink();
  }
}
