import 'base_auth_exception.dart';

class InvalidAuthMethod extends AuthException {
  InvalidAuthMethod()
      : super(
            "Auth Exception: Invalid Auth Method.\n you tried to pass an auth method where it is not possibble");
}
