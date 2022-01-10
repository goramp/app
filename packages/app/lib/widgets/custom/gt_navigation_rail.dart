// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';

/// A material widget that is meant to be displayed at the left or right of an
/// app to navigate between a small number of views, typically between three and
/// five.
///
/// The navigation rail is meant for layouts with wide viewports, such as a
/// desktop web or tablet landscape layout. For smaller layouts, like mobile
/// portrait, a [BottomNavigationBar] should be used instead.
///
/// A navigation rail is usually used as the first or last element of a [Row]
/// which defines the app's [Scaffold] body.
///
/// The appearance of all of the [GTNavigationRail]s within an app can be
/// specified with [GTNavigationRailTheme]. The default values for null theme
/// properties are based on the [Theme]'s [ThemeData.textTheme],
/// [ThemeData.iconTheme], and [ThemeData.colorScheme].
///
/// Adaptive layouts can build different instances of the [Scaffold] in order to
/// have a navigation rail for more horizontal layouts and a bottom navigation
/// bar for more vertical layouts. See
/// [https://github.com/flutter/samples/blob/master/experimental/web_dashboard/lib/src/widgets/third_party/adaptive_scaffold.dart]
/// for an example.
///
/// {@tool dartpad --template=stateful_widget_material}
///
/// This example shows a [GTNavigationRail] used within a Scaffold with 3
/// [GTNavigationRailDestination]s. The main content is separated by a divider
/// (although elevation on the navigation rail can be used instead). The
/// `_selectedIndex` is updated by the `onDestinationSelected` callback.
///
/// ```dart
/// int _selectedIndex = 0;
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      body: Row(
///        children: <Widget>[
///          GTNavigationRail(
///            selectedIndex: _selectedIndex,
///            onDestinationSelected: (int index) {
///              setState(() {
///                _selectedIndex = index;
///              });
///            },
///            labelType: GTNavigationRailLabelType.selected,
///            destinations: const <GTNavigationRailDestination>[
///              GTNavigationRailDestination(
///                icon: Icon(Icons.favorite_border),
///                selectedIcon: Icon(Icons.favorite),
///                label: Text('First'),
///              ),
///              GTNavigationRailDestination(
///                icon: Icon(Icons.bookmark_border),
///                selectedIcon: Icon(Icons.book),
///                label: Text('Second'),
///              ),
///              GTNavigationRailDestination(
///                icon: Icon(Icons.star_border),
///                selectedIcon: Icon(Icons.star),
///                label: Text('Third'),
///              ),
///            ],
///          ),
///          const VerticalDivider(thickness: 1, width: 1),
///          // This is the main content.
///          Expanded(
///            child: Center(
///              child: Text('selectedIndex: $_selectedIndex'),
///            ),
///          )
///        ],
///      ),
///    );
///  }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Scaffold], which can display the navigation rail within a [Row] of the
///    [Scaffold.body] slot.
///  * [GTNavigationRailDestination], which is used as a model to create tappable
///    destinations in the navigation rail.
///  * [BottomNavigationBar], which is a similar navigation widget that's laid
///     out horizontally.
///  * [https://material.io/components/navigation-rail/]
class GTNavigationRail extends StatefulWidget {
  /// Creates a material design navigation rail.
  ///
  /// The value of [destinations] must be a list of one or more
  /// [GTNavigationRailDestination] values.
  ///
  /// If [elevation] is specified, it must be non-negative.
  ///
  /// If [minWidth] is specified, it must be non-negative, and if
  /// [minExtendedWidth] is specified, it must be non-negative and greater than
  /// [minWidth].
  ///
  /// The argument [extended] must not be null. [extended] can only be set to
  /// true when when the [labelType] is null or [GTNavigationRailLabelType.none].
  ///
  /// If [backgroundColor], [elevation], [groupAlignment], [labelType],
  /// [unselectedLabelTextStyle], [selectedLabelTextStyle],
  /// [unselectedIconTheme], or [selectedIconTheme] are null, then their
  /// [GTNavigationRailThemeData] values will be used. If the corresponding
  /// [GTNavigationRailThemeData] property is null, then the navigation rail
  /// defaults are used. See the individual properties for more information.
  ///
  /// Typically used within a [Row] that defines the [Scaffold.body] property.
  const GTNavigationRail({
    Key? key,
    this.backgroundColor,
    this.extended = false,
    this.leading,
    this.trailing,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.elevation,
    this.groupAlignment,
    this.labelType,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.minWidth,
    this.minExtendedWidth,
  })  : assert(destinations != null && destinations.length >= 2),
        assert(selectedIndex != null),
        assert(0 <= selectedIndex && selectedIndex < destinations.length),
        assert(elevation == null || elevation > 0),
        assert(minWidth == null || minWidth > 0),
        assert(minExtendedWidth == null || minExtendedWidth > 0),
        assert((minWidth == null || minExtendedWidth == null) ||
            minExtendedWidth >= minWidth),
        assert(extended != null),
        assert(!extended ||
            (labelType == null || labelType == GTNavigationRailLabelType.none)),
        super(key: key);

  /// Sets the color of the Container that holds all of the [GTNavigationRail]'s
  /// contents.
  ///
  /// The default value is [GTNavigationRailThemeData.backgroundColor]. If
  /// [GTNavigationRailThemeData.backgroundColor] is null, then the default value
  /// is based on [ColorScheme.surface] of [ThemeData.colorScheme].
  final Color? backgroundColor;

  /// Indicates that the [GTNavigationRail] should be in the extended state.
  ///
  /// The extended state has a wider rail container, and the labels are
  /// positioned next to the icons. [minExtendedWidth] can be used to set the
  /// minimum width of the rail when it is in this state.
  ///
  /// The rail will implicitly animate between the extended and normal state.
  ///
  /// If the rail is going to be in the extended state, then the [labelType]
  /// must be set to [GTNavigationRailLabelType.none].
  ///
  /// The default value is false.
  final bool extended;

  /// The leading widget in the rail that is placed above the destinations.
  ///
  /// It is placed at the top of the rail, above the [destinations]. Its
  /// location is not affected by [groupAlignment].
  ///
  /// This is commonly a [FloatingActionButton], but may also be a non-button,
  /// such as a logo.
  ///
  /// The default value is null.
  final Widget? leading;

  /// The trailing widget in the rail that is placed below the destinations.
  ///
  /// The trailing widget is placed below the last [GTNavigationRailDestination].
  /// It's location is affected by [groupAlignment].
  ///
  /// This is commonly a list of additional options or destinations that is
  /// usually only rendered when [extended] is true.
  ///
  /// The default value is null.
  final Widget? trailing;

  /// Defines the appearance of the button items that are arrayed within the
  /// navigation rail.
  ///
  /// The value must be a list of two or more [GTNavigationRailDestination]
  /// values.
  final List<GTNavigationRailDestination> destinations;

  /// The index into [destinations] for the current selected
  /// [GTNavigationRailDestination].
  final int selectedIndex;

  /// Called when one of the [destinations] is selected.
  ///
  /// The stateful widget that creates the navigation rail needs to keep
  /// track of the index of the selected [GTNavigationRailDestination] and call
  /// `setState` to rebuild the navigation rail with the new [selectedIndex].
  final ValueChanged<int>? onDestinationSelected;

  /// The rail's elevation or z-coordinate.
  ///
  /// If [Directionality] is [TextDirection.LTR], the inner side is the right
  /// side, and if [Directionality] is [TextDirection.RTL], it is the left side.
  ///
  /// The default value is 0.
  final double? elevation;

  /// The vertical alignment for the group of [destinations] within the rail.
  ///
  /// The [GTNavigationRailDestination]s are grouped together with the [trailing]
  /// widget, between the [leading] widget and the bottom of the rail.
  ///
  /// The value must be between -1.0 and 1.0.
  ///
  /// If [groupAlignment] is -1.0, then the items are aligned to the top. If
  /// [groupAlignment] is 0.0, then the items are aligned to the center. If
  /// [groupAlignment] is 1.0, then the items are aligned to the bottom.
  ///
  /// The default is -1.0.
  ///
  /// See also:
  ///   * [Alignment.y]
  ///
  final double? groupAlignment;

  /// Defines the layout and behavior of the labels for the default, unextended
  /// [GTNavigationRail].
  ///
  /// When a navigation rail is [extended], the labels are always shown.
  ///
  /// The default value is [GTNavigationRailThemeData.labelType]. If
  /// [GTNavigationRailThemeData.labelType] is null, then the default value is
  /// [GTNavigationRailLabelType.none].
  ///
  /// See also:
  ///
  ///   * [GTNavigationRailLabelType] for information on the meaning of different
  ///   types.
  final GTNavigationRailLabelType? labelType;

  /// The [TextStyle] of a destination's label when it is unselected.
  ///
  /// When one of the [destinations] is selected the [selectedLabelTextStyle]
  /// will be used instead.
  ///
  /// The default value is based on the [Theme]'s [TextTheme.bodyText1]. The
  /// default color is based on the [Theme]'s [ColorScheme.onSurface].
  ///
  /// Properties from this text style, or
  /// [GTNavigationRailThemeData.unselectedLabelTextStyle] if this is null, are
  /// merged into the defaults.
  final TextStyle? unselectedLabelTextStyle;

  /// The [TextStyle] of a destination's label when it is selected.
  ///
  /// When a [GTNavigationRailDestination] is not selected,
  /// [unselectedLabelTextStyle] will be used.
  ///
  /// The default value is based on the [TextTheme.bodyText1] of
  /// [ThemeData.textTheme]. The default color is based on the [Theme]'s
  /// [ColorScheme.primary].
  ///
  /// Properties from this text style,
  /// or [GTNavigationRailThemeData.selectedLabelTextStyle] if this is null, are
  /// merged into the defaults.
  final TextStyle? selectedLabelTextStyle;

  /// The visual properties of the icon in the unselected destination.
  ///
  /// If this field is not provided, or provided with any null properties, then
  /// a copy of the [IconThemeData.fallback] with a custom [GTNavigationRail]
  /// specific color will be used.
  ///
  /// The default value is the [Theme]'s [ThemeData.iconTheme] with a color
  /// of the [Theme]'s [ColorScheme.onSurface] with an opacity of 0.64.
  /// Properties from this icon theme, or
  /// [GTNavigationRailThemeData.unselectedIconTheme] if this is null, are
  /// merged into the defaults.
  final IconThemeData? unselectedIconTheme;

  /// The visual properties of the icon in the selected destination.
  ///
  /// When a [GTNavigationRailDestination] is not selected,
  /// [unselectedIconTheme] will be used.
  ///
  /// The default value is the [Theme]'s [ThemeData.iconTheme] with a color
  /// of the [Theme]'s [ColorScheme.primary]. Properties from this icon theme,
  /// or [GTNavigationRailThemeData.selectedIconTheme] if this is null, are
  /// merged into the defaults.
  final IconThemeData? selectedIconTheme;

  /// The smallest possible width for the rail regardless of the destination's
  /// icon or label size.
  ///
  /// The default is 72.
  ///
  /// This value also defines the min width and min height of the destinations.
  ///
  /// To make a compact rail, set this to 56 and use
  /// [GTNavigationRailLabelType.none].
  final double? minWidth;

  /// The final width when the animation is complete for setting [extended] to
  /// true.
  ///
  /// This is only used when [extended] is set to true.
  ///
  /// The default value is 256.
  final double? minExtendedWidth;

  /// Returns the animation that controls the [GTNavigationRail.extended] state.
  ///
  /// This can be used to synchronize animations in the [leading] or [trailing]
  /// widget, such as an animated menu or a [FloatingActionButton] animation.
  ///
  /// {@tool dartpad --template=stateless_widget_material}
  ///
  /// This example shows how to use this animation to create a
  /// [FloatingActionButton] that animates itself between the normal and
  /// extended states of the [GTNavigationRail].
  ///
  /// An instance of `ExtendableFab` would be created for
  /// [GTNavigationRail.leading].
  ///
  /// ```dart dartImports
  /// import 'dart:ui';
  /// ```
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final Animation<double> animation = GTNavigationRail.extendedAnimation(context);
  ///   return AnimatedBuilder(
  ///     animation: animation,
  ///     builder: (BuildContext context, Widget? child) {
  ///       // The extended fab has a shorter height than the regular fab.
  ///       return Container(
  ///         height: 56,
  ///         padding: EdgeInsets.symmetric(
  ///           vertical: lerpDouble(0, 6, animation.value)!,
  ///         ),
  ///         child: animation.value == 0
  ///           ? FloatingActionButton(
  ///               child: const Icon(Icons.add),
  ///               onPressed: () {},
  ///             )
  ///           : Align(
  ///               alignment: AlignmentDirectional.centerStart,
  ///               widthFactor: animation.value,
  ///               child: Padding(
  ///                 padding: const EdgeInsetsDirectional.only(start: 8),
  ///                 child: FloatingActionButton.extended(
  ///                   icon: const Icon(Icons.add),
  ///                   label: const Text('CREATE'),
  ///                   onPressed: () {},
  ///                 ),
  ///               ),
  ///             ),
  ///       );
  ///     },
  ///   );
  /// }
  /// ```
  ///
  /// {@end-tool}
  static Animation<double>? extendedAnimation(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            _ExtendedGTNavigationRailAnimation>()!
        .animation;
  }

  @override
  _GTNavigationRailState createState() => _GTNavigationRailState();
}

class _GTNavigationRailState extends State<GTNavigationRail>
    with TickerProviderStateMixin {
  late List<AnimationController> _destinationControllers;
  late List<Animation<double>> _destinationAnimations;
  late AnimationController _extendedController;
  Animation<double>? _extendedAnimation;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  void didUpdateWidget(GTNavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.extended != oldWidget.extended) {
      if (widget.extended) {
        _extendedController.forward();
      } else {
        _extendedController.reverse();
      }
    }

    // No animated segue if the length of the items list changes.
    if (widget.destinations.length != oldWidget.destinations.length) {
      _resetState();
      return;
    }

    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _destinationControllers[oldWidget.selectedIndex].reverse();
      _destinationControllers[widget.selectedIndex].forward();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NavigationRailThemeData navigationRailTheme =
        NavigationRailTheme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    final Color backgroundColor = widget.backgroundColor ??
        navigationRailTheme.backgroundColor ??
        theme.colorScheme.surface;
    final double elevation =
        widget.elevation ?? navigationRailTheme.elevation ?? 0;
    final double minWidth = widget.minWidth ?? _minRailWidth;
    final double minExtendedWidth =
        widget.minExtendedWidth ?? _minExtendedRailWidth;
    final Color baseSelectedColor = theme.colorScheme.primary;
    final Color baseUnselectedColor =
        theme.colorScheme.onSurface.withOpacity(0.64);
    final IconThemeData? defaultUnselectedIconTheme =
        widget.unselectedIconTheme ?? navigationRailTheme.unselectedIconTheme;
    final IconThemeData unselectedIconTheme = IconThemeData(
      size: defaultUnselectedIconTheme?.size ?? 24.0,
      color: defaultUnselectedIconTheme?.color ?? theme.colorScheme.onSurface,
      opacity: defaultUnselectedIconTheme?.opacity ?? 0.64,
    );
    final IconThemeData? defaultSelectedIconTheme =
        widget.selectedIconTheme ?? navigationRailTheme.selectedIconTheme;
    final IconThemeData selectedIconTheme = IconThemeData(
      size: defaultSelectedIconTheme?.size ?? 24.0,
      color: defaultSelectedIconTheme?.color ?? theme.colorScheme.primary,
      opacity: defaultSelectedIconTheme?.opacity ?? 1.0,
    );
    final TextStyle unselectedLabelTextStyle = theme.textTheme.bodyText1!
        .copyWith(color: baseUnselectedColor)
        .merge(widget.unselectedLabelTextStyle ??
            navigationRailTheme.unselectedLabelTextStyle);
    final TextStyle selectedLabelTextStyle = theme.textTheme.bodyText1!
        .copyWith(color: baseSelectedColor)
        .merge(widget.selectedLabelTextStyle ??
            navigationRailTheme.selectedLabelTextStyle);
    final double groupAlignment =
        widget.groupAlignment ?? navigationRailTheme.groupAlignment ?? -1.0;
    final GTNavigationRailLabelType labelType = widget.labelType ??
        navigationRailTheme.labelType as GTNavigationRailLabelType? ??
        GTNavigationRailLabelType.none;

    return _ExtendedGTNavigationRailAnimation(
      animation: _extendedAnimation,
      child: Semantics(
        explicitChildNodes: true,
        child: Material(
          elevation: elevation,
          color: backgroundColor,
          child: Column(
            children: <Widget>[
              _verticalSpacer,
              if (widget.leading != null) ...<Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: lerpDouble(
                        minWidth, minExtendedWidth, _extendedAnimation!.value)!,
                  ),
                  child: widget.leading,
                ),
                _verticalSpacer,
              ],
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    for (int i = 0; i < widget.destinations.length; i += 1)
                      _RailDestination(
                        minWidth: minWidth,
                        minExtendedWidth: minExtendedWidth,
                        extendedTransitionAnimation: _extendedAnimation!,
                        selected: widget.selectedIndex == i,
                        icon: widget.selectedIndex == i
                            ? widget.destinations[i].selectedIcon
                            : widget.destinations[i].icon,
                        label: widget.destinations[i].label,
                        destinationAnimation: _destinationAnimations[i],
                        labelType: labelType,
                        iconTheme: widget.selectedIndex == i
                            ? selectedIconTheme
                            : unselectedIconTheme,
                        labelTextStyle: widget.selectedIndex == i
                            ? selectedLabelTextStyle
                            : unselectedLabelTextStyle,
                        padding: widget.destinations[i].padding,
                        onTap: () {
                          widget.onDestinationSelected!(i);
                        },
                        indexLabel: localizations.tabLabel(
                          tabIndex: i + 1,
                          tabCount: widget.destinations.length,
                        ),
                        tooltip: widget.destinations[i].tooltip,
                      ),
                  ],
                ),
              )),
              if (widget.trailing != null)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: lerpDouble(
                        minWidth, minExtendedWidth, _extendedAnimation!.value)!,
                  ),
                  child: widget.trailing,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _disposeControllers() {
    for (final AnimationController controller in _destinationControllers) {
      controller.dispose();
    }
    _extendedController.dispose();
  }

  void _initControllers() {
    _destinationControllers = List<AnimationController>.generate(
        widget.destinations.length, (int index) {
      return AnimationController(
        duration: kThemeAnimationDuration,
        vsync: this,
      )..addListener(_rebuild);
    });
    _destinationAnimations = _destinationControllers
        .map((AnimationController controller) => controller.view)
        .toList();
    _destinationControllers[widget.selectedIndex].value = 1.0;
    _extendedController = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: this,
      value: widget.extended ? 1.0 : 0.0,
    );
    _extendedAnimation = CurvedAnimation(
      parent: _extendedController,
      curve: Curves.easeInOut,
    );
    _extendedController.addListener(() {
      _rebuild();
    });
  }

  void _resetState() {
    _disposeControllers();
    _initControllers();
  }

  void _rebuild() {
    setState(() {
      // Rebuilding when any of the controllers tick, i.e. when the items are
      // animating.
    });
  }
}

