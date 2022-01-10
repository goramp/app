import 'dart:math' as math;
import 'package:animations/animations.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/cluster.dart';
import 'package:goramp/widgets/pages/wallets/crypto/contribute.dart';
import 'package:goramp/widgets/pages/wallets/crypto/deposit.dart';
import 'package:goramp/widgets/pages/wallets/crypto/price_builder.dart';
import 'package:goramp/widgets/pages/wallets/crypto/send.dart';
import 'package:goramp/widgets/pages/wallets/crypto/swap.dart';
import 'package:goramp/widgets/pages/wallets/crypto/wallet_security.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/widgets/index.dart';
import 'package:intl/intl.dart';
import 'package:sized_context/sized_context.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../bloc/index.dart';
import 'package:goramp/generated/l10n.dart';

const _kMaxWidth = 400.0;

class _ActionButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  final String? label;

  _ActionButton({this.icon, this.onTap, this.label});

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = onTap == null
        ? theme.colorScheme.primary.withOpacity(0.4)
        : theme.colorScheme.primary;
    final iconColor = onTap == null
        ? theme.colorScheme.onPrimary.withOpacity(0.4)
        : theme.colorScheme.onPrimary;
    final iconEl = SizedBox(
      width: 48.0,
      height: 48.0,
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
    Widget el = CupertinoButton(
        //padding: EdgeInsets.zero,

        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Column(
            children: [
              Container(
                child: iconEl,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeColor,
                ),
              ),
              VSpace(Insets.m),
              Text(
                label!,
                style: theme.textTheme.button!.copyWith(color: activeColor),
              ),
            ],
          ),
        ),
        onPressed: onTap);
    if (label != null) {
      el = Tooltip(
        message: label!,
        child: el,
      );
    }
    return el;
  }
}

class CryptoIcon extends StatelessWidget {
  final TokenAccount tokenAccount;
  final double? size;
  const CryptoIcon({
    required this.tokenAccount,
    Key? key,
    this.size = 64,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size!,
      height: size!,
      child: PlatformSvg.asset(
        tokenAccount.token!.icon!,
        width: size,
        height: size,
      ),
    );
  }
}

class CoinHeaderBalance extends StatelessWidget {
  final TokenAccount? tokenAccount;
  const CoinHeaderBalance({
    this.tokenAccount,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletsState>(
        buildWhen: (prevState, currState) {
      final prevToken = prevState.tokenAccounts?.firstWhereOrNull((account) =>
              account.token?.mintAddress == tokenAccount!.token?.mintAddress) ??
          null;
      final currToken = currState.tokenAccounts?.firstWhereOrNull((account) =>
              account.token?.mintAddress == tokenAccount!.token?.mintAddress) ??
          null;
      return prevToken != currToken;
    }, builder: (context, state) {
      final account = state.tokenAccounts?.firstWhereOrNull((account) =>
              account.token?.mintAddress == tokenAccount!.token?.mintAddress) ??
          null;
      final formatter = NumberFormat(
        '##,###.####',
      );
      final balance =
          account!.amount! / BigInt.from(math.pow(10, account.decimals!));
      final theme = Theme.of(context);
      return Column(children: [
        VSpace(Insets.ls),
        CryptoIcon(
          tokenAccount: account,
        ),
        VSpace(Insets.ls),
        Text(
          '${formatter.format(balance)} ${tokenAccount!.token!.tokenSymbol}',
          style:
              theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
        ),
        USDCryptoPriceItem(
          tokenAccount!.token!.tokenSymbol!.toUpperCase(),
          (_, price, format) {
            final balance = tokenAccount!.amount! /
                BigInt.from(math.pow(10, tokenAccount!.decimals!));

            final usdVal = balance * price;
            return Text('≈${format.format(usdVal)}');
          },
        ),
      ]);
    });
  }
}

class _TokenHeader extends StatelessWidget {
  final TokenAccount? tokenAccount;

  const _TokenHeader({
    this.tokenAccount,
    Key? key,
  }) : super(key: key);

