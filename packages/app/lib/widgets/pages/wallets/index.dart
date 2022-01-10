import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/bloc/wallet/claims_cubit.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/claims.dart';
import 'package:goramp/widgets/pages/wallets/crypto/contribute.dart';
import 'package:goramp/widgets/pages/wallets/crypto/deposit.dart';
import 'package:goramp/widgets/pages/wallets/crypto/detail.dart';
import 'package:goramp/widgets/pages/wallets/crypto/price_builder.dart';
import 'package:goramp/widgets/pages/wallets/crypto/swap.dart';
import 'package:goramp/widgets/pages/wallets/passes/index.dart';
import 'package:goramp/widgets/pages/wallets/transactions/detail.dart';
import 'package:goramp/widgets/pages/wallets/transactions/payments.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/me/tabs.dart';
import 'package:goramp/widgets/pages/wallets/crypto/crypto_wallet.dart';
import 'package:tuple/tuple.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

const _kMaxWidth = 400.0;
enum WalletDrawer {
  none,
  edit_card,
  add_card,
  show_payment_method,
  show_token,
  deposit,
  contribute,
  swap,
  claim
}

class WalletConnect extends StatelessWidget {
  const WalletConnect();

  @override
  Widget build(BuildContext context) {
    AppConfig config = Provider.of(context, listen: false);
    final providers = WalletProvider.getExternalWalletProviders(
        network: config.solanaCluster!);
    return providers.isNotEmpty
        ? Container(
            alignment: Alignment.center,
            child: BlocBuilder<WalletCubit, WalletsState>(
                builder: (context, state) {
              final theme = Theme.of(context);
              return OutlinedButton.icon(
                style: context.raisedStyle,
                icon: state.connecting
                    ? SizedBox(
                        height: 18.0,
                        width: 18.0,
                        child: PlatformCircularProgressIndicator(
                          theme.colorScheme.primary,
                          strokeWidth: 2,
                        ),
                      )
                    : const SizedBox.shrink(),
                label: Text(state.connecting
                    ? S.of(context).connecting
                    : state.connected
                        ? S.of(context).disconnect
                        : S.of(context).connect),
                onPressed: state.connecting
                    ? null
                    : () => WalletHelper.connect(context, !state.connected),
              );
            }),
          )
        : const SizedBox.shrink();
  }
}

class WalletSettings extends StatelessWidget {
  const WalletSettings();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletsState>(builder: (context, state) {
      final theme = Theme.of(context);

      AppConfig config = Provider.of(context, listen: false);
      final providers = WalletProvider.getExternalWalletProviders(
          network: config.solanaCluster!);
      return PopupMenuButton<String>(
        icon: Icon(Icons.settings_outlined),
        padding: EdgeInsets.zero,
        onSelected: (String result) async {
          WalletCubit walletCubit = context.read();
          if (result == 'wallet') {
            final url =
                WalletHelper.addressUrl(context, state.wallet!.publicKey!);
            if (await canLaunch(url)) {
              launch(url,
                  webOnlyWindowName: '_blank',
                  enableJavaScript: true,
                  forceSafariVC: true,
                  forceWebView: true);
            }
            return;
          }
          if (result == 'change') {
            final wallet = await showPaymentMethodsDialog(context);
            if (wallet != null) {
              await walletCubit.connect(wallet);
            }
            return;
          }
          if (result == 'copy') {
            await Clipboard.setData(
                ClipboardData(text: walletCubit.state.wallet?.publicKey));
            await ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(S.of(context).copied)));
            return;
          }
          if (result == 'disconnect') {
            await walletCubit.disconnect();
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          if (state.connected)
            PopupMenuItem<String>(
                value: 'wallet',
                textStyle: theme.textTheme.subtitle1!,
                child: Row(
                  children: [
                    const Icon(Icons.link),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            WalletHelper.shortAddress(state.wallet!.publicKey!),
                            style: theme.textTheme.subtitle1!
                                .copyWith(color: theme.colorScheme.secondary),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                state.wallet!.name,
                                style: theme.textTheme.caption,
                              ),
                              Dot(
                                  size: Size(6, 6),
                                  color: theme.brightness == Brightness.dark
                                      ? Colors.green[200]!
                                      : Colors.green),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    PlatformImage.asset(state.wallet!.iconUrl, width: 24)
                  ],
                )),
          if (state.connected)
            PopupMenuItem<String>(
                value: 'copy',
                child: Row(
                  children: [
                    const Icon(Icons.copy_outlined),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      S.of(context).copy_address,
                    )
                  ],
                )),
          if (providers.isNotEmpty)
            PopupMenuItem<String>(
              value: 'change',
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    S.of(context).change,
                  )
                ],
              ),
              enabled: state.connected,
              //enabled: ,
            ),
          if (state.connected)
            PopupMenuItem<String>(
              value: 'disconnect',
              child: Row(
                children: [
                  const Icon(Icons.link_off),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    S.of(context).disconnect,
                  )
                ],
              ),
            ),
        ],
      );
    });
  }
}

