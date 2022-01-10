import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/widgets/custom/responsive_dialog.dart';
import 'package:goramp/widgets/index.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:timezone/timezone.dart';

const double _datePickerHeaderLandscapeWidth = 152.0;
const double _datePickerHeaderPortraitHeight = 120.0;
const double _headerPaddingLandscape = 16.0;

abstract class _GroupedItem extends Equatable {}

class TimeZonePickerHeader extends StatelessWidget {
  /// Creates a header for use in a date picker dialog.
  TimeZonePickerHeader({
    Key? key,
    required this.helpText,
    this.titleText,
    this.titleSemanticsLabel,
    this.titleStyle,
    required this.orientation,
    this.isShort = false,
    this.icon,
    this.iconTooltip,
    this.onIconPressed,
    this.on24hrs,
    this.is24hrs = true,
  })  : assert(helpText != null),
        assert(orientation != null),
        assert(isShort != null),
        assert(is24hrs != null),
        super(key: key);
  final bool is24hrs;
  final ValueChanged<bool>? on24hrs;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String helpText;

  /// The text that is displayed at the center of the header.
  final String? titleText;

  /// The semantic label associated with the [titleText].
  final String? titleSemanticsLabel;

  /// The [TextStyle] that the title text is displayed with.
  final TextStyle? titleStyle;

  /// The orientation is used to decide how to layout its children.
  final Orientation orientation;

  /// Indicates the header is being displayed in a shorter/narrower context.
  ///
  /// This will be used to tighten up the space between the help text and date
  /// text if `true`. Additionally, it will use a smaller typography style if
  /// `true`.
  ///
  /// This is necessary for displaying the manual input mode in
  /// landscape orientation, in order to account for the keyboard height.
  final bool isShort;

  /// The mode-switching icon that will be displayed in the lower right
  /// in portrait, and lower left in landscape.
  ///
  /// The available icons are described in [Icons].
  final IconData? icon;

  /// The text that is displayed for the tooltip of the icon.
  final String? iconTooltip;

  /// Callback when the user taps the icon in the header.
  ///
  /// The picker will use this to toggle between entry modes.
  final VoidCallback? onIconPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // The header should use the primary color in light themes and surface color in dark
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final Color primarySurfaceColor =
        isDark ? colorScheme.surface : colorScheme.primary;
    final Color onPrimarySurfaceColor =
        isDark ? colorScheme.onSurface : colorScheme.onPrimary;

    final TextStyle? helpStyle = textTheme.overline?.copyWith(
      color: onPrimarySurfaceColor,
    );

    final Text help = Text(
      helpText,
      style: helpStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final Text title = Text(
      titleText!,
      semanticsLabel: titleSemanticsLabel ?? titleText,
      style: titleStyle,
      maxLines: orientation == Orientation.portrait ? 1 : 2,
      overflow: TextOverflow.ellipsis,
    );

    const Color black32 = Color(0x52000000); // Black with 32% opacity
    // inactiveThumbColor = widget.inactiveThumbColor ??
    //     (isDark ? Colors.grey.shade400 : Colors.grey.shade50);
    // inactiveTrackColor =
    //     widget.inactiveTrackColor ?? (isDark ? Colors.white30 : black32);
    final activeColor = isDark ? Colors.grey.shade400 : Colors.grey.shade50;
    final trackColor = isDark ? Colors.white30 : black32;
    final icon = Row(
      children: [
        Switch(
          value: is24hrs,
          onChanged: on24hrs,
          activeColor: activeColor,
          activeTrackColor: trackColor,
          inactiveTrackColor: trackColor,
        ),
        HSpace(Insets.m),
        Text("24 hrs",
            style: textTheme.caption!.copyWith(color: helpStyle?.color)),
      ],
    );

    switch (orientation) {
      case Orientation.portrait:
        return SizedBox(
          height: _datePickerHeaderPortraitHeight,
          child: Material(
            color: primarySurfaceColor,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 16,
                end: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16),
                  help,
                  const Flexible(child: SizedBox(height: 24)),
                  Row(
                    children: <Widget>[
                      Expanded(child: title),
                      icon,
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      case Orientation.landscape:
        return SizedBox(
          width: _datePickerHeaderLandscapeWidth,
          child: Material(
            color: primarySurfaceColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _headerPaddingLandscape,
                  ),
                  child: help,
                ),
                SizedBox(height: isShort ? 16 : 56),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _headerPaddingLandscape,
                    ),
                    child: title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: icon,
                ),
              ],
            ),
          ),
        );
    }
  }
}

