import '../utils/index.dart';

const FieldErrNotUniqueError = "notUnique";

const FieldErrInvalid = "invalid";

const FieldErrRequired = "required";

const FieldErrMinLength = "minLength";

const FieldErrMaxLength = "maxLength";

const FieldErrFormat = "format";

enum FieldErrorType {
  notUnique,
  invalid,
  required,
  minLength,
  maxLength,
  format,
}

class FieldError {
  final FieldErrorType type;
  final String? message;

  FieldError({
    required this.type,
    required this.message,
  });

  static String fromErrorType(FieldErrorType type) {
    switch (type) {
      case FieldErrorType.notUnique:
        return FieldErrNotUniqueError;
      case FieldErrorType.invalid:
        return FieldErrInvalid;
      case FieldErrorType.required:
        return FieldErrRequired;
      case FieldErrorType.minLength:
        return FieldErrMinLength;
      case FieldErrorType.maxLength:
        return FieldErrMaxLength;
      case FieldErrorType.format:
        return FieldErrFormat;
    }
  }

  static FieldErrorType toErrorType(String? type) {
    switch (type) {
      case FieldErrNotUniqueError:
        return FieldErrorType.notUnique;
      case FieldErrInvalid:
        return FieldErrorType.invalid;
      case FieldErrRequired:
        return FieldErrorType.required;
      case FieldErrMinLength:
        return FieldErrorType.minLength;
      case FieldErrMaxLength:
        return FieldErrorType.maxLength;
      case FieldErrFormat:
        return FieldErrorType.format;
    }
    throw new StateError("invalid_type");
  }

  FieldError.fromMap(Map<String, dynamic> map)
      : type = toErrorType(map['type']),
        message = map['message'];

  Map<String, dynamic> toMap() {
    return {
      'key': fromErrorType(type),
      'message': message,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

class FieldErrors {
  final String field;
  final List<FieldError> errors;

  FieldErrors({
    required this.field,
    required this.errors,
  });
}

enum ErrorType {
  validationError,
  unknownError,
  unauthorized,
  expired,
  notFound,
  expiredToken,
  invalidToken,
  alreadyDone,
  noConnection,
}

const ErrValidation = "validation";

const ErrUnauthorized = "unauthorized";

// ErrExpired represents an error that occurs when an entity has expired
const ErrExpired = "expired";

// ErrNotFound represents an error that occurs when an entity cannot be found
const ErrNotFound = "notFound";

// ErrInvlaidToken represents an error that occurs when a token is in an invalid format
const ErrInvlaidToken = "token/invalid";

// ErrMalformedToken represents an error that occurs when a token is in an invalid format
const ErrMalformedToken = "token/malformed";

// ErrExpiredToken represents an error that occurs when a token is expired
const ErrExpiredToken = "token/expired";

// ErrWrongSignature represents an error that occurs with a wrong signature
const ErrInvalidToken = "token/invalid";

// ErrUnknown represents an unknown error
const ErrUnknown = "unknown";

// ErrAlreadyDone represents an error that occurs when an operation on an entity has already been doner
const ErrAlreadyDone = "alreadyDone";

// ErrConnection represents an error that occurs when a connection to the remote server cannot be established
const ErrNoConnection = "noConnection";

class Errors {
  final ErrorType type;
  final String? message;
  final Map<String, List<FieldError>>? fieldErrors;

  Errors({
    required this.type,
    this.message,
    this.fieldErrors,
  });

  static String fromErrorType(ErrorType type) {
    switch (type) {
      case ErrorType.validationError:
        return ErrValidation;
      case ErrorType.unauthorized:
        return ErrUnauthorized;
      case ErrorType.expired:
        return ErrExpired;
      case ErrorType.notFound:
        return ErrNotFound;
      case ErrorType.invalidToken:
        return ErrInvalidToken;
      case ErrorType.expiredToken:
        return ErrExpiredToken;
      case ErrorType.invalidToken:
        return ErrInvalidToken;
      case ErrorType.invalidToken:
        return ErrInvalidToken;
      case ErrorType.alreadyDone:
        return ErrAlreadyDone;
      case ErrorType.noConnection:
        return ErrNoConnection;
      default:
        return ErrUnknown;
    }
  }

  static ErrorType toErrorType(String? type) {
    switch (type) {
      case ErrValidation:
        return ErrorType.validationError;
      case ErrUnauthorized:
        return ErrorType.unauthorized;
      case ErrExpired:
        return ErrorType.expired;
      case ErrNotFound:
        return ErrorType.notFound;
      case ErrInvlaidToken:
        return ErrorType.invalidToken;
      case ErrExpiredToken:
        return ErrorType.expiredToken;
      case ErrInvalidToken:
        return ErrorType.invalidToken;
      case ErrAlreadyDone:
        return ErrorType.alreadyDone;
      case ErrNoConnection:
        return ErrorType.noConnection;
      default:
        return ErrorType.unknownError;
    }
  }

  Errors.fromMap(Map<String, dynamic> map)
      : type = toErrorType(map['errorType']),
        message = map['errorMessage'],
        fieldErrors = map['fields'] != null
            ? asStringKeyedMap(map['fields'])!
                .map<String, List<FieldError>>((String field, dynamic errList) {
                return MapEntry<String, List<FieldError>>(
                    field,
                    (errList as List)
                        .map<FieldError>(
                            (err) => FieldError.fromMap(asStringKeyedMap(err)!))
                        .toList());
              })
            : null;

  Map<String, dynamic> toMap() {
    return {
      'errorType': fromErrorType(type),
      'errorMessage': message,
      'fields': fieldErrors?.map<String, List<Map<String, dynamic>>>(
          (String field, List<FieldError> err) {
        return MapEntry<String, List<Map<String, dynamic>>>(
            field, err.map((e) => e.toMap()).toList());
      })
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
