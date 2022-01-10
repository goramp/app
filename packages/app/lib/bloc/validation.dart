import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/models/token.dart';
import 'package:goramp/services/index.dart';
import 'package:email_validator/email_validator.dart' as validator;
import 'package:goramp/utils/index.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/solana.dart';
import '../models/index.dart';

abstract class Validator<T> {
  Stream<ValidationState> validate(T? term);
  String? emptyResultError();
}

class ValidationState {}

class ValidationNoTerm extends ValidationState {
  final Object? initial;
  final FieldErrors? fieldError;
  ValidationNoTerm({this.initial, this.fieldError});
}

class ValidationLoading extends ValidationState {}

class ValidationError extends ValidationState {
  final Object error;
  final StackTrace? stackTrace;
  ValidationError(this.error, {this.stackTrace});
}

class ValidationResult extends ValidationState {
  final FieldErrors? fieldError;
  final String? value;
  ValidationResult({this.fieldError, this.value});

  bool get isValid => fieldError == null;
}

class PasswordValidator extends Validator<String> {
  final BuildContext context;
  final String field;

  PasswordValidator(this.field, {required this.context});

  String? emptyResultError() {
    if (field == Constants.PASSWORD_CONFIRM_FIELD) {
      return S.of(context).confirm_password_is_required;
    }
    return S.of(context).password_required;
  }

  bool isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!(password.contains(RegExp(r"[a-z]")) ||
        password.contains(RegExp(r"[A-Z]")))) return false;
    if (!password.contains(RegExp(r"[0-9]"))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  Stream<ValidationState> validate(String? value) async* {
    if (value == null || value.isEmpty) {
      yield ValidationNoTerm(
          fieldError: FieldErrors(errors: [
        FieldError(
            message: S.of(context).password_required,
            type: FieldErrorType.required)
      ], field: field));
      return;
    }
    if (!isPasswordValid(value)) {
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: S.of(context).password_invalid,
            type: FieldErrorType.maxLength)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
      return;
    }
    yield ValidationResult();
  }
}

class AddressValidator extends Validator<String> {
  final String field;
  final RPCClient client;
  final String? mint;
  final BuildContext context;
  AddressValidator(this.field, this.client, {this.mint, required this.context});

  String? emptyResultError() {
    return null;
  }

  Stream<ValidationState> validate(String? value) async* {
    if (value == null || value.isEmpty) {
      yield ValidationNoTerm();
      return;
    }
    try {
      final account = await client.getAccountInfo(value);
      if (account != null) {
        if (account.owner == SPL_TOKEN_PROGRAM) {
          final tokenAccountInfo =
              SPLTokenAccountInfo.fromSplTokenAccountData(account);
          if (mint != null) {
            if (tokenAccountInfo.mint == mint) {
              yield ValidationResult(value: value);
              return;
            } else {
              final fieldError = FieldErrors(errors: [
                FieldError(
                    message: S.of(context).dst_ady_mint_dont_match,
                    type: FieldErrorType.invalid)
              ], field: field);
              yield ValidationResult(fieldError: fieldError);
              return;
            }
          } else {
            final fieldError = FieldErrors(errors: [
              FieldError(
                  message: S.of(context).dst_ady_mint_dont_match,
                  type: FieldErrorType.invalid)
            ], field: field);
            yield ValidationResult(fieldError: fieldError);
            return;
          }
        } else {
          yield ValidationResult(value: value);
          return;
        }
      } else {
        yield ValidationResult(value: value);
        return;
      }
    } catch (error) {
      Sentry.captureException(error);
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: S.of(context).cant_validate_address,
            type: FieldErrorType.maxLength)
      ], field: field);
      yield ValidationResult(fieldError: fieldError, value: value);
    }
  }
}

class NameValidator extends Validator<String> {
  final String field;
  final BuildContext context;

  NameValidator(this.field, {required this.context});

  String? emptyResultError() {
    var error = S.of(context).name_invalid;
    if (field == Constants.FIRST_NAME_FIELD) {
      error = S.of(context).first_name_required;
    } else if (field == Constants.LAST_NAME_FIELD) {
      error = S.of(context).last_name_required;
    }
    return error;
  }

  Stream<ValidationState> validate(String? value) async* {
    if (value == null || value.isEmpty || value.trim() == "") {
      var error = S.of(context).name_invalid;
      if (field == Constants.FIRST_NAME_FIELD) {
        error = S.of(context).first_name_required;
      } else if (field == Constants.LAST_NAME_FIELD) {
        error = S.of(context).last_name_required;
      }
      yield ValidationNoTerm(
        fieldError: FieldErrors(
            errors: [FieldError(message: error, type: FieldErrorType.required)],
            field: field),
      );
      return;
    }
    yield ValidationResult();
  }
}

class AnyValidator extends Validator<String> {
  final String field;
  final BuildContext context;
  AnyValidator(this.field, {required this.context});
  Stream<ValidationState> validate(String? value) async* {
    if (value == null || value.isEmpty) {
      yield ValidationNoTerm();
      return;
    }
    yield ValidationResult();
  }

  String? emptyResultError() {
    return null;
  }
}

class BirthdayValidator extends Validator<int> {
  final String field;
  final BuildContext context;
  BirthdayValidator(this.field, {required this.context});

  String? emptyResultError() {
    return S.of(context).birthday;
  }

  Stream<ValidationState> validate(int? value) async* {
    if (value == null) {
      yield ValidationNoTerm(
          fieldError: FieldErrors(errors: [
        FieldError(
            message: S.of(context).birthday, type: FieldErrorType.required)
      ], field: field));
    } else if (value >= 18) {
      yield ValidationResult();
    } else {
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: S.of(context).age_too_low, type: FieldErrorType.maxLength)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
    }
  }
}

