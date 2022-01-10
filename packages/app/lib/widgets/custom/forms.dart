import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SectionHeader extends StatelessWidget {
  final Widget? title;
  final bool dividerTop;
  final bool dividerBottom;
  SectionHeader({
    this.title,
    this.dividerTop = false,
    this.dividerBottom = true,
  });
  Widget build(BuildContext context) {
    final titleWidget = title ?? Container();
    return Container(
      height: 40.0,
      child: Column(
        children: <Widget>[
          dividerTop
              ? Divider(
                  height: 1.0,
                )
              : Container(),
          Expanded(child: titleWidget),
          dividerBottom
              ? Divider(
                  height: 1.0,
                )
              : Container()
        ],
      ),
    );
  }
}

class FieldItem extends StatelessWidget {
  final Widget child;
  final bool divider;
  final bool paper;
  final bool indent;
  FieldItem(this.child,
      {this.divider = true, this.paper = true, this.indent = true});
  Widget build(BuildContext context) {
    final widget = Container(
      height: 56.0,
      child: Column(
        children: <Widget>[
          Expanded(child: child),
          divider
              ? Divider(
                  indent: indent ? 16.0 : 0.0,
                  height: 1.0,
                )
              : Container()
        ],
      ),
    );
    return paper
        ? Material(
            child: widget,
            color: Colors.white,
          )
        : widget;
  }
}
