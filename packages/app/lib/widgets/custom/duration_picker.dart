// Copyright (c) 2018, codegrue. All rights reserved. Use of this source code
// is governed by the MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'responsive_dialog.dart';

class DurationScrollPicker extends StatefulWidget {
  DurationScrollPicker({
    Key? key,
    required this.durations,
    required this.initialValue,
    required this.onChanged,
    this.showDivider: true,
    this.minSuffix,
  })  : assert(durations != null),
        super(key: key);

  // Events
  final ValueChanged<Duration?> onChanged;

  // Variables
  final List<Duration?> durations;
  final Duration? initialValue;
  final bool showDivider;
  final String? minSuffix;

  @override
  State<StatefulWidget> createState() {
    return _DurationPickerState(initialValue);
  }
}

class _DurationPickerState extends State<DurationScrollPicker> {
  _DurationPickerState(this.selectedValue);

  // Constants
  static const double itemHeight = 50.0;

  // Variables
  late double widgetHeight;
  int? numberOfVisibleItems;
  int? numberOfPaddingRows;
  double? visibleItemsHeight;
  double? offset;

  Duration? selectedValue;

  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();

    int initialItem = widget.durations.indexOf(selectedValue);
    scrollController = FixedExtentScrollController(initialItem: initialItem);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle? defaultStyle = theme.textTheme.bodyText2;
    TextStyle? defaultSuffixStyle = theme.textTheme.caption;
    TextStyle selectedStyle =
        theme.textTheme.headline5!.copyWith(color: theme.accentColor);
    TextStyle selectedSuffixStyle =
        theme.textTheme.caption!.copyWith(color: theme.accentColor);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        widgetHeight = constraints.maxHeight;

        return Stack(
          children: <Widget>[
            GestureDetector(
              onTapUp: _itemTapped,
              child: ListWheelScrollView.useDelegate(
                childDelegate: ListWheelChildBuilderDelegate(
                    builder: (BuildContext context, int index) {
                  if (index < 0 || index > widget.durations.length - 1) {
                    return null;
                  }

                  var value = widget.durations[index]!;
                  final selected = (value == selectedValue);
                  final TextStyle? itemStyle =
                      selected ? selectedStyle : defaultStyle;
                  final TextStyle? suffixStyle =
                      selected ? selectedSuffixStyle : defaultSuffixStyle;
                  return Center(
                    child: RichText(
                      text: TextSpan(
                        text: '${value.inMinutes} ',
                        style: itemStyle,
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.minSuffix ?? "mins",
                              style: suffixStyle),
                        ],
                      ),
                    ),
                  );
                }),
                controller: scrollController,
                itemExtent: itemHeight,
                onSelectedItemChanged: _onSelectedItemChanged,
                physics: FixedExtentScrollPhysics(),
              ),
            ),
            Center(child: widget.showDivider ? Divider() : Container()),
            Center(
              child: Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: theme.accentColor, width: 1.0),
                    bottom: BorderSide(color: theme.accentColor, width: 1.0),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _itemTapped(TapUpDetails details) {
    Offset position = details.localPosition;
    double center = widgetHeight / 2;
    double changeBy = position.dy - center;
    double newPosition = scrollController!.offset + changeBy;

    // animate to and center on the selected item
    scrollController!.animateTo(newPosition,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _onSelectedItemChanged(int index) {
    Duration? newValue = widget.durations[index];
    if (newValue != selectedValue) {
      selectedValue = newValue;
      widget.onChanged(newValue);
    }
  }
}

/// This is a support widget that returns an Dialog with checkboxes as a Widget.
/// It is designed to be used in the showDialog method of other fields.
class DurationPickerDialog extends StatefulWidget {
  DurationPickerDialog({
    this.title,
    this.items,
    this.initialItem,
    this.showDivider: true,
    this.minSuffix,
  });
  // Variables
  final List<Duration>? items;
  final Duration? initialItem;
  final String? title;
  final String? minSuffix;
  final bool showDivider;

  @override
  State<DurationPickerDialog> createState() =>
      _DurationPickerDialogState(initialItem);
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  _DurationPickerDialogState(this.selectedItem);

  Duration? selectedItem;

  @override
  Widget build(BuildContext context) {
    assert(context != null);

    return ResponsiveDialog(
      context: context,
      title: widget.title,
      child: DurationScrollPicker(
        durations: widget.items!,
        initialValue: selectedItem,
        showDivider: widget.showDivider,
        onChanged: (value) => setState(() => selectedItem = value),
      ),
      okPressed: () => Navigator.of(context).pop(selectedItem),
    );
  }
}

void showDurationScrollPicker({
  required BuildContext context,
  String? title,
  String? minSuffix,
  List<Duration>? items,
  Duration? selectedItem,
  bool showDivider: true,
  ValueChanged<Duration>? onChanged,
  VoidCallback? onConfirmed,
  VoidCallback? onCancelled,
}) {
  showDialog<Duration>(
    context: context,
    builder: (BuildContext context) {
      return DurationPickerDialog(
        items: items,
        title: title,
        initialItem: selectedItem,
        showDivider: showDivider,
      );
    },
  ).then((selection) {
    if (onChanged != null && selection != null) onChanged(selection);
    if (onCancelled != null && selection == null) onCancelled();
    if (onConfirmed != null && selection != null) onConfirmed();
  });
}