class _RailDestination extends StatelessWidget {
  _RailDestination({
    required this.minWidth,
    required this.minExtendedWidth,
    required this.icon,
    required this.label,
    required this.destinationAnimation,
    required this.extendedTransitionAnimation,
    required this.labelType,
    required this.selected,
    required this.iconTheme,
    required this.labelTextStyle,
    required this.onTap,
    required this.indexLabel,
    this.padding,
    this.tooltip,
  })  : assert(minWidth != null),
        assert(minExtendedWidth != null),
        assert(icon != null),
        assert(label != null),
        assert(destinationAnimation != null),
        assert(extendedTransitionAnimation != null),
        assert(labelType != null),
        assert(selected != null),
        assert(iconTheme != null),
        assert(labelTextStyle != null),
        assert(onTap != null),
        assert(indexLabel != null),
        _positionAnimation = CurvedAnimation(
          parent: ReverseAnimation(destinationAnimation),
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut.flipped,
        );

  final String? tooltip;
  final double minWidth;
  final double minExtendedWidth;
  final Widget icon;
  final Widget label;
  final Animation<double> destinationAnimation;
  final GTNavigationRailLabelType labelType;
  final bool selected;
  final Animation<double> extendedTransitionAnimation;
  final IconThemeData iconTheme;
  final TextStyle labelTextStyle;
  final VoidCallback onTap;
  final String indexLabel;
  final EdgeInsetsGeometry? padding;

