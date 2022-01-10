import 'package:flutter/widgets.dart';
import '../widgets/index.dart';

class SlideUpPanelProvider extends InheritedWidget {
  final SlideUpPanelScrollController controller;

  SlideUpPanelProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(SlideUpPanelProvider oldWidget) =>
      oldWidget.controller != controller;

  static SlideUpPanelScrollController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<SlideUpPanelProvider>()!
      .controller;
}