class CryptoWalletHeader extends StatelessWidget {
  const CryptoWalletHeader();

  Widget _buildBalance(BuildContext context, WalletsState state) {
    final theme = Theme.of(context);
    final tokenAccount = state.tokenAccounts?.firstWhere(
        (element) => element.token?.tokenSymbol?.toUpperCase() == 'KURO');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        VSpace(Insets.m),
        TotalUSDCryptoPriceItem(
          (_, total, format) {
            final usdVal = total;
            return Text(
              '${format.format(usdVal)}',
              style: theme.textTheme.headline5!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            );
          },
        ),
        Text(
          '${S.of(context).total} USD ${S.of(context).balance}',
          style: theme.textTheme.caption,
          textAlign: TextAlign.center,
        ),
        Container(
          padding: EdgeInsets.all(Insets.ls),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //if (!UniversalPlatform.isIOS)
              ElevatedButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  // primary: theme.colorScheme.primary,
                  //backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: StadiumBorder(),
                ),
                child: Text(
                  '${S.of(context).buy} KURO',
                ),
                onPressed: tokenAccount != null
                    ? () {
                        final WalletState walletState = context.read();
                        walletState.showBuy(tokenAccount);
                      }
                    : null,
              ),
              BlocBuilder<ClaimsCubit, ClaimsCubitState>(
                  builder: (context, state) {
                if (state.claims == null ||
                    state.claims!.isEmpty ||
                    state.error != null ||
                    state.loading) {
                  return const SizedBox.shrink();
                } else {
                  return Container(
                    padding: EdgeInsets.only(left: 8.0),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          elevation: 0,
                          //primary: Colors.white,
                          //side: BorderSide(color: Colors.white38),
                          //backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          S.of(context).claims,
                        ),
                        onPressed: tokenAccount != null
                            ? () {
                                final WalletState state = context.read();
                                state.showClaims();
                              }
                            : null),
                  );
                }
              })
            ],
          ),
        ),
        VSpace(Insets.xl),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletsState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            constraints: BoxConstraints(maxWidth: 500, minHeight: 200),
            //padding: EdgeInsets.all(32.0).copyWith(bottom: 0),
            child: AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: _buildBalance(context, state),
            ),
          ),
        );
      },
    );
  }
}

class PayoutWalletHeader extends StatelessWidget {
  const PayoutWalletHeader();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final curr = NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 2);
    return Column(
      children: [
        VSpace(Insets.m),
        Text(
          '${curr.format(0)}',
          style:
              theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          '${S.of(context).pending_balance}',
          style: theme.textTheme.caption,
          textAlign: TextAlign.center,
        ),
        Container(
          padding: EdgeInsets.all(Insets.ls),
          child: ElevatedButton(
            style: TextButton.styleFrom(
              elevation: 0,
              // primary: theme.colorScheme.primary,
              //backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: StadiumBorder(),
            ),
            child: Text(
              '${S.of(context).payout_now}',
            ),
            onPressed: () {},
          ),
        ),
        VSpace(Insets.xl),
      ],
    );
  }
}

class _WalletDrawerContainer extends StatelessWidget {
  final Widget child;
  const _WalletDrawerContainer(this.child);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.panelMaxWidth,
      child: Drawer(
        child: child,
      ),
    );
  }
}