  final Animation<double> _positionAnimation;

  @override
  Widget build(BuildContext context) {
    final Widget themedIcon = IconTheme(
      data: iconTheme,
      child: icon,
    );
    final Widget styledLabel = DefaultTextStyle(
      style: labelTextStyle,
      child: label,
    );
    Widget? content;
    switch (labelType) {
      case GTNavigationRailLabelType.none:
        final Widget iconPart = SizedBox(
          width: minWidth,
          height: minWidth,
          child: Align(
            alignment: Alignment.center,
            child: themedIcon,
          ),
        );
        if (extendedTransitionAnimation.value == 0) {
          content = Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Stack(
              children: <Widget>[
                iconPart,
                // For semantics when label is not showing,
                SizedBox(
                  width: 0,
                  height: 0,
                  child: Opacity(
                    alwaysIncludeSemantics: true,
                    opacity: 0.0,
                    child: label,
                  ),
                ),
              ],
            ),
          );
        } else {
          content = Padding(
            padding: padding ?? EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: lerpDouble(minWidth, minExtendedWidth,
                    extendedTransitionAnimation.value)!,
              ),
              child: ClipRect(
                child: Row(
                  children: <Widget>[
                    iconPart,
                    Align(
                      heightFactor: 1.0,
                      widthFactor: extendedTransitionAnimation.value,
                      alignment: AlignmentDirectional.centerStart,
                      child: Opacity(
                        alwaysIncludeSemantics: true,
                        opacity: _extendedLabelFadeValue(),
                        child: styledLabel,
                      ),
                    ),
                    SizedBox(
                        width: _horizontalDestinationPadding *
                            extendedTransitionAnimation.value),
                  ],
                ),
              ),
            ),
          );
        }
        break;
      case GTNavigationRailLabelType.selected:
        final double appearingAnimationValue = 1 - _positionAnimation.value;
        final double? verticalPadding = lerpDouble(
            _verticalDestinationPaddingNoLabel,
            _verticalDestinationPaddingWithLabel,
            appearingAnimationValue);
        content = Container(
          constraints: BoxConstraints(
            minWidth: minWidth,
            minHeight: minWidth,
          ),
          padding: padding ??
              const EdgeInsets.symmetric(
                  horizontal: _horizontalDestinationPadding),
          child: ClipRect(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: verticalPadding),
                themedIcon,
                Align(
                  alignment: Alignment.topCenter,
                  heightFactor: appearingAnimationValue,
                  widthFactor: 1.0,
                  child: Opacity(
                    alwaysIncludeSemantics: true,
                    opacity: selected
                        ? _normalLabelFadeInValue()
                        : _normalLabelFadeOutValue(),
                    child: styledLabel,
                  ),
                ),
                SizedBox(height: verticalPadding),
              ],
            ),
          ),
        );
        break;
      case GTNavigationRailLabelType.all:
        content = Container(
          constraints: BoxConstraints(
            minWidth: minWidth,
            minHeight: minWidth,
          ),
          padding: padding ??
              const EdgeInsets.symmetric(
                  horizontal: _horizontalDestinationPadding),
          child: Column(
            children: <Widget>[
              const SizedBox(height: _verticalDestinationPaddingWithLabel),
              themedIcon,
              styledLabel,
              const SizedBox(height: _verticalDestinationPaddingWithLabel),
            ],
          ),
        );
        break;
    }
    final ColorScheme colors = Theme.of(context).colorScheme;
    Widget body = Material(
      type: MaterialType.transparency,
      clipBehavior: Clip.none,
      child: InkResponse(
        onTap: onTap,
        onHover: (_) {},
        highlightShape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(minWidth / 2.0)),
        containedInkWell: true,
        splashColor: colors.primary.withOpacity(0.12),
        hoverColor: colors.primary.withOpacity(0.04),
        child: content,
      ),
    );
    if (tooltip != null) {
      body = Tooltip(
        message: tooltip!,
        child: body,
      );
    }
    return Semantics(
      container: true,
      selected: selected,
      child: Stack(
        children: <Widget>[
          body,
          Semantics(
            label: indexLabel,
          ),
        ],
      ),
    );
  }

  double _normalLabelFadeInValue() {
    if (destinationAnimation.value < 0.25) {
      return 0;
    } else if (destinationAnimation.value < 0.75) {
      return (destinationAnimation.value - 0.25) * 2;
    } else {
      return 1;
    }
  }

  double _normalLabelFadeOutValue() {
    if (destinationAnimation.value > 0.75) {
      return (destinationAnimation.value - 0.75) * 4.0;
    } else {
      return 0;
    }
  }

  double _extendedLabelFadeValue() {
    return extendedTransitionAnimation.value < 0.25
        ? extendedTransitionAnimation.value * 4.0
        : 1.0;
  }
}

