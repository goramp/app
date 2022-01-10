//Firebase errors
const FIREBASE_PERMISSION_DENIED = "firestore/permission-denied";
const FIREBASE_INVALID_DISPLAY_NAME = "auth/invalid-display-name";
const FIREBASE_EMAIL_EXIST = "auth/email-already-exists";
const FIREBASE_USER_NOT_FOUND = "auth/user-not-found";
const FIREBASE_PHONE_NUMBER_EXISTS = "auth/phone-number-already-exists";
const DISALLOWED_USERNAMES = ["admin", "administrator", "server"];

// validation constants
const UNIQUE_ERROR_KEY = "unique";
const UNIQUE_ERROR_KEY_MESSAGE = "Already exist";
const INVALID_ERROR_KEY = "invalid";
const INVALID_ERROR_KEY_MESSAGE = "Invalid";
const REQUIRED_ERROR_KEY = "required";
const REQUIRED_ERROR_KEY_MESSAGE = "Can't be empty";
const MIN_LENGTH_ERROR_KEY = "minLength";
const MIN_LENGTH_ERROR_KEY_MESSAGE = "Must be at least ";
const MAX_LENGTH_ERROR_KEY = "maxLength";
const MAX_LENGTH_ERROR_KEY_MESSAGE = "Must not be more than ";
const NOT_MATCH_ERROR_KEY = "notMatch";
const NOT_MATCH_ERROR_KEY_MESSAGE = "Does not match";
const NOT_FOUND_ERROR_KEY = "notFound";
const NOT_FOUND_ERROR_KEY_MESSAGE = "Not found";
const UNKNOWN_ERROR_KEY = "unknown";
const UNKNOWN_ERROR_KEY_MESSAGE = "Unknown error";
const FORMAT_ERROR_KEY = "format";
const FORMAT_ERROR_KEY_MESSAGE = "Invalid format";
const WHITE_SPACE_ERROR_KEY = "whiteSpace";
const WHITE_SPACE_ERROR_KEY_MESSAGE = "No spaces";
const MIN_USERNAME_LENGTH = 3;
const MAX_USERNAME_LENGTH = 30;
const ACCOUNTKIT_PROVIDER = "accountkit";


const CONNECTION_ERROR_MESSAGE = "No connection.";
const CONNECTION_TIMEOUT_MESSAGE = "No connection";
const UKNOWN_ERROR_MESSAGE = "Something went wrong";

const kConnectionError = "connection_error";
const kUnknownError = "unknown_error";

class ConnectionException implements Exception {
  final ConnectionError? error;
  ConnectionException({this.error});
   get message {
     switch(error) {
       case ConnectionError.CONNECT_TIMEOUT:
         return CONNECTION_TIMEOUT_MESSAGE;
       case ConnectionError.RECEIVE_TIMEOUT:
         return CONNECTION_TIMEOUT_MESSAGE;
       case ConnectionError.UNKNOWN_ERROR:
         return CONNECTION_TIMEOUT_MESSAGE;
     }
   }
}

// connection constants
enum ConnectionError {
  CONNECT_TIMEOUT,
  RECEIVE_TIMEOUT,
  UNKNOWN_ERROR,
}
