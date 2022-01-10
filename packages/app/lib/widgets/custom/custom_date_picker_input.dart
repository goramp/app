// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';

// /// Returns a [DateTime] with just the date of the original, but no time set.
// DateTime _dateOnly(DateTime date) {
//   return DateTime(date.year, date.month, date.day);
// }

// // import 'package:flutter/material/date_utils.dart' as utils;
// class CustomInputDatePickerFormField extends StatefulWidget {
//   /// Creates a [TextFormField] configured to accept and validate a date.
//   ///
//   /// If the optional [initialDate] is provided, then it will be used to populate
//   /// the text field. If the [fieldHintText] is provided, it will be shown.
//   ///
//   /// If [initialDate] is provided, it must not be before [firstDate] or after
//   /// [lastDate]. If [selectableDayPredicate] is provided, it must return `true`
//   /// for [initialDate].
//   ///
//   /// [firstDate] must be on or before [lastDate].
//   ///
//   /// [firstDate], [lastDate], and [autofocus] must be non-null.
//   ///
//   CustomInputDatePickerFormField({
//     Key? key,
//     required DateTime initialDate,
//     required DateTime firstDate,
//     required DateTime lastDate,
//     this.onDateSubmitted,
//     this.onDateSaved,
//     this.selectableDayPredicate,
//     this.errorFormatText,
//     this.errorInvalidText,
//     this.fieldHintText,
//     this.fieldLabelText,
//     this.autofocus = false,
//     this.decoration,
//   })  : assert(firstDate != null),
//         assert(lastDate != null),
//         assert(autofocus != null),
//         initialDate = initialDate != null ? _dateOnly(initialDate) : null,
//         firstDate = _dateOnly(firstDate),
//         lastDate = _dateOnly(lastDate),
//         super(key: key) {
//     assert(!this.lastDate.isBefore(this.firstDate),
//         'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.');
//     assert(initialDate == null || !this.initialDate.isBefore(this.firstDate),
//         'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.');
//     assert(initialDate == null || !this.initialDate.isAfter(this.lastDate),
//         'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.');
//     assert(
//         selectableDayPredicate == null ||
//             initialDate == null ||
//             selectableDayPredicate!(this.initialDate),
//         'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate.');
//   }

//   final InputDecoration? decoration;

//   /// If provided, it will be used as the default value of the field.
//   final DateTime initialDate;

//   /// The earliest allowable [DateTime] that the user can input.
//   final DateTime firstDate;

//   /// The latest allowable [DateTime] that the user can input.
//   final DateTime lastDate;

//   /// An optional method to call when the user indicates they are done editing
//   /// the text in the field. Will only be called if the input represents a valid
//   /// [DateTime].
//   final ValueChanged<DateTime?>? onDateSubmitted;

//   /// An optional method to call with the final date when the form is
//   /// saved via [FormState.save]. Will only be called if the input represents
//   /// a valid [DateTime].
//   final ValueChanged<DateTime?>? onDateSaved;

//   /// Function to provide full control over which [DateTime] can be selected.
//   final SelectableDayPredicate? selectableDayPredicate;

//   /// The error text displayed if the entered date is not in the correct format.
//   final String? errorFormatText;

//   /// The error text displayed if the date is not valid.
//   ///
//   /// A date is not valid if it is earlier than [firstDate], later than
//   /// [lastDate], or doesn't pass the [selectableDayPredicate].
//   final String? errorInvalidText;

//   /// The hint text displayed in the [TextField].
//   ///
//   /// If this is null, it will default to the date format string. For example,
//   /// 'mm/dd/yyyy' for en_US.
//   final String? fieldHintText;

//   /// The label text displayed in the [TextField].
//   ///
//   /// If this is null, it will default to the words representing the date format
//   /// string. For example, 'Month, Day, Year' for en_US.
//   final String? fieldLabelText;

//   /// {@macro flutter.widgets.editableText.autofocus}
//   final bool autofocus;

//   @override
//   _InputDatePickerFormFieldState createState() =>
//       _InputDatePickerFormFieldState();
// }

// class _InputDatePickerFormFieldState
//     extends State<CustomInputDatePickerFormField> {
//   final TextEditingController _controller = TextEditingController();
//   DateTime? _selectedDate;
//   String? _inputText;
//   bool _autoSelected = false;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = widget.initialDate;
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_selectedDate != null) {
//       final MaterialLocalizations localizations =
//           MaterialLocalizations.of(context);
//       _inputText = localizations.formatCompactDate(_selectedDate!);
//       TextEditingValue textEditingValue =
//           _controller.value.copyWith(text: _inputText);
//       // Select the new text if we are auto focused and haven't selected the text before.
//       if (widget.autofocus && !_autoSelected) {
//         textEditingValue = textEditingValue.copyWith(
//             selection: TextSelection(
//           baseOffset: 0,
//           extentOffset: _inputText!.length,
//         ));
//         _autoSelected = true;
//       }
//       _controller.value = textEditingValue;
//     }
//   }

//   DateTime? _parseDate(String? text) {
//     final MaterialLocalizations localizations =
//         MaterialLocalizations.of(context);
//     return localizations.parseCompactDate(text);
//   }

//   bool _isValidAcceptableDate(DateTime? date) {
//     return date != null &&
//         !date.isBefore(widget.firstDate) &&
//         !date.isAfter(widget.lastDate) &&
//         (widget.selectableDayPredicate == null ||
//             widget.selectableDayPredicate!(date));
//   }

//   String? _validateDate(String? text) {
//     final DateTime? date = _parseDate(text);
//     if (date == null) {
//       return widget.errorFormatText ??
//           MaterialLocalizations.of(context).invalidDateFormatLabel;
//     } else if (!_isValidAcceptableDate(date)) {
//       return widget.errorInvalidText ??
//           MaterialLocalizations.of(context).dateOutOfRangeLabel;
//     }
//     return null;
//   }

//   void _handleSaved(String? text) {
//     if (widget.onDateSaved != null) {
//       final DateTime? date = _parseDate(text);
//       if (_isValidAcceptableDate(date)) {
//         _selectedDate = date;
//         _inputText = text;
//         widget.onDateSaved!(date);
//       }
//     }
//   }

//   void _handleSubmitted(String text) {
//     if (widget.onDateSubmitted != null) {
//       final DateTime? date = _parseDate(text);
//       if (_isValidAcceptableDate(date)) {
//         _selectedDate = date;
//         _inputText = text;
//         widget.onDateSubmitted!(date);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final MaterialLocalizations localizations =
//         MaterialLocalizations.of(context);
//     final InputDecorationTheme inputTheme =
//         Theme.of(context).inputDecorationTheme;
//     return TextFormField(
//       decoration: widget.decoration ??
//           InputDecoration(
//             border: inputTheme.border ?? const UnderlineInputBorder(),
//             filled: inputTheme.filled,
//             hintText: widget.fieldHintText ?? localizations.dateHelpText,
//             labelText: widget.fieldLabelText ?? localizations.dateInputLabel,
//           ),
//       validator: _validateDate,
//       keyboardType: TextInputType.datetime,
//       onSaved: _handleSaved,
//       onFieldSubmitted: _handleSubmitted,
//       autofocus: widget.autofocus,
//       controller: _controller,
//     );
//   }
// }
