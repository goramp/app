import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

const double _kBackAppBarHeight = 56.0; // back layer (options) appbar height

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
    this.leading = const SizedBox(width: 56.0),
    required this.trailing,
  })  : assert(trailing != null),
        super(key: key);

  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      leading != null
          ? Container(
              alignment: Alignment.center,
              width: 56.0,
              child: leading,
            )
          : Container(),
      Container(
        alignment: Alignment.center,
        child: trailing,
        margin: EdgeInsets.only(right: 16.0),
      ),
    ];

    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: IconTheme.merge(
          data: theme.primaryIconTheme,
          child: DefaultTextStyle(
            style: theme.primaryTextTheme.headline6!,
            child: SizedBox(
              height: _kBackAppBarHeight,
              child: Row(
                children: children,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
