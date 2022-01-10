//import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// class TagText extends SpecialText {
//   static const String flag = "#";
//   final int start;

//   /// whether show background for @somebody
//   final bool showAtBackground;
//   final Color backgroundColor;

//   TagText(TextStyle textStyle, SpecialTextGestureTapCallback onTap,
//       {this.showAtBackground: false,
//       this.start,
//       this.backgroundColor = Colors.transparent})
//       : super(
//           flag,
//           " ",
//           textStyle,
//         );

//   @override
//   bool isEnd(String value) {
//     return super.isEnd(value);
//   }

//   @override
//   InlineSpan finishText() {
//     final String hashText = toString();
//     return showAtBackground
//         ? BackgroundTextSpan(
//             background: Paint()..color = backgroundColor,
//             text: hashText,
//             actualText: hashText,
//             start: start,
//             deleteAll: true,
//             style: textStyle,
//             recognizer: (TapGestureRecognizer()
//               ..onTap = () {
//                 if (onTap != null) onTap(hashText);
//               }),
//           )
//         : SpecialTextSpan(
//             text: hashText,
//             actualText: hashText,
//             start: start,
//             style: textStyle,
//             recognizer: (TapGestureRecognizer()
//               ..onTap = () {
//                 if (onTap != null) onTap(hashText);
//               }),
//           );
//   }
// }

// class TagTextSpanBuilder extends SpecialTextSpanBuilder {
//   /// whether show background for @somebody
//   final bool showAtBackground;
//   final Color backgroundColor;

//   TagTextSpanBuilder(
//       {this.showAtBackground: false,
//       this.backgroundColor = Colors.transparent});

//   @override
//   TextSpan build(BuildContext context, String data,
//       {TextStyle textStyle, onTap}) {
//     var textSpan =
//         super.build(context, data, textStyle: textStyle, onTap: onTap);
//     return textSpan;
//   }

//   @override
//   SpecialText createSpecialText(BuildContext context, String flag,
//       {TextStyle textStyle, SpecialTextGestureTapCallback onTap, int index}) {
//     if (flag == null || flag == "") return null;

//     try {
//       ///index is end index of start flag, so text start index should be index-(flag.length-1)
//       if (isStart(flag, TagText.flag)) {
//         return TagText(
//           textStyle.copyWith(color: Theme.of(context).colorScheme.secondary),
//           onTap,
//           start: index - (TagText.flag.length - 1),
//           showAtBackground: showAtBackground,
//         );
//       }
//     } catch (error) {
//       print("error: $error");
//       return null;
//     }
//     return null;
//   }
// }

// class TagEditableController extends TextEditingController {
//   final SpecialTextSpanBuilder specialTextSpanBuilder;
//   final BuildContext context;
//   EditableText tt;
//   TagEditableController(
//     this.context, {
//     this.specialTextSpanBuilder,
//     String text,
//   }) : super(text: text);
//   @override
//   TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
//     if (!value.composing.isValid) {
//       if (text.isEmpty) {
//         return TextSpan(style: style, text: text);
//       }
//       return TextSpan(style: style, children: [
//         specialTextSpanBuilder.build(context, text, textStyle: style)
//       ]);
//     }
//     final TextStyle composingStyle = style.merge(
//       const TextStyle(decoration: TextDecoration.underline),
//     );
//     // return super.buildTextSpan(style: style, withComposing: withComposing);
//     final beforeText = value.composing.textBefore(value.text);
//     final insideText = value.composing.textInside(value.text);
//     final afterText = value.composing.textAfter(value.text);

//     final before =
//         specialTextSpanBuilder.build(context, beforeText, textStyle: style);
//     final after =
//         specialTextSpanBuilder.build(context, afterText, textStyle: style);

//     List<InlineSpan> children = List<InlineSpan>();

//     if (before != null) {
//       children.add(before);
//     }

//     children.add(TextSpan(
//       style: composingStyle,
//       text: insideText,
//     ));

//     if (after != null) {
//       children.add(after);
//     }

//     return TextSpan(style: style, children: children);
//   }
// }
