import 'package:flutter/services.dart';
import 'package:goramp/bloc/index.dart';
import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../utils/index.dart';

class WithTextFieldValidation extends StatelessWidget {
  final TextEditingController? textController;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValidationBloc? validationBloc;
  final ErrorHandler? errorHandler;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final bool autoFocus;
  final bool obscureText;
  final FieldErrors? fieldErrors;
  final int errorMaxLines;
  final bool autoCorrect;
  final bool enabled;
  final bool validationEnabled;
  final TextCapitalization textCapitalization;
  final double? maxWidth;
  final String? errorText;
  final String? initialValue;
  final int helperMaxLines;
  final int? maxLength;
  final Widget? sufficIcon;
  final MaxLengthEnforcement? maxLengthEnforcement;
  List<TextInputFormatter>? inputFormatters;

  WithTextFieldValidation({
    this.textController,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.validationBloc,
    this.labelText,
    this.errorHandler,
    this.autoFocus = false,
    this.obscureText = false,
    this.errorMaxLines = 3,
    this.autoCorrect = false,
    this.fieldErrors,
    this.validationEnabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.maxWidth,
    this.hintText,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.initialValue,
    this.helperMaxLines = 2,
    this.sufficIcon,
    this.maxLength,
    this.maxLengthEnforcement,
    this.inputFormatters,
  });

  Widget _buildTextField(
    BuildContext context,
    String? errorText,
    bool isValid,
  ) {
    final ThemeData themeData = Theme.of(context);
    final cursorWidth = 2.0;
    return TextFormField(
      initialValue: initialValue,
      cursorWidth: cursorWidth,
      controller: textController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: autoFocus,
      autocorrect: autoCorrect,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      enabled: enabled,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        helperMaxLines: helperMaxLines,
        filled: true,
        errorText: errorText,
        errorMaxLines: errorMaxLines,
        suffixIcon: sufficIcon ??
            (isValid
                ? null
                : errorText != null
                    ? IconButton(
                        icon: Icon(
                          MdiIcons.closeCircle,
                          color: themeData.errorColor,
                        ),
                        onPressed: () {
                          textController!.clear();
                        },
                      )
                    : null),
      ),
    );
  }

  Widget _buildValidatedTextField(BuildContext context) {
    if (validationEnabled) {
      return StreamBuilder<ValidationState>(
        stream: validationBloc!.state,
        initialData: fieldErrors != null
            ? ValidationResult(fieldError: fieldErrors)
            : ValidationNoTerm(),
        builder:
            (BuildContext context, AsyncSnapshot<ValidationState> snapshot) {
          final state = snapshot.data;
          String? _errorText = errorText;
          bool isValid = false;
          if (state is ValidationNoTerm) {
            _errorText = errorText;
            isValid = false;
          } else if (state is ValidationResult) {
            if (state.isValid) {
              _errorText = null;
              isValid = true;
            } else {
              _errorText = state.fieldError!.errors[0].message;
              isValid = false;
            }
          }
          return _buildTextField(context, _errorText, isValid);
        },
      );
    } else {
      return _buildTextField(context, errorText, false);
    }
  }

  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: _buildValidatedTextField(context),
      ),
    );
  }
}
