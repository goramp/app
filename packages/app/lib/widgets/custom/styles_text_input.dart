// import 'dart:async';
// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:goramp/widgets/index.dart';
// import 'package:provider/provider.dart';

// class StyledSearchTextInput extends StatefulWidget {
//   final String? label;
//   final TextStyle? style;
//   final EdgeInsets? contentPadding;
//   final bool autoFocus;
//   final bool obscureText;
//   final IconData? icon;
//   final String initialValue;
//   final int? maxLines;
//   final TextEditingController? controller;
//   final TextCapitalization? capitalization;
//   final TextInputType type;
//   final bool? enabled;
//   final bool autoValidate;
//   final bool enableSuggestions;
//   final bool autoCorrect;
//   final String? errorText;
//   final String? hintText;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final InputDecoration? inputDecoration;

//   final Function(String)? onChanged;
//   final Function()? onEditingComplete;
//   final Function()? onEditingCancel;
//   final Function(bool)? onFocusChanged;
//   final Function(FocusNode)? onFocusCreated;
//   final Function(String)? onFieldSubmitted;
//   final Function(String?)? onSaved;
//   final VoidCallback? onTap;

//   const StyledSearchTextInput({
//     Key? key,
//     this.label,
//     this.autoFocus = false,
//     this.obscureText = false,
//     this.type = TextInputType.text,
//     this.icon,
//     this.initialValue = "",
//     this.controller,
//     this.enabled,
//     this.autoValidate = false,
//     this.enableSuggestions = true,
//     this.autoCorrect = true,
//     this.errorText,
//     this.style,
//     this.contentPadding,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.inputDecoration,
//     this.onChanged,
//     this.onEditingComplete,
//     this.onEditingCancel,
//     this.onFocusChanged,
//     this.onFocusCreated,
//     this.onFieldSubmitted,
//     this.onSaved,
//     this.onTap,
//     this.hintText,
//     this.capitalization,
//     this.maxLines,
//   }) : super(key: key);

//   @override
//   StyledSearchTextInputState createState() => StyledSearchTextInputState();
// }

// class StyledSearchTextInputState extends State<StyledSearchTextInput> {
//   TextEditingController? _controller;
//   FocusNode? _focusNode;

//   @override
//   void initState() {
//     _controller =
//         widget.controller ?? TextEditingController(text: widget.initialValue);
//     _focusNode = FocusNode(
//       debugLabel: widget.label ?? "",
//       onKey: (FocusNode node, RawKeyEvent evt) {
//         if (evt is RawKeyDownEvent) {
//           if (evt.logicalKey == LogicalKeyboardKey.escape) {
//             widget.onEditingCancel?.call();
//             return KeyEventResult.handled;
//           }
//         }
//         return KeyEventResult.ignored;
//       },
//       canRequestFocus: true,
//     );
//     // Listen for focus out events
//     _focusNode!
//         .addListener(() => widget.onFocusChanged?.call(_focusNode!.hasFocus));
//     widget.onFocusCreated?.call(_focusNode);
//     if (widget.autoFocus ?? false) {
//       scheduleMicrotask(() => _focusNode!.requestFocus());
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller!.dispose();
//     _focusNode!.dispose();
//     super.dispose();
//   }

//   void clear() => _controller!.clear();

//   String get text => _controller!.text;

//   set text(String value) => _controller!.text = value;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return TextFormField(
//       onChanged: widget.onChanged,
//       onEditingComplete: widget.onEditingComplete,
//       onFieldSubmitted: widget.onFieldSubmitted,
//       onSaved: widget.onSaved,
//       onTap: widget.onTap,
//       autofocus: widget.autoFocus ?? false,
//       focusNode: _focusNode,
//       keyboardType: widget.type,
//       obscureText: widget.obscureText,
//       autocorrect: widget.autoCorrect,
//       autovalidate: widget.autoValidate,
//       enableSuggestions: widget.enableSuggestions,
//       style: widget.style ?? theme.textTheme.headline6,
//       cursorColor: theme.cursorColor,
//       controller: _controller,
//       showCursor: true,
//       enabled: widget.enabled,
//       maxLines: widget.maxLines,
//       textCapitalization: widget.capitalization ?? TextCapitalization.none,
//       decoration: widget.inputDecoration ??
//           InputDecoration(
//               prefixIcon: widget.prefixIcon ?? null,
//               suffixIcon: widget.suffixIcon ?? null,
//               contentPadding: widget.contentPadding ?? EdgeInsets.all(Insets.m),
//               border: OutlineInputBorder(borderSide: BorderSide.none),
//               enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
//               focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
//               disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
//               isDense: true,
//               icon: widget.icon == null ? null : Icon(widget.icon),
//               errorText: widget.errorText,
//               errorMaxLines: 2,
//               hintText: widget.hintText,
//               labelText: widget.label),
//     );
//   }
// }