void showLocationSelectionPicker({
  required BuildContext context,
  String? title,
  required List<Location> items,
  Location? selectedItem,
  bool? is24hrs,
  ValueChanged<TimeZoneSelection>? onChanged,
  VoidCallback? onConfirmed,
  VoidCallback? onCancelled,
}) {
  assert(items != null);

  showDialog<TimeZoneSelection>(
    context: context,
    builder: (BuildContext context) {
      return TimeZonePickerDialog(
        items: items,
        title: title,
        is24hrs: is24hrs,
        initialItem: selectedItem,
      );
    },
  ).then((selection) {
    if (onChanged != null && selection != null) onChanged(selection);
    if (onCancelled != null && selection == null) onCancelled();
    if (onConfirmed != null && selection != null) onConfirmed();
  });
}

class TimeZoneSelection extends Equatable {
  final Location? location;
  final bool? is24hrs;
  TimeZoneSelection(this.location, {this.is24hrs = false});
  List get props => [location, is24hrs];
}

class TimeZonePickerDialog extends StatefulWidget {
  TimeZonePickerDialog({
    this.title,
    required this.items,
    required this.initialItem,
    required this.is24hrs,
  });

  final List<Location> items;
  final Location? initialItem;
  final String? title;
  final bool? is24hrs;

  @override
  State<TimeZonePickerDialog> createState() =>
      _SelectionPickerDialogState(initialItem, is24hrs);
}

class _SelectionPickerDialogState extends State<TimeZonePickerDialog> {
  _SelectionPickerDialogState(this.selectedItem, this.selectedAmPm);

  Location? selectedItem;
  bool? selectedAmPm;

  @override
  Widget build(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;
    final TextTheme textTheme = theme.textTheme;
    final Color dateColor = colorScheme.brightness == Brightness.light
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final TextStyle? titleStyle = orientation == Orientation.landscape
        ? textTheme.headline6?.copyWith(color: dateColor)
        : textTheme.headline5?.copyWith(color: dateColor);
    return ResponsiveDialog(
      context: context,
      header: TimeZonePickerHeader(
        helpText: S.of(context).select_timezone,
        titleText: S.of(context).ampm,
        titleStyle: titleStyle,
        is24hrs: selectedAmPm!,
        orientation: orientation,
        isShort: orientation == Orientation.landscape,
        on24hrs: (value) => setState(() => selectedAmPm = value),
      ),
      child: TimezoneSelectionPicker(
        timeZones: widget.items,
        initialItem: selectedItem,
        is24hrs: selectedAmPm,
        onChanged: (value) => setState(() => selectedItem = value),
      ),
      okPressed: () => Navigator.of(context).pop(
        TimeZoneSelection(selectedItem, is24hrs: selectedAmPm),
      ),
    );
  }
}

class _GroupedLocationItem extends _GroupedItem {
  final Location? location;
  _GroupedLocationItem(this.location);

  @override
  List get props => [location];
}

class _GroupedHeaderItem extends _GroupedItem {
  final String continent;
  _GroupedHeaderItem(this.continent);
  @override
  List get props => [continent];
}

/// This helper widget manages a scrollable checkbox list inside a picker widget.
class TimezoneSelectionPicker extends StatefulWidget {
  TimezoneSelectionPicker({
    Key? key,
    required this.timeZones,
    required this.initialItem,
    required this.onChanged,
    required this.is24hrs,
    this.icons,
  })  : assert(timeZones != null),
        super(key: key);

