import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../bloc/index.dart';
import '../../models/index.dart';
import '../../utils/index.dart';

class EditTextInput extends StatelessWidget {
  EditTextInput({
    Key? key,
    this.fieldName,
    this.icon,
    this.suffix,
    this.hint,
    this.focusNode,
    this.suffixIcon,
    this.value,
    this.controller,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.fieldErrors,
    this.errorMaxLines,
    this.autoCorrect = false,
    this.validationEnabled = false,
    this.keyboardType,
    this.textInputAction,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.validationBloc,
    this.autoFocus = false,
    this.obscureText = false,
    this.border,
    this.enabledBorder,
    this.textCapitalization = TextCapitalization.none,
    this.errorHandler,
  }) : super(key: key);
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValidationBloc? validationBloc;
  final ErrorHandler? errorHandler;
  final String? fieldName;
  final String? value;
  final Icon? icon;
  final bool enabled;
  final String? suffix;
  final Widget? suffixIcon;
  final String? hint;
  final int? maxLength;
  final int maxLines;
  final FieldErrors? fieldErrors;
  final int? errorMaxLines;
  final bool autoCorrect;
  final bool validationEnabled;
  final bool autoFocus;
  final bool obscureText;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final TextCapitalization textCapitalization;
  String minFromNum(int num) {
    return num.toString();
  }

  Widget _buildTextField(
    BuildContext context,
    String? errorText,
    bool isValid,
  ) {
    final ThemeData themeData = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: autoFocus,
      autocorrect: autoCorrect,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      enabled: enabled,
      initialValue: value,
      //textCapitalization: textCapitalization,
      maxLengthEnforced: true,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: fieldName,
        border: enabledBorder,
        enabledBorder: enabledBorder,
        errorText: errorText,
        errorMaxLines: errorMaxLines,
        prefixIcon: icon,
        // contentPadding:
        //     const EdgeInsets.fromLTRB(12.0, 16.0, 16.0, 12.0),
        suffixIcon: isValid
            ? null
            : errorText != null
                ? IconButton(
                    icon: Icon(
                      MdiIcons.closeCircle,
                      color: themeData.errorColor,
                    ),
                    onPressed: () {
                      controller!.clear();
                    },
                  )
                : null,
      ),
    );
  }

  Widget build(BuildContext context) {
    if (validationEnabled) {
      return StreamBuilder<ValidationState>(
        stream: validationBloc!.state,
        initialData: fieldErrors != null
            ? ValidationResult(fieldError: fieldErrors)
            : ValidationNoTerm(),
        builder:
            (BuildContext context, AsyncSnapshot<ValidationState> snapshot) {
          final state = snapshot.data;
          String? errorText;
          bool isValid = false;
          if (state is ValidationNoTerm) {
            errorText = null;
            isValid = false;
          } else if (state is ValidationResult) {
            if (state.isValid) {
              errorText = null;
              isValid = true;
            } else {
              errorText = state.fieldError!.errors[0].message;
              isValid = false;
            }
          }
          return _buildTextField(context, errorText, isValid);
        },
      );
    } else {
      return _buildTextField(context, null, false);
    }
  }
}