// class ThinUnderlineBorder extends InputBorder {
//   /// Creates an underline border for an [InputDecorator].
//   ///
//   /// The [borderSide] parameter defaults to [BorderSide.none] (it must not be
//   /// null). Applications typically do not specify a [borderSide] parameter
//   /// because the input decorator substitutes its own, using [copyWith], based
//   /// on the current theme and [InputDecorator.isFocused].
//   ///
//   /// The [borderRadius] parameter defaults to a value where the top left
//   /// and right corners have a circular radius of 4.0. The [borderRadius]
//   /// parameter must not be null.
//   const ThinUnderlineBorder({
//     BorderSide borderSide = const BorderSide(),
//     this.borderRadius = const BorderRadius.only(
//       topLeft: Radius.circular(4.0),
//       topRight: Radius.circular(4.0),
//     ),
//   })  : assert(borderRadius != null),
//         super(borderSide: borderSide);

//   /// The radii of the border's rounded rectangle corners.
//   ///
//   /// When this border is used with a filled input decorator, see
//   /// [InputDecoration.filled], the border radius defines the shape
//   /// of the background fill as well as the bottom left and right
//   /// edges of the underline itself.
//   ///
//   /// By default the top right and top left corners have a circular radius
//   /// of 4.0.
//   final BorderRadius borderRadius;

//   @override
//   bool get isOutline => false;

//   @override
//   UnderlineInputBorder copyWith(
//       {BorderSide? borderSide, BorderRadius? borderRadius}) {
//     return UnderlineInputBorder(
//       borderSide: borderSide ?? this.borderSide,
//       borderRadius: borderRadius ?? this.borderRadius,
//     );
//   }

//   @override
//   EdgeInsetsGeometry get dimensions {
//     return EdgeInsets.only(bottom: borderSide.width);
//   }

//   @override
//   UnderlineInputBorder scale(double t) {
//     return UnderlineInputBorder(borderSide: borderSide.scale(t));
//   }

//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
//     return Path()
//       ..addRect(Rect.fromLTWH(rect.left, rect.top, rect.width,
//           math.max(0.0, rect.height - borderSide.width)));
//   }

//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
//   }

//   @override
//   ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
//     if (a is UnderlineInputBorder) {
//       return UnderlineInputBorder(
//         borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
//         borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
//       );
//     }
//     return super.lerpFrom(a, t);
//   }

//   @override
//   ShapeBorder? lerpTo(ShapeBorder? b, double t) {
//     if (b is UnderlineInputBorder) {
//       return UnderlineInputBorder(
//         borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
//         borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
//       );
//     }
//     return super.lerpTo(b, t);
//   }

//   /// Draw a horizontal line at the bottom of [rect].
//   ///
//   /// The [borderSide] defines the line's color and weight. The `textDirection`
//   /// `gap` and `textDirection` parameters are ignored.
//   @override
//   void paint(
//     Canvas canvas,
//     Rect rect, {
//     double? gapStart,
//     double gapExtent = 0.0,
//     double gapPercentage = 0.0,
//     TextDirection? textDirection,
//   }) {
//     print("Width: ${borderSide.width}");
//     if (borderRadius.bottomLeft != Radius.zero ||
//         borderRadius.bottomRight != Radius.zero)
//       canvas.clipPath(getOuterPath(rect, textDirection: textDirection));
//     canvas.drawLine(rect.bottomLeft, rect.bottomRight, borderSide.toPaint());
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     if (other.runtimeType != runtimeType) return false;
//     return other is InputBorder && other.borderSide == borderSide;
//   }

//   @override
//   int get hashCode => borderSide.hashCode;
// }
