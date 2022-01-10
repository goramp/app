import 'package:flutter/material.dart';

const Duration _kSelectionDuration = Duration(milliseconds: 500);
const double _kIconButtonIconSize = 24.0;

/// Button that shows menu and close buttons.
/// Convenient to use with [SelectionAppBar].
class AnimatedSelectAllButton extends StatefulWidget {
  AnimatedSelectAllButton({
    Key? key,
    this.animateDirection,
    this.iconSize,
    this.iconColor,
    this.onMenuClick,
    this.onCloseClick,
  }) : super(key: key);

  /// If true, on mount will animate to close icon.
  /// Else will animate backwards.
  /// If omitted - menu icon will be shown on mount without any animation.
  final bool? animateDirection;
  final double? iconSize;
  final Color? iconColor;

  /// Handle click when menu is shown
  final Function? onMenuClick;

  /// Handle click when close icon is shown
  final Function? onCloseClick;

  AnimatedMenuCloseButtonState createState() => AnimatedMenuCloseButtonState();
}

class AnimatedMenuCloseButtonState extends State<AnimatedSelectAllButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _kSelectionDuration);
    _animation =
        CurveTween(curve: Curves.easeOut).animate(_animationController);

    if (widget.animateDirection != null) {
      if (widget.animateDirection!) {
        _animationController.forward();
      } else {
        _animationController.value = 0.0;
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.iconSize ?? _kIconButtonIconSize,
      onPressed: widget.animateDirection == true
          ? widget.onCloseClick as void Function()?
          : widget.onMenuClick as void Function()?,
      icon: AnimatedIcon(
        icon: widget.animateDirection == null || widget.animateDirection == true
            ? AnimatedIcons.menu_close
            : AnimatedIcons.close_menu,
        color: widget.iconColor,
        progress: _animation,
      ),
    );
  }
}