  Widget build(
    BuildContext context,
  ) {
    double maxWidth = 500;
    if (context.widthInches > 8) {
      //Panel size gets a little bigger as the screen size grows
      maxWidth += (context.widthInches - 8) * 12;
    }
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.all(32.0).copyWith(bottom: 0),
        child: Column(
          children: [
            CoinHeaderBalance(
              tokenAccount: tokenAccount,
            ),
            VSpace(Insets.ls),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  icon: CupertinoIcons.arrow_up,
                  onTap: () {
                    final _TokenDetailState state = context.read();
                    state.showSend();
                  },
                  label: S.of(context).send,
                ),
                _ActionButton(
                  icon: CupertinoIcons.arrow_down,
                  onTap: () {
                    final _TokenDetailState state = context.read();
                    state.showReceive();
                  },
                  label: S.of(context).receive,
                ),
                if (tokenAccount!.token!.canBuy)
                  _ActionButton(
                    icon: CupertinoIcons.purchased,
                    onTap: () async {
                      final _TokenDetailState state = context.read();
                      if (tokenAccount!.token!.mintAddress ==
                              KUROMain.mintAddress ||
                          tokenAccount!.token!.mintAddress ==
                              KINMain.mintAddress) {
                        state.swap(USDCMain, tokenAccount!.token!);
                      } else {
                        WalletHelper.buy(context, tokenAccount!);
                      }
                    },
                    label: S.of(context).buy,
                  ),
                if (tokenAccount!.token!.canSwap)
                  _ActionButton(
                    icon: CupertinoIcons.arrow_swap,
                    onTap: () async {
                      final _TokenDetailState state = context.read();
                      if (tokenAccount!.token!.mintAddress ==
                          USDCMain.mintAddress) {
                        state.swap(tokenAccount!.token!, KUROMain);
                      } else {
                        state.swap(tokenAccount!.token!, USDCMain);
                      }
                      // if (tokenAccount!.token!.mintAddress ==
                      //         KUROMain.mintAddress ||
                      //     tokenAccount!.token!.mintAddress ==
                      //         KINMain.mintAddress) {
                      //   state.swap(tokenAccount!.token!, USDCMain);
                      // } else {
                      //   state.swap(tokenAccount!.token!, KUROMain);
                      // }
                    },
                    label: S.of(context).swap,
                  ),
                // _ActionButton(
                //   icon: CupertinoIcons.rectangle_on_rectangle,
                //   onTap: () async {
                //     await Clipboard.setData(
                //         ClipboardData(text: tokenAccount!.address));
                //     await ScaffoldMessenger.of(context)
                //         .showSnackBar(SnackBar(content: Text('Copied')));
                //   },
                //   label: 'Copy',
                // ),
                // _ActionButton(
                //   icon: CupertinoIcons.arrow_swap,
                //   label: 'Swap',
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TokenDetailView extends WidgetView<TokenDetail, _TokenDetailState> {
  TokenDetailView(_TokenDetailState state, {Key? key}) : super(state, key: key);
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
              '${S.of(context).fetching_transactions}...',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return SliverToBoxAdapter(
      child: EmptyContent(
        title: Text(
          S.of(context).no_transactions,
          style: theme.textTheme.caption,
          textAlign: TextAlign.center,
        ),
        icon: Icon(
          MdiIcons.alert,
          size: 96.0,
          color: isDark ? Colors.white38 : Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return SliverToBoxAdapter(
      child: CenteredWidget(
        FeedErrorView(
          error: '${S.of(context).failed_fetch_transactions}...',
          onRefresh: () {
            final walletCubit = BlocProvider.of<WalletCubit>(context);
            walletCubit.refresh();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final transactionsUrl =
        WalletHelper.addressUrl(context, widget.tokenAccount!.address);
    return BlocBuilder<TransactionsCubit, TransactionsState>(
        bloc: state.cubit,
        builder: (context, state) {
          final List<Widget> slivers = [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
          ];

          slivers.add(
            SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(Insets.ls),
                            child: UniversalPlatform.isWeb
                                ? Link(
                                    uri: Uri.parse(transactionsUrl),
                                    target: UniversalPlatform.isWeb
                                        ? LinkTarget.blank
                                        : LinkTarget.self,
                                    builder: (context, onTap) {
                                      return OutlinedButton.icon(
                                          icon: Icon(Icons.open_in_new),
                                          label: Text(S
                                              .of(context)
                                              .view_all_transactions),
                                          onPressed: onTap);
                                    },
                                  )
                                : OutlinedButton.icon(
                                    icon: Icon(Icons.open_in_new),
                                    label: Text(
                                        S.of(context).view_all_transactions),
                                    onPressed: () async {
                                      if (await canLaunch(transactionsUrl)) {
                                        launch(transactionsUrl,
                                            forceSafariVC: true,
                                            forceWebView: true,
                                            enableJavaScript: true);
                                      }
                                    }),
                          ),
                        ),
                      ),
                      const WalletSecurityFooter(),
                    ],
                  ),
                )),
          );
          if (state.transactions != null) {
            // if (state.transactions.isEmpty) {
            //   slivers.add(_buildEmpty(context));
            // } else {
            //   slivers.add(
            //     SliverList(
            //       delegate: SliverChildBuilderDelegate(
            //           (BuildContext context, int index) {
            //         return _TransactionListItem(
            //           state.transactions[index],
            //         );
            //       }, childCount: state.transactions.length),
            //     ),
            //   );
            //   slivers.add(
            //     SliverFillRemaining(
            //       hasScrollBody: false,
            //       child: Center(
            //         child: Container(
            //           padding: EdgeInsets.all(Insets.ls),
            //           child: Link(
            //             uri: Uri.parse(
            //                 'https://explorer.solana.com/address/${widget.tokenAccount.address}?cluster=devnet'),
            //             target: UniversalPlatform.isWeb
            //                 ? LinkTarget.blank
            //                 : LinkTarget.self,
            //             builder: (context, onTap) {
            //               return OutlinedButton(
            //                   //style: raisedButtonStyle,
            //                   child: Text('View All Transactions'),
            //                   onPressed: onTap);
            //             },
            //           ),
            //         ),
            //       ),
            //     ),
            //   );
            // }
          } else if (state.error != null) {
            slivers.add(_buildError(context));
          } else {
            slivers.add(_buildLoader(context));
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

  List<Widget> _buildHeaderSlivers(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverToBoxAdapter(
          child: Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            //height: _kUserDetailHeight,
            child: _TokenHeader(
              tokenAccount: widget.tokenAccount,
            ),
          ),
        ),
      ),
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.tokenAccount!.token!.tokenName!,
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [const ClusterChip()],
        leading: widget.onClose != null
            ? IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: widget.onClose,
              )
            : BackButton(onPressed: () => Navigator.of(context).pop()),
        elevation: 0,
      ),
      body: Scrollbar(
        isAlwaysShown: false,
        child: NestedScrollView(
            headerSliverBuilder: _buildHeaderSlivers,
            body: _buildContent(context)),
      ),
    );
  }
}

enum TokenPageAction {
  send,
  receive,
  swap,
  detail,
  contribute,
}

class TokenPageSettings extends Equatable {
  final TokenPageAction action;
  final TokenAccount? tokenAccount;
  final Token? swapFrom;
  final Token? swapTo;

