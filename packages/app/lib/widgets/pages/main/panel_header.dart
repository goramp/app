import 'package:flutter/material.dart';
import 'package:goramp/generated/l10n.dart';
import '../../custom/index.dart';
import '../../styles/index.dart';
import 'tabs.dart';

const double kInstructionsHeight = 40.0;

class PanelInfoHandle extends StatefulWidget {
  final SlideUpPanelScrollController controller;
  PanelInfoHandle(this.controller);

  @override
  _PanelInfoHandle createState() {
    return _PanelInfoHandle();
  }
}

class _PanelInfoHandle extends State<PanelInfoHandle>
    with SingleTickerProviderStateMixin {
  late Animatable<double> _frontOpacityTween;
  late Animatable<double> _heightTween;

  initState() {
    _frontOpacityTween = Tween<double>(begin: 0.0, end: 1.0).chain(
      CurveTween(
        curve: const Interval(0.3, 0.5, curve: Curves.easeInOut),
      ),
    );
    _heightTween = Tween<double>(begin: 0.0, end: kInstructionsHeight).chain(
      CurveTween(
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );
    widget.controller.addTopListener(onTick);
    super.initState();
  }

  dispose() {
    widget.controller.removeTopListener(this.onTick);
    super.dispose();
  }

  onTick() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    final opacity = _frontOpacityTween.transform(widget.controller.value);
    return Opacity(
      opacity: opacity,
      child: Container(
        alignment: Alignment.center,
        height: _heightTween.transform(widget.controller.value),
        child: Text(
          S.of(context).swipe_down_create_event,
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Colors.white38, fontSize: 12.0),
        ),
      ),
    );
  }
}

class SelectabelPanelFrontHeader extends StatelessWidget {
  final ValueNotifier<int> selection;
  SelectabelPanelFrontHeader(this.selection) : assert(selection != null);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              height: 6.0,
              width: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0), color: primary),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: selection,
            builder: (BuildContext context, int index, Widget? child) {
              TabDescription tab = Tabs[index];
              String title = TabDescription.tabTitle(context, tab) ?? '';
              return Text(
                title,
                style: theme.textTheme.headline5,
              );
            },
          )
        ],
      ),
    );
  }
}

class PanelFrontHeader extends StatelessWidget {
  final String title;
  const PanelFrontHeader(this.title) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle tabStyle =
        TextStyle(fontFamily: theme.textTheme.button!.fontFamily);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              height: 6.0,
              width: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: theme.dividerColor),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}
