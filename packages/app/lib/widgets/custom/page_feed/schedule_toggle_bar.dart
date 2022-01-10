import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goramp/generated/l10n.dart';

class CallToggleBar extends StatefulWidget {
  final ValueChanged<int?> onChanged;
  final int? selection;
  CallToggleBar(this.onChanged, {this.selection});
  @override
  State<StatefulWidget> createState() {
    return _ToggleBarState();
  }
}

class _ToggleBarState extends State<CallToggleBar> {
  int? _currentSelectedIndex;

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = widget.selection;
  }

  @override
  void didUpdateWidget(CallToggleBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selection != oldWidget.selection) {
      _currentSelectedIndex = widget.selection;
    }
  }

  Widget _buildCupertino() {
    final style = Theme.of(context).textTheme.button;
    Map<int, Widget> _map = {
      0: Text(
        S.of(context).buy,
        style: style,
      ),
      1: Text(
        S.of(context).sell,
        style: style,
      ),
    };
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: CupertinoSlidingSegmentedControl<int>(
        children: _map,
        onValueChanged: widget.onChanged,
        groupValue: _currentSelectedIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCupertino();
  }
}
