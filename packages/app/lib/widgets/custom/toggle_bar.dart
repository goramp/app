import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/rendering.dart';

const double _kToggleBarHeight = 48.0;

class ToggleBar extends StatelessWidget {
  const ToggleBar({
    Key? key,
    required this.selection,
  })  : assert(selection != null),
        super(key: key);

  final ValueNotifier<int> selection;

  Color? _getColorForIndex(BuildContext context, int index) {
    if (index == selection.value) {
      return Theme.of(context).iconTheme.color;
    } else {
      return Theme.of(context).disabledColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: selection,
      builder: (BuildContext context, int index, Widget? _) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          height: _kToggleBarHeight,
          decoration: BoxDecoration(
            //color: theme.canvasColor,
            border: Border(
              bottom: Divider.createBorderSide(context),
              top: Divider.createBorderSide(context),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: index == 0
                        ? null
                        : () {
                            selection.value = 0;
                          },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedSwitcher(
                        duration: kThemeAnimationDuration,
                        child: index == 0
                            ? Icon(
                                MdiIcons.grid,
                                color: _getColorForIndex(context, 0),
                              )
                            : Icon(
                                MdiIcons.grid,
                                color: _getColorForIndex(context, 0),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              VerticalDivider(
                width: 0.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: index == 1
                        ? null
                        : () {
                            selection.value = 1;
                          },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedSwitcher(
                        duration: kThemeAnimationDuration,
                        child: index == 1
                            ? Icon(
                                MdiIcons.heart,
                                color: _getColorForIndex(context, 1),
                              )
                            : Icon(
                                MdiIcons.heartOutline,
                                color: _getColorForIndex(context, 1),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
