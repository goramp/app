import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/pages/wallets/crypto/contribute.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/index.dart';
import 'package:universal_platform/universal_platform.dart';

class ContributionTimeView extends StatelessWidget {
  final Contribution contribution;
  final CurrentRemainingTime remainingTime;
  final TextStyle? textStyle;
  ContributionTimeView(
    this.remainingTime,
    this.contribution, {
    this.textStyle,
  });
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: Insets.m),
      child: ContributionTimeRow(
        remainingTime,
        //showLabel: false,
        backgroundColor: Colors.grey[800],
        dotSize: 16,
        size: 32,
        labelMargin: 2.0,
        dotColor: Colors.black45,
        countStyle: theme.textTheme.subtitle1?.copyWith(color: Colors.white),
        labelStyle: theme.textTheme.caption
            ?.copyWith(color: theme.colorScheme.onPrimary),
      ),
    );
  }
}

class ContibutionCard extends StatefulWidget {
  final Contribution contribution;
  final TokenAccount? tokenAccount;
  const ContibutionCard(this.contribution, {this.tokenAccount});

  @override
  _ContibutionCardState createState() => _ContibutionCardState();
}

class _ContibutionCardState extends State<ContibutionCard> {
  int? _endTime;
  final format = NumberFormat(
    '##,###.#',
  );

  initState() {
    _initCountDown();
    super.initState();
  }

  void _initCountDown() {
    if (widget.contribution.notStarted) {
      _endTime = widget.contribution.startAt!.millisecondsSinceEpoch;
    } else if (widget.contribution.started && !widget.contribution.ended) {
      _endTime = widget.contribution.endAt!.millisecondsSinceEpoch;
    } else {
      _endTime = null;
    }
  }

  didUpdateWidget(ContibutionCard old) {
    if (widget.contribution.notStarted != old.contribution.notStarted ||
        widget.contribution.ended != old.contribution.ended) {
      _initCountDown();
    }
    super.didUpdateWidget(old);
  }

  dispose() {
    super.dispose();
  }

  _buildCountDownRow() {
    final theme = Theme.of(context);
    final subtitleStyle = theme.textTheme.caption
        ?.copyWith(color: theme.colorScheme.onPrimary.withOpacity(0.9));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Wen KURO?",
              style: theme.textTheme.subtitle1
                  ?.copyWith(color: theme.colorScheme.onPrimary),
            ),
            if (widget.contribution.notStarted)
              Text(
                "Starting...",
                style: subtitleStyle,
              ),
            if (widget.contribution.started && !widget.contribution.ended)
              Text(
                "Ending...",
                style: subtitleStyle,
              ),
            if (widget.contribution.ended)
              Text(
                "Ended...",
                style: subtitleStyle,
              ),
          ],
        ),
        if (_endTime != null)
          CountdownTimer(
            endTime: _endTime!,
            endWidget: const SizedBox.shrink(),
            widgetBuilder: (_, CurrentRemainingTime? time) {
              return time != null
                  ? ContributionTimeView(time, widget.contribution)
                  : const SizedBox.shrink();
            },
          )
      ],
    );
  }

  _buildAddFunds(BuildContext context) {
    final theme = Theme.of(context);
    UserProfile? profile =
        context.select<MyAppModel, UserProfile?>((model) => model.profile);
    Color getBgColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return kLightColorScheme.secondary.withOpacity(0.6);
      }
      return kLightColorScheme.secondary;
    }

    Color getFgColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.white.withOpacity(0.38);
      }
      return Colors.white;
    }

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle:
            theme.textTheme.button!.copyWith(fontWeight: FontWeight.bold),
        primary: theme.colorScheme.onPrimary,
        onPrimary: Colors.white,
        shape: StadiumBorder(),
      ).copyWith(
          foregroundColor: MaterialStateProperty.resolveWith(getFgColor),
          backgroundColor: MaterialStateProperty.resolveWith(getBgColor)),
      icon: Icon(CupertinoIcons.add),
      label: Text('Contribute'),
      //onPressed: null,
      onPressed: profile == null || widget.tokenAccount == null
          ? null
          : () {
              final WalletState state = context.read();
              state.showContribute(widget.tokenAccount!);
            },
    );
  }

  Widget _buildIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final totalContrib = widget.contribution.totalAmountSourceToken /
        pow(10, widget.contribution.sourceDecimal);
    final targetContrib = widget.contribution.targetAmountSourceToken /
        pow(10, widget.contribution.sourceDecimal);
    final percent = (totalContrib / targetContrib).clamp(0, 1.0).toDouble();

    return Column(
      children: [
        LinearPercentIndicator(
          //width: 140.0,
          lineHeight: 14.0,
          percent: percent,
          backgroundColor: kDarkColorScheme.background.withOpacity(0.4),
          progressColor: kDarkColorScheme.background,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${format.format(totalContrib)} ${widget.contribution.sourceToken}',
              style: theme.textTheme.caption?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Text(
                '${format.format(targetContrib)} ${widget.contribution.sourceToken}',
                style: theme.textTheme.caption?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(20.0);
    return Container(
      margin: isDisplayDesktop(context)
          ? EdgeInsets.only(bottom: 8.0, left: 4, right: 4.0, top: 8)
          : EdgeInsets.all(kCarouselItemMargin),
      child: Material(
        elevation: 8,
        type: MaterialType.canvas,
        borderRadius: radius,
        shadowColor: Colors.black.withOpacity(0.45),
        color: kLightColorScheme.primary,
        child: ClipRRect(
            borderRadius: radius,
            child: InkWell(
              borderRadius: radius,
              onTap: widget.tokenAccount == null
                  ? null
                  : () {
                      final WalletState state = context.read();
                      state.showContribute(widget.tokenAccount!);
                    },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  UniversalPlatform.isWeb
                      ? PlatformSvg.asset(Constants.PATTERN_SVG,
                          fit: BoxFit.cover)
                      : Image.asset(Constants.PATTERN_PNG, fit: BoxFit.cover),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCountDownRow(),
                        Column(
                          children: [
                            _buildIndicator(context),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildAddFunds(context),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'minimum: ${format.format(widget.contribution.minAmount)} ${widget.contribution.sourceToken}',
                                      style: theme.textTheme.caption?.copyWith(
                                          color: theme.colorScheme.onPrimary),
                                    ),
                                    Text(
                                      'maximum: ${format.format(widget.contribution.maxAmount)} ${widget.contribution.sourceToken}',
                                      style: theme.textTheme.caption?.copyWith(
                                          color: theme.colorScheme.onPrimary),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