/// Defines the behavior of the labels of a [GTNavigationRail].
///
/// See also:
///
///   * [GTNavigationRail]
enum GTNavigationRailLabelType {
  /// Only the [GTNavigationRailDestination]s are shown.
  none,

  /// Only the selected [GTNavigationRailDestination] will show its label.
  ///
  /// The label will animate in and out as new [GTNavigationRailDestination]s are
  /// selected.
  selected,

  /// All [GTNavigationRailDestination]s will show their label.
  all,
}

/// Defines a [GTNavigationRail] button that represents one "destination" view.
///
/// See also:
///
///  * [GTNavigationRail]
class GTNavigationRailDestination {
  /// Creates a destination that is used with [GTNavigationRail.destinations].
  ///
  /// [icon] and [label] must be non-null. When the [GTNavigationRail.labelType]
  /// is [GTNavigationRailLabelType.none], the label is still used for semantics,
  /// and may still be used if [GTNavigationRail.extended] is true.
  const GTNavigationRailDestination({
    required this.icon,
    Widget? selectedIcon,
    required this.label,
    this.padding,
    this.tooltip,
  })  : selectedIcon = selectedIcon ?? icon,
        assert(icon != null),
        assert(label != null);

  final String? tooltip;

  /// The icon of the destination.
  ///
  /// Typically the icon is an [Icon] or an [ImageIcon] widget. If another type
  /// of widget is provided then it should configure itself to match the current
  /// [IconTheme] size and color.
  ///
  /// If [selectedIcon] is provided, this will only be displayed when the
  /// destination is not selected.
  ///
  /// To make the [GTNavigationRail] more accessible, consider choosing an
  /// icon with a stroked and filled version, such as [Icons.cloud] and
  /// [Icons.cloud_queue]. The [icon] should be set to the stroked version and
  /// [selectedIcon] to the filled version.
  final Widget icon;

