import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:browser_adapter/browser_adapter.dart';

extension TextStyleZoom on TextStyle {
  /// Temporary fix the following Flutter Web issues
  /// https://github.com/flutter/flutter/issues/63467
  /// https://github.com/flutter/flutter/issues/64904#issuecomment-699039851
  /// https://github.com/flutter/flutter/issues/65526
  TextStyle get withZoomFix => copyWith(wordSpacing: 0);

  TextStyle get withCanvaskitFontFix {
    return this; //isCanvasKitRenderer() ? GoogleFonts.roboto(textStyle: this) : this;
  }
}
