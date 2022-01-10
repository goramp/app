import 'package:flutter/material.dart';

typedef ShowPopUp = void Function();

typedef CustomPopUpButtonBuilder = Widget Function(
  BuildContext context,
  ShowPopUp? followLink,
);

class CustomPopupMenuButton<T> extends StatefulWidget {
  /// Creates a button that shows a popup menu.
  ///
  /// The [itemBuilder] argument must not be null.
  const CustomPopupMenuButton(
      {Key? key,
      required this.itemBuilder,
      this.initialValue,
      this.onSelected,
      this.onCanceled,
      this.tooltip,
      this.elevation,
      this.padding = const EdgeInsets.all(8.0),
      this.child,
      this.icon,
      this.offset = Offset.zero,
      this.enabled = true,
      this.shape,
      this.color,
      this.iconButtonColor,
      this.captureInheritedThemes = true,
      this.borderRadius,
      this.enableFeedback,
      this.buttonBuilder})
      : assert(!(child != null && icon != null),
            'You can only pass [child] or [icon], not both.'),
        super(key: key);

  /// Called when the button is pressed to create the items to show in the menu.
  final PopupMenuItemBuilder<T> itemBuilder;

  /// The value of the menu item, if any, that should be highlighted when the menu opens.
  final T? initialValue;

  final BorderRadius? borderRadius;

  /// Called when the user selects a value from the popup menu created by this button.
  ///
  /// If the popup menu is dismissed without selecting a value, [onCanceled] is
  /// called instead.
  final PopupMenuItemSelected<T>? onSelected;

  final CustomPopUpButtonBuilder? buttonBuilder;

  /// Called when the user dismisses the popup menu without selecting an item.
  ///
  /// If the user selects a value, [onSelected] is called instead.
  final PopupMenuCanceled? onCanceled;

  /// Text that describes the action that will occur when the button is pressed.
  ///
  /// This text is displayed when the user long-presses on the button and is
  /// used for accessibility.
  final String? tooltip;

  /// The z-coordinate at which to place the menu when open. This controls the
  /// size of the shadow below the menu.
  ///
  /// Defaults to 8, the appropriate elevation for popup menus.
  final double? elevation;

  /// Matches IconButton's 8 dps padding by default. In some cases, notably where
  /// this button appears as the trailing element of a list item, it's useful to be able
  /// to set the padding to zero.
  final EdgeInsetsGeometry padding;

  /// If provided, [child] is the widget used for this button
  /// and the button will utilize an [InkWell] for taps.
  final Widget? child;

  /// If provided, the [icon] is used for this button
  /// and the button will behave like an [IconButton].
  final Widget? icon;

  /// The offset applied to the Popup Menu Button.
  ///
  /// When not set, the Popup Menu Button will be positioned directly next to
  /// the button that was used to create it.
  final Offset offset;

  /// Whether this popup menu button is interactive.
  ///
  /// Must be non-null, defaults to `true`
  ///
  /// If `true` the button will respond to presses by displaying the menu.
  ///
  /// If `false`, the button is styled with the disabled color from the
  /// current [Theme] and will not respond to presses or show the popup
  /// menu and [onSelected], [onCanceled] and [itemBuilder] will not be called.
  ///
  /// This can be useful in situations where the app needs to show the button,
  /// but doesn't currently have anything to show in the menu.
  final bool enabled;

  /// If provided, the shape used for the menu.
  ///
  /// If this property is null, then [PopupMenuThemeData.shape] is used.
  /// If [PopupMenuThemeData.shape] is also null, then the default shape for
  /// [MaterialType.card] is used. This default shape is a rectangle with
  /// rounded edges of BorderRadius.circular(2.0).
  final ShapeBorder? shape;
  final bool? enableFeedback;

  /// If provided, the background color used for the menu.
  ///
  /// If this property is null, then [PopupMenuThemeData.color] is used.
  /// If [PopupMenuThemeData.color] is also null, then
  /// Theme.of(context).cardColor is used.
  final Color? color;

  final Color? iconButtonColor;

  /// If true (the default) then the menu will be wrapped with copies
  /// of the [InheritedTheme]s, like [Theme] and [PopupMenuTheme], which
  /// are defined above the [BuildContext] where the menu is shown.
  final bool captureInheritedThemes;

  @override
  PopupMenuButtonState<T> createState() => PopupMenuButtonState<T>();
}

/// The [State] for a [CustomPopupMenuButton].
///
/// See [showButtonMenu] for a way to programmatically open the popup menu
/// of your button state.
class PopupMenuButtonState<T> extends State<CustomPopupMenuButton<T>> {
  final GlobalKey _menuButtonKey = GlobalKey();

  /// A method to show a popup menu with the items supplied to
  /// [CustomPopupMenuButton.itemBuilder] at the position of your [CustomPopupMenuButton].
  ///
  /// By default, it is called when the user taps the button and [CustomPopupMenuButton.enabled]
  /// is set to `true`. Moreover, you can open the button by calling the method manually.
  ///
  /// You would access your [PopupMenuButtonState] using a [GlobalKey] and
  /// show the menu of the button with `globalKey.currentState.showButtonMenu`.
  void showButtonMenu() {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button =
        _menuButtonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(widget.offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final List<PopupMenuEntry<T>> items = widget.itemBuilder(context);
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      showMenu<T>(
        context: context,
        elevation: widget.elevation ?? popupMenuTheme.elevation,
        items: items,
        initialValue: widget.initialValue,
        position: position,
        shape: widget.shape ?? popupMenuTheme.shape,
        color: widget.color ?? popupMenuTheme.color,
        //captureInheritedThemes: widget.captureInheritedThemes,
      ).then<void>((T? newValue) {
        if (!mounted) return null;
        if (newValue == null) {
          if (widget.onCanceled != null) widget.onCanceled!();
          return null;
        }
        if (widget.onSelected != null) widget.onSelected!(newValue);
      });
    }
  }

  Icon? _getIcon(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const Icon(Icons.more_vert);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const Icon(Icons.more_horiz);
    }
  }

  bool? get _canRequestFocus {
    final NavigationMode mode = MediaQuery.of(context).navigationMode;
    switch (mode) {
      case NavigationMode.traditional:
        return widget.enabled;
      case NavigationMode.directional:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final bool enableFeedback = widget.enableFeedback ??
        PopupMenuTheme.of(context).enableFeedback ??
        true;

    assert(debugCheckHasMaterialLocalizations(context));

    if (widget.buttonBuilder != null) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return UnconstrainedBox(
            constrainedAxis: Axis.horizontal,
            child: LimitedBox(
              key: _menuButtonKey,
              maxHeight: constraints.maxHeight,
              child: widget.buttonBuilder!(
                  context, widget.enabled ? showButtonMenu : null),
            ),
          );
        },
      );
    }

    return InkWell(
      onTap: widget.enabled ? showButtonMenu : null,
      canRequestFocus: _canRequestFocus!,
      borderRadius: widget.borderRadius,
      enableFeedback: enableFeedback,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return UnconstrainedBox(
            constrainedAxis: Axis.horizontal,
            child: LimitedBox(
              key: _menuButtonKey,
              maxHeight: constraints.maxHeight,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