  /// An alternative icon displayed when this destination is selected.
  ///
  /// If this icon is not provided, the [GTNavigationRail] will display [icon] in
  /// either state. The size, color, and opacity of the
  /// [GTNavigationRail.selectedIconTheme] will still apply.
  ///
  /// See also:
  ///
  ///  * [GTNavigationRailDestination.icon], for a description of how to pair
  ///    icons.
  final Widget selectedIcon;

  /// The label for the destination.
  ///
  /// The label must be provided when used with the [GTNavigationRail]. When the
  /// [GTNavigationRail.labelType] is [GTNavigationRailLabelType.none], the label is
  /// still used for semantics, and may still be used if
  /// [GTNavigationRail.extended] is true.
  final Widget label;

  /// The amount of space to inset the destination item.
  final EdgeInsetsGeometry? padding;
}

class _ExtendedGTNavigationRailAnimation extends InheritedWidget {
  const _ExtendedGTNavigationRailAnimation({
    Key? key,
    required this.animation,
    required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  final Animation<double>? animation;

  @override
  bool updateShouldNotify(_ExtendedGTNavigationRailAnimation old) =>
      animation != old.animation;
}

const double _minRailWidth = 72.0;
const double _minExtendedRailWidth = 256.0;
const double _horizontalDestinationPadding = 8.0;
const double _verticalDestinationPaddingNoLabel = 24.0;
const double _verticalDestinationPaddingWithLabel = 16.0;
const Widget _verticalSpacer = SizedBox(height: 8.0);