class WalletDrawerParams extends Equatable {
  final WalletDrawer drawer;
  final Contribution? contribution;
  final Object? paymentMethod;

  const WalletDrawerParams(
      {this.drawer = WalletDrawer.none, this.paymentMethod, this.contribution});

  List get props => [drawer, paymentMethod];
}

class _WalletTabBarDelegate extends SliverPersistentHeaderDelegate {
  _WalletTabBarDelegate({this.controller, this.isScrolled = false});

  final TabController? controller;
  final bool isScrolled;
  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  String _textForTab(String tab, BuildContext context) {
    switch (tab) {
      case 'passes':
        return S.of(context).passes;
      case 'cards':
        return S.of(context).cards;
      case 'payments':
        return S.of(context).payments;
      default:
        return S.of(context).tokens;
    }
  }

  void _tap(BuildContext context, int index) =>
      context.go('/wallet/${MY_WALLETS[index]}');

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDesktop = isDisplayDesktop(context);
    Widget tab = TabBar(
        controller: controller,
        key: PageStorageKey<Type>(TabBar),
        indicatorColor: Theme.of(context).colorScheme.primary,
        onTap: (index) => _tap(context, index),
        tabs: MY_WALLETS
            .map(
              (e) => Tab(
                text: _textForTab(e, context),
              ),
            )
            .toList());
    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      // elevation: isScrolled || (shrinkOffset > maxExtent - minExtent) ? 4.0 : 0,
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (isDesktop || orientation == Orientation.landscape) {
            tab = CenteredWidget(
              tab,
              maxWidth: _kMaxWidth,
            );
          }
          return tab;
        },
      ),
    );
  }

  @override
  bool shouldRebuild(_WalletTabBarDelegate oldDelegate) {
    return oldDelegate.controller != controller;
  }
}

class Wallets extends StatefulWidget {
  final VoidCallback? onClose;
  final int index;
  const Wallets({Key? key, this.onClose, this.index = 0}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return WalletState();
  }
}

