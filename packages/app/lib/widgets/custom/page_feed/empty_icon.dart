import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmptyIcons extends StatelessWidget {
  const EmptyIcons();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Icon(
      Icons.event_note_outlined,
      size: 96.0,
      color: isDark ? Colors.white38 : Colors.grey[300],
    );
  }
}
