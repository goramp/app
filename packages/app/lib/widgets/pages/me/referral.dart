import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/wallets/index.dart';
import 'package:goramp/widgets/custom/progress_button.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:intl/intl.dart' as intl;
import 'package:goramp/generated/l10n.dart';

const defaultKickBack = [0, 5, 10, 15, 20];

void showReferralGenerateLinkDialog(
    BuildContext context, List<num> kickBacks, num baseRate,
    {VoidCallback? onContribute}) async {
  final paddingScaleFactor =
      WalletHelper.paddingScaleFactor(MediaQuery.of(context).textScaleFactor);
  final TextDirection? textDirection = Directionality.maybeOf(context);

  await showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      final EdgeInsets effectiveTitlePadding =
          const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0)
              .resolve(textDirection);
      final titleWidget = Padding(
        padding: EdgeInsets.only(
          left: effectiveTitlePadding.left * paddingScaleFactor,
          right: effectiveTitlePadding.right * paddingScaleFactor,
          top: effectiveTitlePadding.top * paddingScaleFactor,
          bottom: effectiveTitlePadding.bottom,
        ),
        child: DefaultTextStyle(
          style: DialogTheme.of(context).titleTextStyle ??
              theme.textTheme.headline6!,
          child: Semantics(
            namesRoute: false,
            container: true,
            child: Text(
              S.of(context).generate_your_link,
              // textAlign: TextAlign.center,
            ),
          ),
        ),
      );
      final EdgeInsets effectiveContentPadding =
          const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 16.0)
              .resolve(textDirection);
      Widget contentWidget = Flexible(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: effectiveContentPadding.left * paddingScaleFactor,
            right: effectiveContentPadding.right * paddingScaleFactor,
            top: effectiveContentPadding.top * paddingScaleFactor,
            bottom: effectiveContentPadding.bottom * paddingScaleFactor,
          ),
          child: GenerateReferralLink(kickBacks, baseRate),
        ),
      );

      Widget dialogChild = IntrinsicWidth(
        stepWidth: 56.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              titleWidget,
              contentWidget,
              Container(
                alignment: AlignmentDirectional.centerEnd,
                constraints: const BoxConstraints(minHeight: 56.0),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OverflowBar(
                  spacing: 8,
                  //alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                        child: Text(S.of(context).dismiss),
                        onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
              )
            ],
          ),
        ),
      );
      return Dialog(
          // titleTextStyle: theme.textTheme.headline6,
          child: dialogChild);
    },
  );
}

class Count extends StatelessWidget {
  final String value;
  final String label;
  const Count({
    required this.value,
    required this.label,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          "$value",
          style: theme.textTheme.subtitle1,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          "$label",
          style: theme.textTheme.caption,
        )
      ],
    );
  }
}

class GenerateReferralLink extends StatefulWidget {
  final List<num> kickBacks;
  final num baseRate;
  final UserProfile? profile;
  final VoidCallback? onClose;

  GenerateReferralLink(this.kickBacks, this.baseRate,
      {this.onClose, this.profile, Key? key})
      : super(key: key);

  @override
  _GenerateReferralLinkState createState() => _GenerateReferralLinkState();
}

class _GenerateReferralLinkState extends State<GenerateReferralLink> {
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  late List<bool> _isSelected;
  int _selectedIndex = 0;
  final inputFormatter = intl.NumberFormat(
    '##,###.####',
  );
  final dispFormatter = intl.NumberFormat(
    '##,###.###',
  );
  initState() {
    _isSelected = widget.kickBacks.map((e) => false).toList();
    if (widget.kickBacks.isNotEmpty) {
      _isSelected[_selectedIndex] = true;
    }
    super.initState();
  }

  dispose() {
    super.dispose();
  }

  Future<void> _generate() async {
    try {
      if (_loading.value) return;
      _loading.value = true;
      FocusScope.of(context).unfocus();
    } on ContributionException catch (error) {
      print('ERROR: ${error.message}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? S.of(context).default_error_title)));
    } catch (error) {
      print('ERROR: ${error}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).default_error_title)));
    } finally {
      _loading.value = false;
    }
  }

  Color _getFillColor(ThemeData themeData, bool enabled) {
    // dark theme: 10% white (enabled), 5% white (disabled)
    // light theme: 4% black (enabled), 2% black (disabled)
    const Color darkEnabled = Color(0x1AFFFFFF);
    const Color darkDisabled = Color(0x0DFFFFFF);
    const Color lightEnabled = Color(0x0A000000);
    const Color lightDisabled = Color(0x05000000);

    switch (themeData.brightness) {
      case Brightness.dark:
        return enabled ? darkEnabled : darkDisabled;
      case Brightness.light:
        return enabled ? lightEnabled : lightDisabled;
    }
  }

  Widget _buildInputs() {
    final space = VSpace(Insets.ls);
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          space,
          ValueListenableBuilder(
            valueListenable: _isValid,
            builder: (context, dynamic valid, child) => ProgressButton(
              _loading,
              label: Text(
                S.of(context).generate_your_link,
              ),
              style: context.raisedStyle,
              //icon: Icon(Icons.send),
              onPressed: valid ? _generate : null,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark ? theme.hintColor : theme.dividerColor;
    final divider = Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      height: 40,
      child: VerticalDivider(
        color: dividerColor,
        width: 4.0,
        thickness: context.dividerHairLineWidth,
      ),
    );
    final youRcv = widget.baseRate - widget.kickBacks[_selectedIndex];
    final friendRcv = widget.kickBacks[_selectedIndex];
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.all(Insets.ls),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                borderRadius: kInputBorderRadius,
                color: _getFillColor(theme, true)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Count(
                    label: S.of(context).you_receive,
                    value: '$youRcv%',
                  ),
                ),
                divider,
                Count(
                  label: S.of(context).friend_recieve,
                  value: '$friendRcv%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return ToggleButtons(
      children: widget.kickBacks.map((e) => Text("$e%")).toList(),
      onPressed: (int index) {
        setState(() {
          _selectedIndex = index;
          for (int buttonIndex = 0;
              buttonIndex < _isSelected.length;
              buttonIndex++) {
            if (buttonIndex == _selectedIndex) {
              _isSelected[buttonIndex] = true;
            } else {
              _isSelected[buttonIndex] = false;
            }
          }
        });
      },
      isSelected: _isSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        VSpace(Insets.xl),
        Text("${S.of(context).base_commission_rate}: ${widget.baseRate}%"),
        Text("${S.of(context).friends_commission_kickback_rate}:"),
        _buildSummary(),
        VSpace(Insets.ls),
        _buildBottom(),
        VSpace(Insets.ls),
        _buildInputs()
      ],
    );
  }
}
