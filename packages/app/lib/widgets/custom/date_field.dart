import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../styles/index.dart';
import '../helpers/index.dart';
import '../utils/index.dart';

class DateTimeField extends StatelessWidget {
  DateTimeField(
      {Key? key,
      this.fieldName,
      required DateTime dateTime,
      DateTime? minimumDateTime,
      this.showDay = true,
      this.icon,
      required this.onChanged})
      : minimumDate = minimumDateTime != null
            ? DateTime(minimumDateTime.year, minimumDateTime.month,
                minimumDateTime.day)
            : DateTime(dateTime.year, dateTime.month,
                dateTime.day), // minimumDateTime ?? dateTime,
        dateTime = dateTime,
        date = DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final bool showDay;
  final DateTime date;
  final DateTime dateTime;
  final DateTime minimumDate;
  final TimeOfDay time;
  final String? fieldName;
  final ValueChanged<DateTime> onChanged;
  final Icon? icon;

  Widget buildDay(BuildContext context) {
    if (showDay) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        constraints: BoxConstraints.expand(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(DateFormat('MMM d yyyy').format(date)),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      borderRadius: kInputBorderRadius,
      child: InkWell(
        onTap: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return BottomSheetHelper.buildBottomPicker(
                CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: dateTime,
                  minimumDate: minimumDate,
                  onDateTimeChanged: onChanged,
                ),
              );
            },
          );
        },
        child: DefaultTextStyle(
          style: theme.textTheme.subtitle1!,
          child: InputDecorator(
            decoration: InputDecoration(
                prefixIcon: icon,
                enabledBorder: kEventInputBorder,
                disabledBorder: kEventInputBorder,
                focusedBorder: kEventInputBorder,
                contentPadding:
                    const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0),
                filled: true),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: kinputFieldHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(fieldName!, style: theme.textTheme.subtitle1),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: buildDay(context),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    constraints: BoxConstraints.tightFor(width: 86.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('${time.format(context)}'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TimeOfDayField extends StatelessWidget {
  TimeOfDayField(
      {Key? key,
      this.fieldName,
      DateTime? dateTime,
      this.icon,
      this.showDay = true,
      required this.onChanged})
      : dateTime = dateTime ?? DateTime.now(),
        time = TimeOfDay(hour: dateTime!.hour, minute: dateTime.minute),
        super(key: key);

  final bool showDay;
  final DateTime dateTime;
  final TimeOfDay time;
  final String? fieldName;
  final ValueChanged<TimeOfDay> onChanged;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: primaryLight,
      borderRadius: kInputBorderRadius,
      child: InkWell(
        onTap: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return BottomSheetHelper.buildBottomPicker(
                CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: dateTime,
                  onDateTimeChanged: (DateTime date) {
                    if (onChanged != null) {
                      onChanged(
                          TimeOfDay(hour: date.hour, minute: date.minute));
                    }
                  },
                ),
              );
            },
          );
        },
        child: DefaultTextStyle(
          style: theme.textTheme.subtitle1!,
          child: InputDecorator(
            decoration: InputDecoration(
                prefixIcon: icon,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0),
                filled: true),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: kinputFieldHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(fieldName!, style: theme.textTheme.subtitle1),
                  Text(time.format(context), style: theme.textTheme.subtitle1)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
