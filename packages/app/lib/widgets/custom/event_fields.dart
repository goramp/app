import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/models/cover_pattern.dart';
import 'package:goramp/widgets/custom/custom_popup_button.dart';
import 'package:goramp/widgets/custom/duration_picker.dart';
import 'package:goramp/widgets/custom/kdropdown_button.dart';
import 'package:goramp/widgets/custom/timezone_picker.dart';
import 'package:goramp/widgets/index.dart';
import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart';
import '../../models/index.dart';
import '../utils/index.dart';
import '../helpers/index.dart';

const String _kDefaultCaption = "Create a title";

typedef Validate<T> = String Function(T value);

InputDecoration _setOutlineBorder(
    BuildContext context, InputDecoration decoration) {
  final theme = Theme.of(context);
  return decoration.copyWith(
      enabledBorder: kEventOutlineInputBorder.copyWith(
        borderSide: BorderSide(
          color: theme.disabledColor,
          width: 1,
        ),
      ),
      focusedBorder: kEventOutlineInputBorder.copyWith(
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 1,
        ),
      ),
      disabledBorder: kEventOutlineInputBorder.copyWith(
        borderSide: BorderSide(
          color: theme.disabledColor,
          width: 1,
        ),
      ));
}

class AvailabilityPicker extends StatefulWidget {
  final VoidCallback onTap;
  final CallLink? event;
  final String? eventId;
  final String? fieldName;
  final Icon? icon;
  final String? suffix;
  final Map<int?, Availability>? weeklyAvailabilities;
  final bool enabled;

  final bool canRequestFocus;
  final bool autofocus;
  final bool useOutline;

  AvailabilityPicker(
    this.eventId, {
    this.weeklyAvailabilities,
    required this.onTap,
    this.fieldName,
    this.icon,
    this.suffix,
    this.event,
    this.enabled = true,
    this.canRequestFocus = true,
    this.autofocus = false,
    this.useOutline = false,
  });

  @override
  _AvailabilityPickerState createState() => _AvailabilityPickerState();
}