class WalletState extends State<Wallets> with TickerProviderStateMixin {
  late TabController _tabController;
  ScrollController _scrollController = ScrollController();
  ValueNotifier<WalletDrawerParams> _drawerMode =
      ValueNotifier<WalletDrawerParams>(WalletDrawerParams());
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Completer? _walletLoader;
  late WalletCubit _walletCubit;
  late StreamSubscription _walletSub;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this, initialIndex: widget.index, length: MY_WALLETS.length);
    _walletCubit = context.read();
    _walletSub = _walletCubit.stream.listen(_walletListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController.index = widget.index;
  }

  dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _walletSub.cancel();
    super.dispose();
  }

  void _openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void _walletListener(WalletsState state) {
    if ((!state.loading)) {
      _walletLoader?.complete();
      _walletLoader = null;
    }
  }

  Future<void> showPaymentMethod(PaymentMethod paymentMethod) async {
    if (UniversalPlatform.isWeb) {
      if (isDisplayDesktop(context)) {
        _drawerMode.value = WalletDrawerParams(
            drawer: WalletDrawer.show_payment_method,
            paymentMethod: paymentMethod);
        _openDrawer();
        return;
      }
    }
    // await showModalBottomSheet<bool>(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (BuildContext context) {
    //     return FractionallySizedBox(
    //       heightFactor: 0.9,
    //       child: PhysicalModel(
    //         elevation: 8.0,
    //         clipBehavior: Clip.hardEdge,
    //         shadowColor: Colors.black45,
    //         color: Theme.of(context).canvasColor,
    //         borderRadius: kTopBorderRadius,
    //         child: Provider.value(
    //           value: this,
    //           child: CardDetail(
    //             card.paymentMethodId!,
    //             card: card,
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //       builder: (BuildContext context) {
    //         return Provider.value(
    //           value: this,
    //           child: CardDetail(paymentMethod as PaymentCard?),
    //         );
    //       },
    //       fullscreenDialog: true),
    // );
  }

  void showTransaction(PaymentTransaction transaction) async {
    if (UniversalPlatform.isWeb) {
      if (isDisplayDesktop(context)) {
        _drawerMode.value = WalletDrawerParams(
            drawer: WalletDrawer.show_payment_method,
            paymentMethod: transaction);
        _openDrawer();
        return;
      }
    }
    PagenavigationHelper.paymentTransactionDetail(
        context, transaction.transactionId!,
        transaction: transaction);
    // await showModalBottomSheet<bool>(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (BuildContext context) {
    //     return FractionallySizedBox(
    //       heightFactor: 0.9,
    //       child: PhysicalModel(
    //         elevation: 8.0,
    //         clipBehavior: Clip.hardEdge,
    //         shadowColor: Colors.black45,
    //         color: Theme.of(context).canvasColor,
    //         borderRadius: kTopBorderRadius,
    //         child: Provider.value(
    //           value: this,
    //           child: PaymentTransactionDetail(
    //             transaction.transactionId!,
    //             transaction: transaction,
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return Provider.value(
    //         value: this,
    //         child: PaymentTransactionDetail(transaction),
    //       );
    //     },
    //   ),
    // );
  }

  void showToken(TokenAccount token) {
    if (UniversalPlatform.isWeb && isDisplayDesktop(context)) {
      _drawerMode.value = WalletDrawerParams(
          drawer: WalletDrawer.show_token, paymentMethod: token);
      _openDrawer();
      return;
    }
    final tokenName = token.token!.tokenSymbol!;

    PagenavigationHelper.tokenDetail(context, tokenName, tokenAccount: token);
    // RoutePageManager pageManager = context.read();
    // pageManager.navigateTo(
    //   WalletDetailRoutePath(
    //     token.token!.tokenSymbol!,
    //     tokenAccount: token,
    //   ),
    // );
  }

  void depositToken(TokenAccount token) {
    if (UniversalPlatform.isWeb && isDisplayDesktop(context)) {
      _drawerMode.value = WalletDrawerParams(
          drawer: WalletDrawer.deposit, paymentMethod: token);
      _openDrawer();
      return;
    }
    final tokenName = token.token!.tokenSymbol!;
    PagenavigationHelper.tokenDetailPage(context, tokenName, 'deposit',
        tokenAccount: token);
  }

  void showContribute(TokenAccount token, {Contribution? contribution}) {
    if (UniversalPlatform.isWeb && isDisplayDesktop(context)) {
      _drawerMode.value = WalletDrawerParams(
          drawer: WalletDrawer.contribute, paymentMethod: token);
      _openDrawer();
      return;
    }
    final tokenName = token.token!.tokenSymbol!;
    PagenavigationHelper.tokenDetailPage(context, tokenName, 'contribute',
        tokenAccount: token);
  }

  void showBuy(TokenAccount token, {Contribution? contribution}) {
    if (token.token?.tokenSymbol == 'KURO' ||
        token.token?.tokenSymbol == 'KIN') {
      final from = USDCMain;
      final to = token.token;
      if (UniversalPlatform.isWeb && isDisplayDesktop(context)) {
        _drawerMode.value = WalletDrawerParams(
            drawer: WalletDrawer.swap,
            paymentMethod: Tuple2.fromList([from, to]));
        _openDrawer();
        return;
      }
      final tokenName = token.token!.tokenSymbol!;
      PagenavigationHelper.tokenDetailPage(context, tokenName, 'swap',
          tokenAccount: token,
          swapFrom: from.tokenSymbol,
          swapTo: to?.tokenSymbol);
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //       builder: (BuildContext context) {
      //         return Provider.value(
      //           value: this,
      //           child: SwapPage(
      //             fromMint: from,
      //             toMint: to,
      //             onClose: () => Navigator.of(context).pop(),
      //           ),
      //         );
      //       },
      //       fullscreenDialog: true),
      // );
      // RoutePageManager pageManager = context.read();
      // pageManager.navigateTo(
      //   WalletDetailRoutePath(token.token!.tokenSymbol!,
      //       tokenAccount: token,
      //       path: WalletDetailPath.swap,
      //       swapFrom: from,
      //       swapTo: to),
      // );
    } else {
      WalletHelper.buy(context, token);
    }
  }

  void showClaims() {
    if (UniversalPlatform.isWeb && isDisplayDesktop(context)) {
      _drawerMode.value = WalletDrawerParams(
        drawer: WalletDrawer.claim,
      );
      _openDrawer();
      return;
    }
    PagenavigationHelper.walletClaims(context);
  }


  Widget _buildDrawer() {
    return ScaffoldMessenger(
      child: ValueListenableBuilder(
        valueListenable: _drawerMode,
        builder: (context, WalletDrawerParams val, child) {
          late Widget body;
          switch (val.drawer) {
            case WalletDrawer.none:
              body = SizedBox.shrink();
              break;
            case WalletDrawer.show_payment_method:
              if (val.paymentMethod is PaymentTransaction) {
                final transaction = val.paymentMethod as PaymentTransaction;
                body = _WalletDrawerContainer(PaymentTransactionDetail(
                  transaction.transactionId!,
                  transaction: transaction,
                ));
              }
              break;

            case WalletDrawer.show_token:
              if (val.paymentMethod is TokenAccount) {
                body = _WalletDrawerContainer(
                  TokenDetail(
                    tokenAccount: val.paymentMethod as TokenAccount?,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                );
              }
              break;
            case WalletDrawer.deposit:
              if (val.paymentMethod is TokenAccount) {
                body = _WalletDrawerContainer(DepositFunds(
                  val.paymentMethod as TokenAccount?,
                  onClose: () => Navigator.of(context).pop(),
                ));
              }
              break;
            case WalletDrawer.contribute:
              if (val.paymentMethod is TokenAccount) {
                body = _WalletDrawerContainer(
                  ContributeFunds(
                    onClose: () => Navigator.of(context).pop(),
                  ),
                );
              }
              break;
            case WalletDrawer.swap:
              if (val.paymentMethod is Tuple2) {
                final turple = (val.paymentMethod as Tuple2);
                body = _WalletDrawerContainer(
                  SwapPage(
                    fromMint: turple.item1,
                    toMint: turple.item2,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                );
              }
              break;
            case WalletDrawer.claim:
              body = _WalletDrawerContainer(
                Claims(
                  onClose: () => Navigator.of(context).pop(),
                ),
              );
              break;
            default:
              body = const SizedBox.shrink();
          }
          return body;
        },
      ),
    );
  }

  List<Widget> _buildHeaderSlivers(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverToBoxAdapter(
        child: Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          //height: _kUserDetailHeight,
          child: const CryptoWalletHeader(),
        ),
      ),
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverPersistentHeader(
          pinned: true,
          delegate: _WalletTabBarDelegate(
              controller: _tabController, isScrolled: innerBoxIsScrolled),
        ),
      ),
    ];
  }

  Widget _tab(String tab) {
    switch (tab) {
      case 'tokens':
        return const CryptoWallet(
          key: PageStorageKey('crypto'),
        );
      case 'passes':
        return TimePasses(
          key: PageStorageKey('passes'),
        );
      case 'payments':
        return const Payments(
          key: PageStorageKey('payments'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final tabs = MY_WALLETS.map((e) => _tab(e)).toList();
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
        top: false, bottom: false, left: true, right: true, child: tab);
    return Provider.value(
      value: this,
      child: Scaffold(
        endDrawer: isDesktop ? _buildDrawer() : null,
        key: scaffoldKey,
        onEndDrawerChanged: (open) {
          if (!open) {
            _drawerMode.value = WalletDrawerParams();
          }
          MyAppModel model = context.read();
          model.hideMainSideNav = open;
        },
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        drawer: null,
        onDrawerChanged: null,
        appBar: AppBar(
          title: Text(S.of(context).wallet),
          elevation: 0,
          centerTitle: true,
          leading: widget.onClose != null
              ? BackButton(onPressed: widget.onClose)
              : null,
          actions: [
            const WalletConnect(),
            const WalletSettings(),
            // IconButton(
            //     onPressed: () {
            //       final walletCubit = BlocProvider.of<WalletCubit>(context);
            //       walletCubit.refresh(force: true);
            //     },
            //     icon: Icon(Icons.refresh_outlined))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            final walletCubit = BlocProvider.of<WalletCubit>(context);
            return walletCubit.refresh(force: true);
          },
          child: NestedScrollView(
              headerSliverBuilder: _buildHeaderSlivers,
              controller: _scrollController,
              body: tab),
        ),
      ),
    );
  }
}
