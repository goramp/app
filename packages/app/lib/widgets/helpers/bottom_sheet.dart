import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const double _kPickerSheetHeight = 216.0;

class BottomSheetHelper {
  static Widget buildBottomPicker(Widget picker, {Color? backgroundColor}) {
    return Container(
      height: _kPickerSheetHeight,
      color: backgroundColor,
      padding: const EdgeInsets.only(top: 6.0),
      child: GestureDetector(
        onTap: () {},
        child: SafeArea(
          top: false,
          child: picker,
        ),
      ),
    );
  }
}