class _AvailabilityPickerState extends State<AvailabilityPicker> {
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(
      debugLabel: 'AvailabilityPicker',
      canRequestFocus: widget.canRequestFocus,
    );
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AvailabilityPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode!.canRequestFocus = widget.canRequestFocus;
  }

  Duration get availableHours {
    int totalMinutes = 0;
    widget.weeklyAvailabilities!.forEach((int? day, Availability availability) {
      int sum = 0;
      if (availability.available ?? false) {
        availability.timeslots!.forEach((GTimeInterval? e) {
          sum += (e!.endMinuteOfDay - e.startMinuteOfDay);
        });
        totalMinutes += sum;
      }
    });
    return Duration(minutes: totalMinutes);
  }

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    int hours = availableHours.inMinutes ~/ TimeOfDay.minutesPerHour;
    int minutes = availableHours.inMinutes % TimeOfDay.minutesPerHour;
    String duration;
    if (minutes > 0) {
      duration = "${hours}h, ${minutes}m";
    } else {
      duration = "$hours";
    }
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.subtitle1!,
      child: Material(
        color: Colors.transparent,
        borderRadius: kInputBorderRadius,
        child: InkWell(
          borderRadius: kInputBorderRadius,
          focusNode: focusNode,
          onTap: widget.enabled
              ? () {
                  widget.onTap.call();
                }
              : null,
          child: InputDecorator(
            decoration: InputDecoration(
              enabled: widget.enabled,
              prefixIcon: widget.icon,
              suffixText: widget.suffix,
              suffixStyle: theme.textTheme.caption,
              border: kEventInputBorder,
              enabledBorder: widget.useOutline
                  ? kEventOutlineInputBorder.copyWith(
                      borderSide: BorderSide(color: theme.disabledColor))
                  : kEventInputBorder,
              focusedBorder: widget.useOutline
                  ? kEventOutlineInputBorder.copyWith(
                      borderSide: BorderSide(color: theme.colorScheme.primary))
                  : kEventInputBorder,
              disabledBorder: widget.useOutline
                  ? kEventOutlineInputBorder.copyWith(
                      borderSide: BorderSide(color: theme.disabledColor))
                  : kEventInputBorder,
              floatingLabelBehavior: widget.useOutline
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.never,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Text(widget.fieldName!,
                      style: _getInlineStyle(widget.enabled, theme)),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  constraints: BoxConstraints.tightFor(width: 86.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(duration,
                          style: theme.textTheme.subtitle1!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventTimeZonePicker extends StatefulWidget {
  EventTimeZonePicker(
      {Key? key,
      this.fieldName,
      this.selected,
      this.icon,
      this.hint,
      this.enabled = true,
      this.canRequestFocus = true,
      this.autofocus = false,
      this.useOutline = false,
      this.floatLabel = false,
      required this.onChanged})
      : super(key: key);
  final String? fieldName;
  final Icon? icon;
  final bool enabled;
  final ValueChanged<TimeZoneSelection> onChanged;
  final TimeZoneSelection? selected;
  final String? hint;
  final bool canRequestFocus;
  final bool autofocus;
  final bool useOutline;
  final bool floatLabel;

  @override
  _TimeZonePickerState createState() => _TimeZonePickerState();
}

class _TimeZonePickerState extends State<EventTimeZonePicker> {
  late AppConfig config;
  Timer? _timer;
  late DateTime _todayDate;

  FocusNode? focusNode;

  initState() {
    config = context.read();
    _updateCurrentDate();
    focusNode = FocusNode(
      debugLabel: 'EventTimeZonePicker',
      canRequestFocus: widget.canRequestFocus,
    );
    super.initState();
  }

  dispose() {
    _timer?.cancel();
    focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EventTimeZonePicker oldWidget) {
    if (oldWidget.selected != widget.selected) {
      _updateCurrentDate();
    }
    focusNode!.canRequestFocus = widget.canRequestFocus;
    super.didUpdateWidget(oldWidget);
  }

  void _updateCurrentDate() {
    _todayDate = _now;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 500), () {
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

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    TimeOfDay time =
        TimeOfDay(hour: _todayDate.hour, minute: _todayDate.minute);
    String timeString = IntervalHelper.formatTime(localizations, time,
        alwaysUse24HourFormat: widget.selected!.is24hrs, capitalize: true);
    return DefaultTextStyle(
      style: theme.textTheme.subtitle1!,
      child: Material(
        borderRadius: kInputBorderRadius,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: kInputBorderRadius,
          focusNode: focusNode,
          onTap: widget.enabled
              ? () async {
                  // focusNode.requestFocus();
                  showLocationSelectionPicker(
                    context: context,
                    title: S.of(context).select_timezone.toUpperCase(),
                    items: config.timeZones!,
                    selectedItem: _selected,
                    is24hrs: widget.selected!.is24hrs ?? true,
                    onChanged: widget.onChanged,
                  );
                }
              : null,
          child: InputDecorator(
            decoration: InputDecoration(
                enabled: widget.enabled,
                prefixIcon: widget.icon,
                hintText: widget.hint,
                hintStyle: theme.textTheme.subtitle1,
                border: kEventInputBorder,
                enabledBorder: widget.useOutline
                    ? kEventOutlineInputBorder.copyWith(
                        borderSide: BorderSide(color: theme.disabledColor))
                    : kEventInputBorder,
                focusedBorder: widget.useOutline
                    ? kEventOutlineInputBorder.copyWith(
                        borderSide:
                            BorderSide(color: theme.colorScheme.primary))
                    : kEventInputBorder,
                disabledBorder: widget.useOutline
                    ? kEventOutlineInputBorder.copyWith(
                        borderSide: BorderSide(color: theme.disabledColor))
                    : kEventInputBorder,
                floatingLabelBehavior: widget.useOutline
                    ? FloatingLabelBehavior.always
                    : FloatingLabelBehavior.never,
                suffix: Text(timeString),
                suffixStyle: theme.textTheme.caption,
                labelText: widget.floatLabel ? widget.fieldName! : null),
            child: widget.floatLabel
                ? Text(
                    _selected!.name,
                    style: theme.textTheme.subtitle1!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.fieldName!,
                          style: _getInlineStyle(widget.enabled, theme)),
                      Text(_selected!.name,
                          style: theme.textTheme.subtitle1!
                              .copyWith(fontWeight: FontWeight.bold))
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class TimeFieldOutline extends StatefulWidget {
  final TimeOfDay? selectedTime;
  final String? fieldName;
  final bool enabled;
  final ValueChanged<TimeOfDay> onChanged;
  final Icon? icon;
  final bool canRequestFocus;
  final bool autofocus;

  TimeFieldOutline(
      {Key? key,
      this.fieldName,
      this.selectedTime,
      this.icon,
      this.enabled = true,
      this.canRequestFocus = true,
      this.autofocus = false,
      required this.onChanged})
      : super(key: key);

  @override
  _TimeFieldState createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeFieldOutline> {
  FocusNode? focusNode;

  TextEditingController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.selectedTime != null ? _formatTime : '');
    focusNode = FocusNode(
      debugLabel: 'TimeFieldOutline',
      canRequestFocus: widget.canRequestFocus,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TimeFieldOutline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTime != oldWidget.selectedTime) {
      _controller!.text = widget.selectedTime != null ? _formatTime : '';
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime ?? TimeOfDay(hour: 0, minute: 0),
      builder: (context, child) {
        final Widget mediaQueryWrapper = MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );
        // A hack to use the es_US dateTimeFormat value.
        if (Localizations.localeOf(context).languageCode == 'es') {
          return Localizations.override(
            context: context,
            locale: Locale('es', 'US'),
            child: mediaQueryWrapper,
          );
        }
        return mediaQueryWrapper;
      },
    );
    if (picked != null && picked != widget.selectedTime) {
      print('picked: $picked');
      widget.onChanged(picked);
    }
  }

  String get _formatTime {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    if (widget.selectedTime == null) {
      return "hh:mm am";
    } else {
      return IntervalHelper.formatTime(localizations, widget.selectedTime!,
          alwaysUse24HourFormat: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      controller: _controller,
      autocorrect: false,
      maxLines: 1,
      textInputAction: TextInputAction.done,
      focusNode: focusNode,
      enabled: widget.enabled,
      readOnly: true,
      onTap: widget.enabled
          ? () async {
              _selectTime(context);
            }
          : null,
      decoration: InputDecoration(
          enabled: widget.enabled,
          prefixIcon: widget.icon,
          enabledBorder: kEventOutlineInputBorder.copyWith(
              borderSide: BorderSide(color: theme.disabledColor)),
          focusedBorder: kEventOutlineInputBorder.copyWith(
              borderSide: BorderSide(color: theme.colorScheme.primary)),
          disabledBorder: kEventOutlineInputBorder.copyWith(
              borderSide: BorderSide(color: theme.disabledColor)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: widget.fieldName!,
          // contentPadding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
          hintText: "hh:mm am",
          //filled: true,
          hintStyle: Theme.of(context).textTheme.caption,
          helperStyle: Theme.of(context).textTheme.caption),
    );
  }
}

class DateFieldOutline extends StatefulWidget {
  DateFieldOutline(
      {Key? key,
      this.fieldName,
      this.dateTime,
      this.minimumDate,
      this.maximumDate,
      this.icon,
      this.enabled = true,
      this.canRequestFocus = true,
      this.autofocus = false,
      required this.onChanged})
      : super(key: key);

  final DateTime? dateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final String? fieldName;
  final bool enabled;
  final ValueChanged<DateTime> onChanged;
  final Icon? icon;
  final bool canRequestFocus;
  final bool autofocus;

  @override
  _DateFieldOutlineState createState() => _DateFieldOutlineState();
}

class _DateFieldOutlineState extends State<DateFieldOutline> {
  FocusNode? focusNode;

  TextEditingController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: DateFormat('MM/dd/yyyy').format(widget.dateTime!));
    focusNode = FocusNode(
      debugLabel: 'DateField',
      canRequestFocus: widget.canRequestFocus,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DateFieldOutline oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode!.canRequestFocus = widget.canRequestFocus;
    _controller?.text = DateFormat('MM/dd/yyyy').format(widget.dateTime!);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      controller: _controller,
      autocorrect: false,
      maxLines: 1,
      textInputAction: TextInputAction.done,
      focusNode: focusNode,
      enabled: widget.enabled,
      readOnly: true,
      onTap: widget.enabled
          ? () async {
              focusNode?.requestFocus();
              DateTime? selected = await showDatePicker(
                context: context,
                initialDate: widget.dateTime!,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );

              if (selected != null) {
                widget.onChanged(selected);
              }
              focusNode?.unfocus();
            }
          : null,
      decoration: _setOutlineBorder(
        context,
        InputDecoration(
            enabled: widget.enabled,
            prefixIcon: widget.icon,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: widget.fieldName!,
            // contentPadding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
            //hintText: helperText,
            //filled: true,
            hintStyle: Theme.of(context).textTheme.caption,
            helperStyle: Theme.of(context).textTheme.caption),
      ),
    );
  }
}

class DateField extends StatefulWidget {
  DateField(
      {Key? key,
      this.fieldName,
      this.dateTime,
      this.minimumDate,
      this.maximumDate,
      this.icon,
      this.enabled = true,
      this.canRequestFocus = true,
      this.autofocus = false,
      required this.onChanged})
      : super(key: key);

  final DateTime? dateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final String? fieldName;
  final bool enabled;
  final ValueChanged<DateTime> onChanged;
  final Icon? icon;
  final bool canRequestFocus;
  final bool autofocus;

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(
      debugLabel: 'DateField',
      canRequestFocus: widget.canRequestFocus,
    );
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode!.canRequestFocus = widget.canRequestFocus;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      borderRadius: kInputBorderRadius,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: kInputBorderRadius,
        focusNode: focusNode,
        onTap: widget.enabled
            ? () async {
                // focusNode.requestFocus();
                DateTime? selected = await showDatePicker(
                  context: context,
                  initialDate: widget.dateTime!,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (selected != null) {
                  widget.onChanged(selected);
                }
              }
            : null,
        child: InputDecorator(
          decoration: InputDecoration(
              enabled: widget.enabled,
              prefixIcon: widget.icon,
              border: kEventInputBorder,
              enabledBorder: kEventInputBorder,
              disabledBorder: kEventInputBorder,
              focusedBorder: kEventInputBorder,
              filled: true),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.fieldName!,
                style: _getInlineStyle(widget.enabled, theme),
              ),
              Text(DateFormat('EEE, MMM d yyyy').format(widget.dateTime!),
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}

class DurationDropDownField extends StatelessWidget {
  DurationDropDownField(
      {Key? key,
      this.fieldName,
      this.items,
      this.icon,
      this.selectedItem,
      this.enabled = true,
      this.useOutline = false,
      this.minSuffix,
      required this.onSelected})
      : super(key: key);

  final List<Duration>? items;
  final Duration? selectedItem;
  final String? fieldName;
  final bool enabled;
  final bool useOutline;
  final ValueChanged<Duration?> onSelected;
  final Icon? icon;
  final String? minSuffix;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    TextStyle? defaultStyle = theme.textTheme.subtitle1;
    TextStyle? defaultSuffixStyle = theme.textTheme.caption;

    return KDropdownButtonFormField<Duration>(
      value: selectedItem,
      elevation: 0,
      //itemHeight: 48.0,
      icon: SizedBox.shrink(),
      iconSize: 0,
      items: items!.map<DropdownMenuItem<Duration>>((Duration duration) {
        return DropdownMenuItem<Duration>(
          value: duration,
          child: RichText(
            text: TextSpan(
              text: '${duration.inMinutes} ',
              style: defaultStyle,
              children: <TextSpan>[
                TextSpan(text: minSuffix ?? "mins", style: defaultSuffixStyle),
              ],
            ),
          ),
        );
      }).toList(),
      style: defaultStyle,
      selectedItemBuilder: (context) => items!.map<Widget>((Duration duration) {
        return RichText(
          text: TextSpan(
            text: '${duration.inMinutes} ',
            style: defaultStyle,
            children: <TextSpan>[
              TextSpan(text: minSuffix ?? "mins", style: defaultSuffixStyle),
            ],
          ),
        );
      }).toList(),
      onChanged: onSelected,
      decoration: InputDecoration(
        enabled: enabled,
        prefixIcon: icon,
        filled: false,
        //suffixIcon: Icon(Icons.arrow_drop_down),
        labelText: fieldName,
        enabledBorder: useOutline
            ? kEventOutlineInputBorder.copyWith(
                borderSide: BorderSide(color: theme.disabledColor))
            : kEventInputBorder,
        focusedBorder: useOutline
            ? kEventOutlineInputBorder.copyWith(
                borderSide: BorderSide(color: theme.colorScheme.primary))
            : kEventInputBorder,
        disabledBorder: useOutline
            ? kEventOutlineInputBorder.copyWith(
                borderSide: BorderSide(color: theme.disabledColor))
            : kEventInputBorder,
        floatingLabelBehavior: useOutline
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.never,
      ),
    );
    // return Material(
    //   borderRadius: kInputBorderRadius,
    //   color: Colors.transparent,
    //   child: CustomPopupMenuButton(
    //     itemBuilder: (context) =>
    //         items!.map<PopupMenuEntry<Duration>>((Duration duration) {
    //       return PopupMenuItem<Duration>(
    //         value: duration,
    //         child: RichText(
    //           text: TextSpan(
    //             text: '${duration.inMinutes} ',
    //             style: defaultStyle,
    //             children: <TextSpan>[
    //               TextSpan(
    //                   text: minSuffix ?? "mins", style: defaultSuffixStyle),
    //             ],
    //           ),
    //         ),
    //       );
    //     }).toList(),
    //     enabled: enabled,
    //     onSelected: onSelected,
    //     borderRadius: BorderRadius.only(
    //         topLeft: kInputBorderRadius.topLeft,
    //         topRight: kInputBorderRadius.topRight),
    //     child: InputDecorator(
    //       decoration: InputDecoration(
    //         enabled: enabled,
    //         prefixIcon: icon,
    //         suffixIcon: Icon(Icons.arrow_drop_down),
    //         labelText: fieldName,
    //         enabledBorder: useOutline
    //             ? kEventOutlineInputBorder.copyWith(
    //                 borderSide: BorderSide(color: theme.disabledColor))
    //             : kEventInputBorder,
    //         focusedBorder: useOutline
    //             ? kEventOutlineInputBorder.copyWith(
    //                 borderSide: BorderSide(color: theme.colorScheme.primary))
    //             : kEventInputBorder,
    //         disabledBorder: useOutline
    //             ? kEventOutlineInputBorder.copyWith(
    //                 borderSide: BorderSide(color: theme.disabledColor))
    //             : kEventInputBorder,
    //         floatingLabelBehavior: useOutline
    //             ? FloatingLabelBehavior.always
    //             : FloatingLabelBehavior.never,
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: <Widget>[
    //           Text(selectedItem, style: theme.textTheme.subtitle1)
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class DateRangeField extends StatelessWidget {
  DateRangeField(
      {Key? key,
      this.fieldName,
      this.dateTimeRange,
      this.minimumDate,
      this.maximumDate,
      this.icon,
      this.enabled = true,
      required this.onChanged})
      : super(key: key);

  final DateTimeRange? dateTimeRange;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final String? fieldName;
  final bool enabled;
  final ValueChanged<DateTimeRange> onChanged;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    List<Widget> date = [];
    final style =
        theme.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold);
    if (dateTimeRange!.start == dateTimeRange!.end) {
      date = [
        Text(
          DateFormat('EEE, MMM d yyyy').format(dateTimeRange!.start),
          style: style,
        )
      ];
    } else {
      date = [
        Text(DateFormat('EEE, MMM d yyyy').format(dateTimeRange!.start),
            style: style),
        Text(' - '),
        Text(DateFormat('EEE, MMM d yyyy').format(dateTimeRange!.end),
            style: style),
      ];
    }
    return Material(
      borderRadius: kInputBorderRadius,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: kInputBorderRadius,
        onTap: enabled
            ? () async {
                DateTimeRange? selected = await showDateRangePicker(
                  context: context,
                  initialDateRange: dateTimeRange,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  initialEntryMode: DatePickerEntryMode.input,
                  builder: (BuildContext context, Widget? child) {
                    final appBarTheme =
                        ThemeHelper.buildAppBarTheme(theme, theme.colorScheme);
                    return Theme(
                      data: theme.copyWith(
                        appBarTheme: appBarTheme,
                      ),
                      child: child!,
                    );
                  },
                );

                if (selected != null) {
                  onChanged(selected);
                }
              }
            : null,
        child: InputDecorator(
          decoration: InputDecoration(
              enabled: enabled,
              prefixIcon: icon,
              border: kEventInputBorder,
              enabledBorder: kEventInputBorder,
              disabledBorder: kEventInputBorder,
              focusedBorder: kEventInputBorder,
              filled: true),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(fieldName!, style: _getInlineStyle(enabled, theme)),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Wrap(
                  children: date,
                  alignment: WrapAlignment.end,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

typedef CanSwitch = Future<bool?> Function(BuildContext context, bool value);

class SwitchField extends StatefulWidget {
  SwitchField({
    Key? key,
    this.fieldName,
    this.initialValue,
    this.icon,
    this.validate,
    required this.onChanged,
    this.enabled = true,
    this.helperText,
    this.canSwitch,
    this.suffix,
    this.useOutline = false,
  }) : super(key: key);
  final String? fieldName;
  final ValueChanged<bool?> onChanged;
  final Validate<bool>? validate;
  final Icon? icon;
  final bool useOutline;
  final bool? initialValue;
  final bool enabled;
  final Widget? suffix;
  final String? helperText;
  final CanSwitch? canSwitch;
  @override
  _SwitchFieldState createState() => _SwitchFieldState();
}

class _SwitchFieldState extends State<SwitchField> {
  bool? _enabled = false;
  initState() {
    super.initState();
    _enabled = widget.initialValue;
  }

  didUpdateWidget(SwitchField old) {
    super.didUpdateWidget(old);
    if (old.initialValue != widget.initialValue) {
      _enabled = widget.initialValue;
    }
  }

  toggleSwitch() {
    final value = !_enabled!;
    onChanged(value);
  }

  onChanged(bool value) {
    if (widget.validate != null) {
      final error = widget.validate!(value);
      AlertHelper.showErrorLight(context, description: error);
      setState(() {});
    } else {
      setValue(value);
    }
  }

  void setValue(bool value) async {
    if (widget.canSwitch != null) {
      bool? can = await widget.canSwitch!(context, value);
      if (can != null && !can) {
        return;
      }
    }
    setState(() {
      _enabled = value;
    });
    widget.onChanged(_enabled);
  }

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DefaultTextStyle(
      style: theme.textTheme.subtitle1!,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.enabled ? toggleSwitch : null,
          child: InputDecorator(
            decoration: InputDecoration(
                enabled: widget.enabled,
                prefixIcon: widget.icon,
                hintStyle: theme.textTheme.subtitle1,
                suffixStyle: theme.textTheme.caption,
                border: kEventInputBorder,
                suffix: widget.useOutline ? null : widget.suffix,
                suffixIcon: Switch(
                  value: _enabled!,
                  onChanged: widget.enabled ? onChanged : null,
                  // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                enabledBorder: widget.useOutline
                    ? kEventOutlineInputBorder.copyWith(
                        borderSide: BorderSide(color: theme.disabledColor))
                    : kEventInputBorder,
                focusedBorder: widget.useOutline
                    ? kEventOutlineInputBorder.copyWith(
                        borderSide:
                            BorderSide(color: theme.colorScheme.primary))
                    : kEventInputBorder,
                disabledBorder: widget.useOutline
                    ? kEventOutlineInputBorder.copyWith(
                        borderSide: BorderSide(color: theme.disabledColor))
                    : kEventInputBorder,
                floatingLabelBehavior: widget.useOutline
                    ? FloatingLabelBehavior.always
                    : FloatingLabelBehavior.never,
                helperText: widget.helperText,
                labelText: widget.useOutline ? widget.fieldName! : null),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (widget.useOutline)
                  Text(_enabled! ? S.of(context).yes : S.of(context).no,
                      style: _getInlineStyle(widget.enabled, theme)),
                if (!widget.useOutline)
                  Text(widget.fieldName!,
                      style: _getInlineStyle(widget.enabled, theme)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DurationPicker extends StatefulWidget {
  DurationPicker(
      {Key? key,
      this.fieldName,
      this.selectedItem,
      this.icon,
      this.suffix,
      this.hint,
      this.enabled = true,
      this.canRequestFocus = true,
      this.autofocus = false,
      this.useOutline = false,
      required this.durations,
      required this.onChanged})
      : super(key: key);

  final bool enabled;
  final String? fieldName;
  final Icon? icon;
  final String? suffix;
  final ValueChanged<Duration> onChanged;
  final Duration? selectedItem;
  final List<Duration> durations;
  final String? hint;
  final bool canRequestFocus;
  final bool autofocus;
  final bool useOutline;

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(
      debugLabel: 'DurationPicker',
      canRequestFocus: widget.canRequestFocus,
    );
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DurationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode!.canRequestFocus = widget.canRequestFocus;
  }

  String minFromNum(int num) {
    return num.toString();
  }

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DefaultTextStyle(
      style: theme.textTheme.subtitle1!,
      child: Material(
        borderRadius: kInputBorderRadius,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: kInputBorderRadius,
          focusNode: focusNode,
          onTap: widget.enabled
              ? () async {
                  // focusNode.requestFocus();
                  showDurationScrollPicker(
                    context: context,
                    title: "Select Duration",
                    items: widget.durations,
                    selectedItem: widget.selectedItem,
                    onChanged: widget.onChanged,
                  );
                }
              : null,
          child: InputDecorator(
            decoration: InputDecoration(
              enabled: widget.enabled,
              prefixIcon: widget.icon,
              hintText: widget.hint,
              hintStyle: theme.textTheme.subtitle1,
              suffixText: widget.suffix,
              suffixStyle: theme.textTheme.caption,
              border: kEventInputBorder,
              filled: widget.useOutline ? false : true,
              enabledBorder: widget.useOutline
                  ? kEventOutlineInputBorder.copyWith(
                      borderSide: BorderSide(color: theme.disabledColor))
                  : kEventInputBorder,
              focusedBorder: widget.useOutline
                  ? kEventOutlineInputBorder.copyWith(
                      borderSide: BorderSide(color: theme.colorScheme.primary))
                  : kEventInputBorder,
              disabledBorder: widget.useOutline
                  ? kEventOutlineInputBorder.copyWith(
                      borderSide: BorderSide(color: theme.disabledColor))
                  : kEventInputBorder,
              floatingLabelBehavior: widget.useOutline
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.never,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.fieldName!,
                    style: _getInlineStyle(widget.enabled, theme)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(minFromNum(widget.selectedItem!.inMinutes),
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DescriptionField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? fieldName;
  final String description;
  final Icon? icon;
  final String? suffix;
  final bool enabled;
  DescriptionField(
      {required this.onChanged,
      this.fieldName,
      this.icon,
      this.suffix,
      required this.enabled,
      required this.description});

  _handleAddPrice(BuildContext context) async {
    //NavigationService navigationService = Provider.of(context, listen: false);

    // final _rate = await navigationService.navigateTo(AddPriceRoute,
    //     arguments: PriceInputArgument(
    //       duration: duration.inMinutes,
    //       price: price,
    //       baseRate: baseRate,
    //     ));
    // if (this.onChanged != null) {
    //   this.onChanged(_rate);
    // }
  }

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.subtitle1!,
      child: Material(
        borderRadius: kInputBorderRadius,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: kInputBorderRadius,
          onTap: enabled ? () => this._handleAddPrice(context) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              prefixIcon: icon,
              suffixText: suffix,
              suffixIcon: Icon(Icons.chevron_right),
              suffixStyle: theme.textTheme.caption,
              border: kEventInputBorder,
              enabled: enabled,
              // contentPadding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
              filled: true,
              enabledBorder: kEventInputBorder,
              disabledBorder: kEventInputBorder,
              focusedBorder: kEventInputBorder,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child:
                      Text(fieldName!, style: _getInlineStyle(enabled, theme)),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  constraints: BoxConstraints.tightFor(width: 86.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 8.0,
                      ),
                      Text("$description", style: theme.textTheme.bodyText1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PriceField extends StatefulWidget {
  final CallLinkPayment? payment;
  final String? fieldName;
  final Icon? icon;
  final bool enabled;
  final VoidCallback? onTap;
  final bool canRequestFocus;
  final bool autofocus;
  final bool useOutline;
  PriceField({
    this.payment,
    this.fieldName,
    this.icon,
    required this.enabled,
    this.onTap,
    this.canRequestFocus = true,
    this.autofocus = false,
    this.useOutline = false,
  });

  @override
  _PriceFieldState createState() => _PriceFieldState();
}

class _PriceFieldState extends State<PriceField> {
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(
      debugLabel: 'PriceField',
      canRequestFocus: widget.canRequestFocus,
    );
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PriceField oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode!.canRequestFocus = widget.canRequestFocus;
  }

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter =
        CurrencyHelper.format(context, widget.payment!.currency);
    num total = (widget.payment?.price ?? BigInt.zero) /
        BigInt.from(math.pow(10, widget.payment?.decimals ?? 2));
    final hasValidPrice =
        widget.payment!.price != null && widget.payment!.price! > BigInt.zero;
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.subtitle1!,
      child: Material(
        borderRadius: kInputBorderRadius,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: kInputBorderRadius,
          focusNode: focusNode,
          onTap: widget.enabled
              ? () {
                  // focusNode.requestFocus();
                  widget.onTap!.call();
                }
              : null,
          child: InputDecorator(
            decoration: InputDecoration(
              prefixIcon: widget.icon,
              suffixText: widget.payment!.currency ?? S.of(context).free,
              suffixStyle: theme.textTheme.caption,
              border: kEventInputBorder,
              enabled: widget.enabled,
              // contentPadding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
              filled: widget.useOutline ? false : true,
              enabledBorder: widget.useOutline
                  ? kEventOutlineInputBorder.copyWith(
                      borderSide: BorderSide(color: theme.disabledColor))
                  : kEventInputBorder,
              focusedBorder: widget.useOutline
                  ? kEventOutlineInputBorder.copyWith(
                      borderSide: BorderSide(color: theme.colorScheme.primary))
                  : kEventInputBorder,
              disabledBorder: widget.useOutline
                  ? kEventOutlineInputBorder.copyWith(
                      borderSide: BorderSide(color: theme.disabledColor))
                  : kEventInputBorder,
              floatingLabelBehavior: widget.useOutline
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.never,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Text(widget.fieldName!,
                      style: _getInlineStyle(widget.enabled, theme)),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  constraints: BoxConstraints.tightFor(width: 86.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 8.0,
                      ),
                      if (hasValidPrice)
                        Text("${formatter.format(total)}",
                            style: theme.textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleTextField extends StatelessWidget {
  final String text;
  final String? fieldName;
  final Icon? icon;
  final String? suffix;
  final bool enabled;
  final VoidCallback? onTap;

  TitleTextField(
      {required this.text,
      this.fieldName,
      this.icon,
      this.suffix,
      required this.enabled,
      this.onTap});

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isEmpty = text.isEmpty;
    TextStyle hintStyle = theme.textTheme.caption!.copyWith(fontSize: 16);
    TextStyle? valueStyle = theme.textTheme.subtitle1;
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.subtitle1!,
      child: Material(
        borderRadius: kInputBorderRadius,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: kInputBorderRadius,
          onTap: enabled ? onTap : null,
          child: InputDecorator(
            decoration: InputDecoration(
              prefixIcon: icon,
              suffixText: suffix,
              suffixStyle: theme.textTheme.caption,
              border: kEventInputBorder,
              enabled: enabled,
              // contentPadding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
              filled: true,
              enabledBorder: kEventInputBorder,
              disabledBorder: kEventInputBorder,
              focusedBorder: kEventInputBorder,
            ),
            child: Text(
              isEmpty ? _kDefaultCaption : text,
              style: isEmpty ? hintStyle : valueStyle,
              // specialTextSpanBuilder: TagTextSpanBuilder(),
            ),
          ),
        ),
      ),
    );
  }
}

class TitlePlaceholder extends StatelessWidget {
  final String text;

  const TitlePlaceholder(this.text);

  @override
  Widget build(BuildContext context) {
    bool isEmpty = text.isEmpty;
    ThemeData theme = Theme.of(context);
    TextStyle hintStyle = theme.textTheme.caption!.copyWith(fontSize: 16);
    TextStyle? valueStyle = theme.textTheme.subtitle1;
    return Text(
      isEmpty ? _kDefaultCaption : text,
      style: isEmpty ? hintStyle : valueStyle,
      // specialTextSpanBuilder: TagTextSpanBuilder(),
    );
  }
}

class TitleEditor extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool autoFocus;
  final TextEditingController? controller;
  final String? text;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final int? maxLines;
  final int? maxLength;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? helperText;
  final bool expands;
  const TitleEditor(
      {this.autoFocus = false,
      this.onChanged,
      this.enabled = true,
      this.controller,
      this.focusNode,
      this.onEditingComplete,
      this.onSubmitted,
      this.maxLines,
      this.maxLength,
      this.labelText,
      this.suffixIcon,
      this.prefixIcon,
      this.expands = false,
      this.helperText,
      this.text,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
        controller: controller,
        autofocus: autoFocus,
        autocorrect: false,
        maxLines: maxLines,
        maxLength: maxLength,
        textInputAction: TextInputAction.done,
        focusNode: focusNode,
        enabled: enabled,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        expands: expands,
        decoration: InputDecoration(
            enabled: enabled,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabledBorder: kEventOutlineInputBorder.copyWith(
                borderSide: BorderSide(color: theme.disabledColor)),
            focusedBorder: kEventOutlineInputBorder.copyWith(
                borderSide: BorderSide(color: theme.colorScheme.primary)),
            disabledBorder: kEventOutlineInputBorder.copyWith(
                borderSide: BorderSide(color: theme.disabledColor)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: labelText,
            // contentPadding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
            hintText: helperText,
            //filled: true,
            hintStyle: Theme.of(context).textTheme.caption,
            helperStyle: Theme.of(context).textTheme.caption),
        onChanged: onChanged);
  }
}

class PatternThumbnailField extends StatelessWidget {
  final CoverPattern pattern;
  final Color? color;
  final double height;
  final VoidCallback? onTapImage;
  final Icon? icon;
  final bool enabled;

  const PatternThumbnailField({
    required this.pattern,
    this.color,
    this.height = 300,
    this.onTapImage,
    this.icon,
    this.enabled = true,
  });

  Color _getFillColor(ThemeData themeData) {
    // dark theme: 10% white (enabled), 5% white (disabled)
    // light theme: 4% black (enabled), 2% black (disabled)
    const Color darkEnabled = Color(0x1AFFFFFF);
    const Color darkDisabled = Color(0x0DFFFFFF);
    const Color lightEnabled = Color(0x0A000000);
    const Color lightDisabled = Color(0x05000000);

    switch (themeData.brightness) {
      case Brightness.dark:
        return enabled ? darkEnabled : darkDisabled;
      case Brightness.light:
        return enabled ? lightEnabled : lightDisabled;
    }
  }

  Widget _buildPatternImage() {
    if (pattern.mimeType.startsWith('image/svg')) {
      return PlatformSvg.network(
        pattern.url,
        fit: BoxFit.cover,
        color: color,
      );
    } else {
      return Image(
        image: CachedNetworkImageProvider(pattern.url),
        fit: BoxFit.cover,
        color: color,
      );
    }
  }

  Widget _buildThumbnail(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getFillColor(theme);
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: kInputBorderRadius),
      child: ClipRRect(
        borderRadius: kInputBorderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _buildPatternImage(),
            Material(
              color: color,
              child: InkWell(
                onTap: onTapImage,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      height: height,
      // color: Colors.yellow,
      child: _buildThumbnail(context),
    );
  }
}

class ThumbnailField extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final VoidCallback? onTapImage;
  final Icon? icon;
  final bool enabled;

  const ThumbnailField({
    this.imageUrl,
    this.height = 300,
    this.onTapImage,
    this.icon,
    this.enabled = true,
  });

  Color _getFillColor(ThemeData themeData) {
    // dark theme: 10% white (enabled), 5% white (disabled)
    // light theme: 4% black (enabled), 2% black (disabled)
    const Color darkEnabled = Color(0x1AFFFFFF);
    const Color darkDisabled = Color(0x0DFFFFFF);
    const Color lightEnabled = Color(0x0A000000);
    const Color lightDisabled = Color(0x05000000);

    switch (themeData.brightness) {
      case Brightness.dark:
        return enabled ? darkEnabled : darkDisabled;
      case Brightness.light:
        return enabled ? lightEnabled : lightDisabled;
    }
  }

  Widget _buildThumbnail(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getFillColor(theme);
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: kInputBorderRadius),
      child: ClipRRect(
        borderRadius: kInputBorderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            imageUrl != null
                ? Image(
                    image: CachedNetworkImageProvider(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : SizedBox.shrink(),
            if (icon != null)
              Positioned.fill(
                child: Material(
                  color: color,
                  child: InkWell(
                    onTap: onTapImage,
                    child: Center(
                      child: icon,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      height: height,
      // color: Colors.yellow,
      child: _buildThumbnail(context),
    );
  }
}

class VideoField extends StatelessWidget {
  final Video? video;
  final double height;
  final VoidCallback? onTapImage;
  final Icon? icon;
  final bool enabled;
  const VideoField({
    this.video,
    this.height = 300,
    this.onTapImage,
    this.icon,
    this.enabled = true,
  });

  Color _getFillColor(ThemeData themeData) {
    // dark theme: 10% white (enabled), 5% white (disabled)
    // light theme: 4% black (enabled), 2% black (disabled)
    const Color darkEnabled = Color(0x1AFFFFFF);
    const Color darkDisabled = Color(0x0DFFFFFF);
    const Color lightEnabled = Color(0x0A000000);
    const Color lightDisabled = Color(0x05000000);

    switch (themeData.brightness) {
      case Brightness.dark:
        return enabled ? darkEnabled : darkDisabled;
      case Brightness.light:
        return enabled ? lightEnabled : lightDisabled;
    }
  }

  Widget _buildThumbnail(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getFillColor(theme);
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: kInputBorderRadius),
      child: Hero(
        tag: kTrimmerHeroTag,
        child: ClipRRect(
          borderRadius: kInputBorderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              video?.display?.url != null
                  ? Image(
                      image: CachedNetworkImageProvider(video!.display!.url!),
                      fit: BoxFit.cover,
                    )
                  : SizedBox.shrink(),
              if (icon != null)
                Positioned.fill(
                  child: Material(
                    color: color,
                    child: InkWell(
                      onTap: onTapImage,
                      child: Center(
                        child: icon,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      height: height,
      // color: Colors.yellow,
      child: _buildThumbnail(context),
    );
  }
}

Future<bool?> showDiscardDialog(BuildContext context) async {
  final ThemeData theme = Theme.of(context);
  final TextStyle dialogTextStyle = theme.textTheme.subtitle1!
      .copyWith(color: theme.textTheme.caption!.color);
  final TextStyle? dialogTitleTextStyle = theme.textTheme.headline6;

  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:
            Text(S.of(context).discard_call_link, style: dialogTitleTextStyle),
        content:
            Text(S.of(context).discard_video_changes, style: dialogTextStyle),
        actions: <Widget>[
          TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop(
                    false); // Pops the confirmation dialog but not the page.
              }),
          TextButton(
            child: Text(S.of(context).discard),
            onPressed: () {
              Navigator.of(context)
                  .pop(true); // Returning true to _onWillPop will pop again.
            },
          )
        ],
      );
    },
  );
}

class TagListItem extends StatelessWidget {
  final Tag tag;
  final VoidCallback? onPressed;
  TagListItem(this.tag, {this.onPressed});

  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Material(
      child: ListTile(
        onTap: onPressed,
        leading: const SizedBox(
          width: 40,
          height: 40,
          child: const Icon(MdiIcons.pound),
        ),
        title: Text(
          tag.name!,
          style: theme.textTheme.subtitle1!
              .copyWith(color: theme.colorScheme.secondary),
        ),
        subtitle: Text(
          "${tag.count} views",
        ),
      ),
    );
  }
}

class DescriptionEditor extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final String? fieldName;

  const DescriptionEditor({
    this.onChanged,
    this.controller,
    this.onEditingComplete,
    this.onSubmitted,
    this.fieldName,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        maxLines: null,
        decoration: InputDecoration(
            enabledBorder: kEventInputBorder,
            focusedBorder: kEventInputBorder,
            disabledBorder: kEventInputBorder,
            // contentPadding: EdgeInsets.all(0.0),
            labelText: fieldName,
            //hintText: 'Description',
            contentPadding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
            filled: true,
            hintStyle:
                Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
            helperStyle: Theme.of(context).textTheme.caption),
        onChanged: onChanged);
  }
}

TextStyle _getInlineStyle(bool enabled, ThemeData themeData) {
  return themeData.textTheme.subtitle1!
      .copyWith(color: enabled ? themeData.hintColor : themeData.disabledColor);
}