  TokenPageSettings(
      {required this.action,
      required this.tokenAccount,
      this.swapFrom,
      this.swapTo});

  List<dynamic> get props => [action, tokenAccount, swapFrom, this.swapTo];
}

class WalletFetchError extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onClose;
  const WalletFetchError({this.onRetry, this.onClose, Key? key})
      : super(key: key);
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        AppBar(
          elevation: 0,
          leading: onClose != null
              ? BackButton(
                  onPressed: onClose,
                )
              : null,
          backgroundColor: theme.scaffoldBackgroundColor,
        ),
        Expanded(
          child: EmptyContent(
            title: Text(
              S.of(context).failed_fetch_wallet,
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            icon: Icon(
              Icons.warning,
              size: 96.0,
              color: isDark ? Colors.white38 : Colors.grey[300],
            ),
            action: onRetry != null
                ? TextButton(
                    child: Text(S.of(context).retry.toUpperCase()),
                    onPressed: onRetry,
                  )
                : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

typedef TokenPageBuilder = Widget Function(
    BuildContext context, TokenAccount token);

class TokenLoaderPage extends StatelessWidget {
  final String token;
  final TokenPageBuilder tokenPageBuilder;
  final TokenAccount? tokenAccount;

  TokenLoaderPage(
    this.token,
    this.tokenPageBuilder, {
    this.tokenAccount,
  });

  Widget build(BuildContext context) {
    return tokenAccount == null
        ? BlocBuilder<WalletCubit, WalletsState>(builder: (context, state) {
            final theme = Theme.of(context);
            Widget body;
            if (state.wallet != null) {
              final tokenAccount = state.tokenAccounts?.firstWhereOrNull(
                  (tokenAccount) => tokenAccount.token?.tokenSymbol == token);
              if (state.tokenAccounts!.isEmpty || tokenAccount == null) {
                body = WalletFetchError(
                  onRetry: () {
                    final walletCubit = BlocProvider.of<WalletCubit>(context);
                    walletCubit.refresh();
                  },
                );
              } else {
                body = tokenPageBuilder(context, tokenAccount);
              }
            } else if (state.loadError != null) {
              body = WalletFetchError(
                onRetry: () {
                  final walletCubit = BlocProvider.of<WalletCubit>(context);
                  walletCubit.refresh();
                },
              );
            } else {
              body = Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: theme.scaffoldBackgroundColor,
                ),
                body: FeedLoader(),
              );
            }
            return AnimatedSwitcher(
                duration: kThemeAnimationDuration, child: body);
          })
        : tokenPageBuilder(context, tokenAccount!);
  }
}

class TokenDetailPage extends StatelessWidget {
  final String token;
  final TokenAccount? tokenAccount;
  final VoidCallback? onClose;
  TokenDetailPage(this.token, {this.tokenAccount, this.onClose});

  @override
  Widget build(BuildContext context) {
    return TokenLoaderPage(
      token,
      (context, tokenAccount) {
        return TokenDetail(tokenAccount: tokenAccount, onClose: onClose);
      },
      tokenAccount: tokenAccount,
    );
  }
}

class TokenDetail extends StatefulWidget {
  final TokenAccount? tokenAccount;

  final VoidCallback? onClose;
  const TokenDetail({Key? key, this.tokenAccount, this.onClose})
      : super(key: key);

  @override
  _TokenDetailState createState() => _TokenDetailState();
}

class _TokenDetailState extends State<TokenDetail> {
  TransactionsCubit? cubit;
  late ValueNotifier<TokenPageSettings> pageAction;

  String get tokenSymbol => widget.tokenAccount!.token!.tokenSymbol!;

  initState() {
    pageAction = ValueNotifier<TokenPageSettings>(TokenPageSettings(
        action: TokenPageAction.detail, tokenAccount: widget.tokenAccount));
    cubit = TransactionsCubit(widget.tokenAccount, context.read());
    cubit!.loadTransactions();
    super.initState();
  }

  dispose() {
    cubit?.close();
    super.dispose();
  }

  void showReceive() {
    if (isDisplayDesktop(context)) {
      pageAction.value = TokenPageSettings(
          action: TokenPageAction.receive, tokenAccount: widget.tokenAccount);
      return;
    }
    PagenavigationHelper.tokenDetailPage(context, tokenSymbol, 'deposit',
        tokenAccount: widget.tokenAccount);
  }

  void showSend() {
    if (isDisplayDesktop(context)) {
      pageAction.value = TokenPageSettings(
          action: TokenPageAction.send, tokenAccount: widget.tokenAccount);
      return;
    }
    PagenavigationHelper.tokenDetailPage(context, tokenSymbol, 'send',
        tokenAccount: widget.tokenAccount);
  }

  void showContribute() {
    if (isDisplayDesktop(context)) {
      pageAction.value = TokenPageSettings(
          action: TokenPageAction.contribute,
          tokenAccount: widget.tokenAccount);
      return;
    }
    PagenavigationHelper.tokenDetailPage(context, tokenSymbol, 'contribute',
        tokenAccount: widget.tokenAccount);
  }

  void swap(
    Token from,
    Token to,
  ) {
    if (isDisplayDesktop(context)) {
      pageAction.value = TokenPageSettings(
          action: TokenPageAction.swap,
          tokenAccount: widget.tokenAccount,
          swapFrom: from,
          swapTo: to);
      return;
    }
    PagenavigationHelper.tokenDetailPage(context, tokenSymbol, 'swap',
        tokenAccount: widget.tokenAccount!,
        swapFrom: from.tokenSymbol,
        swapTo: to.tokenSymbol);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: this,
      child: ValueListenableBuilder(
        valueListenable: pageAction,
        builder: (_, TokenPageSettings settings, __) {
          Widget body;
          final onClose = () {
            pageAction.value = TokenPageSettings(
                action: TokenPageAction.detail,
                tokenAccount: widget.tokenAccount);
          };
          switch (settings.action) {
            case TokenPageAction.contribute:
              body = ContributeFunds(
                onClose: onClose,
              );
              break;
            case TokenPageAction.send:
              body = SendFunds(
                widget.tokenAccount,
                onClose: onClose,
              );
              break;
            case TokenPageAction.receive:
              body = DepositFunds(
                widget.tokenAccount,
                onClose: onClose,
              );
              break;

            case TokenPageAction.swap:
              body = SwapPage(
                fromMint: settings.swapFrom,
                toMint: settings.swapTo,
                onClose: onClose,
              );
              break;
            default:
              body = TokenDetailView(this);
          }
          return PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
              );
            },
            child: body,
          );
        },
      ),
    );
  }
}
