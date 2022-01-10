import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/price_builder.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../bloc/index.dart';
import 'package:goramp/generated/l10n.dart';

const _kMaxWidth = 400.0;

class TokenListItem extends StatelessWidget {
  final TokenAccount tokenAccount;
  TokenListItem(this.tokenAccount);

  Widget build(BuildContext context) {
    return USDCryptoPriceItem(
      tokenAccount.token!.tokenSymbol!.toUpperCase(),
      (_, price, format) {
        final balance = tokenAccount.amount! /
            BigInt.from(math.pow(10, tokenAccount.decimals!));
        final usdVal = balance * price;
        final hasNoSOL = tokenAccount.token == NATIVE_SOL &&
            tokenAccount.amount! == BigInt.zero;
        return ListTile(
          shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
          leading: SizedBox(
            height: 40.0,
            width: 40.0,
            child: Stack(
              children: [
                Center(
                  child: PlatformSvg.asset(
                    tokenAccount.token!.icon!,
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
                if (hasNoSOL)
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 18.0,
                      width: 18.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Icon(
                        Icons.add_circle,
                        size: 18.0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
              ],
            ),
          ),
          title: Text(hasNoSOL
              ? S.of(context).deposit_token('SOL')
              : '${cryptoFormatter.format(balance)} ${tokenAccount.token!.tokenSymbol}'),
          subtitle: Text(hasNoSOL
              ? S.of(context).sol_pays_transaction_fee('SOL')
              : '${format.format(usdVal)}'),
          onTap: () {
            final WalletState state = context.read();
            state.showToken(tokenAccount);
          },
          trailing: !tokenAccount.token!.canBuy ? null : TextButton(
                  style: context.stadiumRoundTextStyle,
                  child: Text(
                    S.of(context).buy.toUpperCase(),
                  ),
                  onPressed: () {
                    final WalletState walletState = context.read();
                    walletState.showBuy(tokenAccount);
                  },
                ),
        );
      },
    );
  }
}

class CryptoWallet extends StatefulWidget {
  const CryptoWallet({Key? key}) : super(key: key);

  @override
  _CryptoWalletState createState() => _CryptoWalletState();
}

class _CryptoWalletState extends State<CryptoWallet> {
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
              '${S.of(context).fetching_token}...',
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
          S.of(context).no_tokens,
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

  Widget _buildWalletConnect(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return SliverToBoxAdapter(
      child: EmptyContent(
        title: Text(
          'Connect Your Wallet',
          style: theme.textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          'Your tokens will appear here',
          style: theme.textTheme.caption,
          textAlign: TextAlign.center,
        ),
        icon: Icon(
          MdiIcons.connection,
          size: 96.0,
          color: isDark ? Colors.white38 : Colors.grey[300],
        ),
        action: const WalletConnectButton(),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return SliverToBoxAdapter(
      child: CenteredWidget(
        FeedErrorView(
          error: '${S.of(context).fail_to_fetch_tokens}...',
          center: false,
          onRefresh: () {
            final walletCubit = BlocProvider.of<WalletCubit>(context);
            walletCubit.refresh();
          },
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletsState>(builder: (context, state) {
      final List<Widget> slivers = [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
      ];
      if (state.connected) {
        if (state.tokenAccounts != null) {
          if (state.tokenAccounts!.isEmpty) {
            slivers.add(_buildEmpty(context));
          } else {
            slivers.add(SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final int itemIndex = index ~/ 2;
                    if (index.isEven) {
                      return TokenListItem(
                        state.tokenAccounts![itemIndex],
                      );
                    }
                    return const SizedBox(
                      height: 16.0,
                    );
                  },
                  semanticIndexCallback: (Widget widget, int localIndex) {
                    if (localIndex.isEven) {
                      return localIndex ~/ 2;
                    }
                    return null;
                  },
                  childCount: math.max(0, state.tokenAccounts!.length * 2 - 1),
                ),
              ),
            ));
          }
        } else if (state.hasLoadError) {
          slivers.add(_buildError(context));
        } else {
          slivers.add(_buildLoader(context));
        }
      } else {
        slivers.add(_buildWalletConnect(context));
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
