import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/models/payment_provider.dart';
import 'package:goramp/services/payment_transactions_service.dart';
import 'package:goramp/widgets/custom/fetch_error.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/link.dart' as urlLink;
import 'package:goramp/generated/l10n.dart';
import 'utils.dart';

const _kPaddingHorizontalEdge = 24.0;

class PaymentTransactionDetail extends StatefulWidget {
  final String transactionId;
  final PaymentTransaction? transaction;
  const PaymentTransactionDetail(this.transactionId, {this.transaction});

  @override
  _PaymentTransactionDetailState createState() =>
      _PaymentTransactionDetailState();
}

class _PaymentTransactionDetailState extends State<PaymentTransactionDetail> {
  Widget _buildDetail(BuildContext context, PaymentTransaction transaction) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Color iconColor = isDark ? Colors.white : Colors.black45;
    final iconTheme = IconTheme.of(context);
    iconColor = iconColor.withOpacity(iconColor.opacity * iconTheme.opacity!);
    final fieldStyle = theme.textTheme.subtitle2!
        .copyWith(color: theme.textTheme.caption!.color);
    final separator = VSpace(32.0);
    final AppConfig config = Provider.of(context, listen: false);

    return Material(
        elevation: 0,
        borderRadius: kMediumBorderRadius,
        color: Colors.transparent,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: _kPaddingHorizontalEdge),
                  subtitle: SelectableText(ReCase(transaction.name!).titleCase,
                      style: theme.textTheme.subtitle1),
                  title: Text(
                    S.of(context).item_name,
                    style: fieldStyle,
                  ),
                ),
                separator,
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: _kPaddingHorizontalEdge),
                  subtitle: SelectableText(
                      ReCase(transaction.description!).titleCase,
                      style: theme.textTheme.subtitle1),
                  title: Text(
                    S.of(context).item_description,
                    style: fieldStyle,
                  ),
                ),
                separator,
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: _kPaddingHorizontalEdge),
                  title: Text(
                    S.of(context).transaction_type,
                    style: fieldStyle,
                  ),
                  subtitle: SelectableText(
                    typeString(transaction),
                    style: theme.textTheme.subtitle1!.copyWith(
                      color: colorForTransaction(
                          context, transaction.transactionType),
                    ),
                  ),
                ),
                separator,
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: _kPaddingHorizontalEdge),
                  title: Text(
                    S.of(context).date,
                    style: fieldStyle,
                  ),
                  subtitle: SelectableText(
                      formatDate(context, transaction.createdAt!),
                      style: theme.textTheme.subtitle1),
                ),
                separator,
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: _kPaddingHorizontalEdge),
                  title: Text(
                    S.of(context).amount,
                    style: fieldStyle,
                  ),
                  subtitle: SelectableText(amountString(transaction),
                      style: theme.textTheme.subtitle1),
                ),
                separator,
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: _kPaddingHorizontalEdge),
                  title: Text(
                    S.of(context).fee,
                    style: fieldStyle,
                  ),
                  subtitle: SelectableText(feeString(transaction),
                      style: theme.textTheme.subtitle1),
                ),
                separator,
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: _kPaddingHorizontalEdge),
                  title: Text(
                    S.of(context).transaction_id,
                    style: fieldStyle,
                  ),
                  subtitle: SelectableText(transaction.transactionId!,
                      style: theme.textTheme.subtitle1),
                ),
                if (transaction.externalTransactionId != null &&
                    transaction.providerId == SOLANA_PAYMENT_PROVIDER) ...[
                  separator,
                  urlLink.Link(
                    uri: Uri.parse(
                        'https://explorer.solana.com/tx/${transaction.externalTransactionId}?cluster=${config.solanaCluster}'),
                    target: UniversalPlatform.isWeb
                        ? urlLink.LinkTarget.blank
                        : urlLink.LinkTarget.self,
                    builder: (context, onTap) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: _kPaddingHorizontalEdge),
                        title: Text(
                          S.of(context).transaction_signature,
                          style: fieldStyle,
                        ),
                        subtitle: SelectableText(
                            transaction.externalTransactionId!,
                            style: theme.textTheme.subtitle1!
                                .copyWith(color: theme.colorScheme.secondary)),
                        onTap: onTap,
                        onLongPress: onTap,
                      );
                    },
                  ),
                ]
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget? body;
    MyAppModel appModel = Provider.of(context, listen: false);
    return FutureBuilder<PaymentTransaction?>(
      initialData: widget.transaction,
      future: PaymentTransactionService.getPaymentTransaction(
          widget.transactionId, appModel.currentUser!.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          body = Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).details),
              elevation: 0,
            ),
            body: _buildDetail(context, snapshot.data!),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            body = Scaffold(
              appBar: AppBar(
                elevation: 0,
              ),
              body: FetchError(
                S.of(context).failed_to_fetch_transaction,
                onRetry: () {
                  setState(() {});
                },
              ),
            );
          } else if (snapshot.data == null) {
            body = Scaffold(
              appBar: AppBar(
                elevation: 0,
              ),
              body: FetchError(
                S.of(context).failed_to_fetch_transaction,
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