class EmailValidator extends Validator<String> {
  final String field;
  final bool existsIsValid;
  final bool checkExistence;
  final AppConfig config;
  final BuildContext context;

  EmailValidator(this.field,
      {this.existsIsValid = false,
      required this.config,
      this.checkExistence = true,
      required this.context});

  String? emptyResultError() {
    return S.of(context).email_required;
  }

  Stream<ValidationState> validate(String? value) async* {
    if (value == null || value.isEmpty) {
      yield ValidationNoTerm(
        fieldError: FieldErrors(errors: [
          FieldError(
              message: S.of(context).email_required,
              type: FieldErrorType.required)
        ], field: field),
      );
      return;
    }
    if (value.length >= 255) {
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: S.of(context).character_less_than_255,
            type: FieldErrorType.maxLength)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
      return;
    }
    if (!validator.EmailValidator.validate(value)) {
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: S.of(context).enter_valid_email,
            type: FieldErrorType.format)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
      return;
    }
    yield ValidationResult();
    if (!checkExistence) return;
    final exist = await UserService.emailExist(value, config);
    if (exist == null) {
      yield ValidationResult();
      return;
    }
    if (existsIsValid) {
      if (!exist) {
        final fieldError = FieldErrors(errors: [
          FieldError(
              message: S.of(context).account_does_not_exist,
              type: FieldErrorType.notUnique)
        ], field: field);
        yield ValidationResult(fieldError: fieldError);
        return;
      }
    } else {
      if (exist) {
        final fieldError = FieldErrors(errors: [
          FieldError(
              message: S.of(context).account_with_email_exists,
              type: FieldErrorType.notUnique)
        ], field: field);
        yield ValidationResult(fieldError: fieldError);
        return;
      }
    }
    yield ValidationResult();
  }
}

class UsernameValidator extends Validator<String> {
  final String field;
  final AppConfig config;
  final BuildContext context;
  UsernameValidator(this.field, this.config, {required this.context});

  String? emptyResultError() {
    return S.of(context).username_required;
  }

  Stream<ValidationState> validate(String? value) async* {
    if (value == null || value.isEmpty) {
      yield ValidationNoTerm(
        fieldError: FieldErrors(errors: [
          FieldError(
              message: S.of(context).username_required,
              type: FieldErrorType.invalid)
        ], field: field),
      );
      return;
    }
    if (value.length < 3) {
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: S.of(context).min_username_chars,
            type: FieldErrorType.minLength)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
      return;
    }
    if (value.length > 30) {
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: S.of(context).username_lt_max_chars,
            type: FieldErrorType.maxLength)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
      return;
    }
    String last = value.substring(value.length - 1);
    Pattern basePattern = r'^[A-Za-z0-9]+(?:[_.-][A-Za-z0-9]+)*$';
    Pattern endPattern = r'^[a-zA-Z0-9]*$';
    RegExp baseRegex = new RegExp(basePattern as String);
    RegExp endRegex = new RegExp(endPattern as String);
    if (!endRegex.hasMatch(last)) {
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: S.of(context).username_must_end_in_letter_or_num,
            type: FieldErrorType.format)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
      return;
    } else if (!baseRegex.hasMatch(value)) {
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: S.of(context).username_must_include_latin_chars,
            type: FieldErrorType.format)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
      return;
    }
    yield ValidationResult();
    final exist = await UserService.usernameExist(value, config);
    if (exist != null && exist) {
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: S.of(context).usernmae_already_exists,
            type: FieldErrorType.notUnique)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
      return;
    }
    yield ValidationResult();
  }
}

class DigitCodeValidator extends Validator<String> {
  final String field;
  final AppConfig config;
  final BuildContext context;
  final int length;

  DigitCodeValidator(this.field, this.config, this.length,
      {required this.context});

  String? emptyResultError() {
    return "Code required";
  }

  Stream<ValidationState> validate(String? value) async* {
    if (value == null || value.isEmpty) {
      yield ValidationNoTerm(
        fieldError: FieldErrors(errors: [
          FieldError(message: "Code required", type: FieldErrorType.invalid)
        ], field: field),
      );
      return;
    }
    if (value.length < length || value.length > length) {
      final fieldError = FieldErrors(errors: [
        FieldError(
            message: "Must be $length digits", type: FieldErrorType.maxLength)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
      return;
    }
    Pattern basePattern = r'^[0-9]*$';
    RegExp baseRegex = new RegExp(basePattern as String);
    if (!baseRegex.hasMatch(value)) {
      final fieldError = FieldErrors(errors: [
        FieldError(message: "Invalid code", type: FieldErrorType.format)
      ], field: field);
      yield ValidationResult(fieldError: fieldError);
      return;
    }
    yield ValidationResult();
  }
}

const _debounceDuration = const Duration(milliseconds: 300);

class ValidationBloc<T> {
  final PublishSubject<T?> _term = PublishSubject<T?>();
  late ValueStream<ValidationState> state;
  final Validator validator;
  final Duration debounce;

  ValidationBloc(this.validator,
      {this.debounce = _debounceDuration, T? initialValue}) {
    state = _term
        //.debounceTime(_debounceDuration)
        .switchMap<ValidationState>((T? term) {
      return _validate(term);
    }).shareValueSeeded(ValidationNoTerm(initial: initialValue));
  }

  Sink<T?> get onTextChanged => _term.sink;

  Stream<ValidationState> _validate(T? term) async* {
    try {
      final validationState = await validator.validate(term);
      yield* validationState;
    } catch (error, stacktrace) {
      yield ValidationError(error, stackTrace: stacktrace);
    }
  }

  void dispose() {
    _term.close();
  }
}