  // Constants
  static const double defaultItemHeight = 40.0;

  // Events
  final ValueChanged<Location?> onChanged;

  // Variables
  final List<Location> timeZones;
  final Location? initialItem;
  final List<Icon>? icons;
  final bool? is24hrs;
  @override
  _TimezoneSelectionPickerState createState() {
    return _TimezoneSelectionPickerState(initialItem, is24hrs);
  }
}

class _TimezoneSelectionPickerState extends State<TimezoneSelectionPicker> {
  _TimezoneSelectionPickerState(this.selectedValue, this.selectedAmPm);

  Location? selectedValue;
  bool? selectedAmPm;
  TextEditingController? _queryTextController;
  FocusNode? _focusNode;

  Timer? _timer;
  late DateTime _todayDate;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  List<_GroupedItem> _items = [];

  @override
  void initState() {
    _queryTextController = TextEditingController();
    _focusNode = FocusNode();
    _queryTextController!.addListener(_handleTextChange);
    _items = _getItems(widget.timeZones);
    Future.microtask(() {
      final index = _items.indexOf(_GroupedLocationItem(selectedValue));
      if (index != null && index >= 0) {
        itemScrollController.jumpTo(index: index);
      }
    });
    _updateCurrentDate();
    super.initState();
  }

  void _updateCurrentDate() {
    _todayDate = DateTime.now();
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _updateCurrentDate();
      });
    });
  }

  _handleTextChange() {}

  @override
  void dispose() {
    _timer?.cancel();
    _queryTextController!.removeListener(_handleTextChange);
    _queryTextController!.dispose();
    _focusNode!.dispose();
    super.dispose();
  }

  List<_GroupedItem> _getItems(List<Location> locations) {
    List<_GroupedItem> items = [];
    Map<String, List<Location>> groupedLocationByContinent =
        groupBy<Location, String>(
            locations, (obj) => obj.name.split("/").first);
    groupedLocationByContinent.forEach((key, value) {
      items.add(_GroupedHeaderItem(key));
      items.addAll(value.map((e) => _GroupedLocationItem(e)).toList());
    });
    return items;
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        if (userScroll.metrics.axis != Axis.vertical) {
          return false;
        }
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            _focusNode?.unfocus();
            break;
          case ScrollDirection.reverse:
            _focusNode?.unfocus();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final String searchFieldLabel =
        MaterialLocalizations.of(context).searchFieldLabel;
    final TextStyle? searchFieldStyle = theme.inputDecorationTheme.hintStyle;
    final border = OutlineInputBorder(
        borderRadius: kInputBorderRadius,
        borderSide: BorderSide(color: theme.primaryColor));
    // final bool isDark = theme.brightness == Brightness.dark;
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: Container(
        child: Column(
          children: [
            Material(
              child: Container(
                child: TextField(
                  controller: _queryTextController,
                  focusNode: _focusNode,
                  //style: theme.textTheme.title,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  onSubmitted: (String _) {
                    //_searchBloc.onTextChanged.add(queryTextController.text);
                  },
                  decoration: InputDecoration(
                    border: border,
                    hintText: searchFieldLabel,
                    hintStyle: searchFieldStyle,
                    prefixIcon: Icon(Icons.search),
                    // contentPadding:
                    //     EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  ),
                ),
              ),
            ),
            // Divider(
            //   height: 1.0,
            // ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _queryTextController!,
                builder: (context, TextEditingValue value, _) {
                  final locations = widget.timeZones.where((location) {
                    return location.name
                        .toLowerCase()
                        .contains(value.text.toLowerCase());
                  }).toList();
                  List<_GroupedItem> items =
                      value.text.isEmpty ? _items : _getItems(locations);
                  return Scrollbar(
                    child: ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = items[index];
                        if (item is _GroupedHeaderItem) {
                          return Container(
                            height: 36.0,
                            // color:
                            //     isDark ? theme.dividerColor : Colors.grey[300],
                            child: Text(
                              item.continent.toUpperCase(),
                              style: theme.textTheme.subtitle1!.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 14.0),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                          );
                        }
                        final locationItem = item as _GroupedLocationItem;
                        bool isSelected =
                            (locationItem.location == selectedValue);
                        Color? itemColor = (isSelected)
                            ? theme.selectedRowColor
                            : theme.textTheme.bodyText2!.color;
                        Icon? icon = (widget.icons == null)
                            ? null
                            : widget.icons![index];
                        if (icon != null && icon.color == null)
                          icon = Icon(icon.icon, color: itemColor);

                        final MaterialLocalizations localizations =
                            MaterialLocalizations.of(context);
                        final date = TZDateTime.from(
                          _todayDate,
                          locationItem.location!,
                        );
                        TimeOfDay time =
                            TimeOfDay(hour: date.hour, minute: date.minute);
                        String timeString = IntervalHelper.formatTime(
                            localizations, time,
                            alwaysUse24HourFormat: widget.is24hrs,
                            capitalize: true);

                        return ListTile(
                          leading: icon,
                          selected: isSelected,
                          selectedTileColor: theme.selectedRowColor,
                          title: Text(
                            locationItem.location!.name,
                          ),
                          trailing: Text(timeString),
                          onTap: () {
                            _focusNode!.unfocus();
                            setState(() {
                              selectedValue = locationItem.location;
                              widget.onChanged(selectedValue);
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimezonePicker extends StatefulWidget {
  TimezonePicker(
      {Key? key,
      this.fieldName,
      this.selected,
      this.icon,
      this.hint,
      this.timezone,
      required this.onChanged})
      : assert(onChanged != null),
        super(key: key);
  final String? fieldName;
  final String? timezone;
  final Icon? icon;
  final ValueChanged<TimeZoneSelection> onChanged;
  final TimeZoneSelection? selected;
  final String? hint;
  @override
  State<StatefulWidget> createState() {
    return TimeZonePickerState();
  }
}

class TimeZonePickerState extends State<TimezonePicker> {
  late AppConfig config;
  Timer? _timer;
  late DateTime _todayDate;
  initState() {
    config = context.read();
    _updateCurrentDate();
    super.initState();
  }

  dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(TimezonePicker oldWidget) {
    if (oldWidget.selected != widget.selected) {
      _updateCurrentDate();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateCurrentDate() {
    _todayDate = _now;
    _timer?.cancel();
    _timer = Timer(Duration(minutes: 1), () {
      setState(() {
        _updateCurrentDate();
      });
    });
  }

  DateTime get _now {
    return TZDateTime.from(
      DateTime.now(),
      _selected!,
    );
  }

  Location? get _selected => widget.selected?.location ?? config.timeZone;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    TimeOfDay time =
        TimeOfDay(hour: _todayDate.hour, minute: _todayDate.minute);
    String timeString = IntervalHelper.formatTime(localizations, time,
        alwaysUse24HourFormat: widget.selected!.is24hrs, capitalize: true);
    final kEventInputBorder = OutlineInputBorder(
        borderRadius: kInputBorderRadius,
        borderSide: BorderSide(color: theme.colorScheme.primary));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.ls),
      child: DefaultTextStyle(
        style: theme.textTheme.subtitle1!,
        child: Material(
          child: InkWell(
            borderRadius: kInputBorderRadius,
            onTap: () async {
              showLocationSelectionPicker(
                context: context,
                title: "SELECT TIMEZONE",
                items: config.timeZones!,
                selectedItem: _selected,
                is24hrs: widget.selected!.is24hrs ?? true,
                onChanged: widget.onChanged,
              );
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: widget.fieldName,
                prefixIcon: widget.icon,
                hintText: widget.hint,
                hintStyle: theme.textTheme.subtitle1,
                suffix: Container(
                  child: Text(timeString),
                  //alignment: Alignment.end,
                ),
                suffixIcon: Icon(Icons.chevron_right),
                enabledBorder: kEventInputBorder,
                focusedBorder: kEventInputBorder,
                // filled: true,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: kinputFieldHeight),
                child: Text(
                  _selected!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
