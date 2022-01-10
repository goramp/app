import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/price_builder.dart';

class TotalBlalanceCard extends StatelessWidget {
  final Contribution? contribution;
  final TokenAccount? tokenAccount;
  const TotalBlalanceCard({this.contribution, this.tokenAccount});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: isDisplayDesktop(context)
          ? EdgeInsets.only(bottom: 8.0, left: 4, right: 8.0, top: 8)
          : EdgeInsets.all(kCarouselItemMargin),
      child: Material(
          elevation: 8,
          type: MaterialType.canvas,
          borderRadius: BorderRadius.circular(20.0),
          color: Color.alphaBlend(kDarkColorScheme.onSurface.withOpacity(0.05),
              kDarkColorScheme.surface),
          shadowColor: Colors.black.withOpacity(0.45),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Stack(fit: StackFit.expand, children: [
              PlatformSvg.asset(Constants.DARK_GRADIENT_PATTERN_SVG,
                  fit: BoxFit.cover),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total USD Balance',
                                  style: theme.textTheme.bodyText1?.copyWith(
                                      color: kDarkColorScheme.onSurface)),
                              TotalUSDCryptoPriceItem(
                                (_, total, format) {
                                  final usdVal = total;
                                  return Text(
                                    '${format.format(usdVal)}',
                                    style: theme.textTheme.headline5!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: kDarkColorScheme.onBackground),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocBuilder<WalletCubit, WalletsState>(
                            builder: (context, state) {
                          final tokenAccount = state.tokenAccounts?.firstWhere(
                              (element) =>
                                  element.token?.tokenSymbol?.toUpperCase() ==
                                  'KURO');
                          return Theme(
                            data: ThemeHelper.buildMaterialAppTheme(
                                context, kDarkColorScheme),
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
                                'Buy KURO',
                              ),
                              onPressed: tokenAccount != null
                                  ? () {
                                      final WalletState walletState =
                                          context.read();
                                      walletState.showBuy(tokenAccount);
                                    }
                                  : null,
                            ),
                          );
                        }),
                        StreamBuilder<UserContribution?>(
                          // initialData: userContribution,
                          stream: WalletService.getUserContributionStream(
                              contribution!.contributionId!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return SizedBox.shrink();
                            } else if (snapshot.data == null ||
                                snapshot.data!.totalAmountDestinationToken >
                                    0) {
                              return SizedBox.shrink();
                            } else {
                              return Theme(
                                data: ThemeHelper.buildMaterialAppTheme(
                                    context, kDarkColorScheme),
                                child: ElevatedButton(
                                    style: OutlinedButton.styleFrom(
                                      elevation: 0,
                                      //primary: Colors.white,
                                      //side: BorderSide(color: Colors.white38),
                                      //backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: StadiumBorder(),
                                    ),
                                    child: Text(
                                      'Claim',
                                    ),
                                    onPressed: tokenAccount != null
                                        ? () {
                                            final WalletState state =
                                                context.read();
                                            state.showContribute(tokenAccount!);
                                          }
                                        : null),
                              );
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ]),
          )),
    );
  }
}
