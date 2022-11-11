class AuthException implements Exception {
  final String message;

  AuthException(
    this.message,
  );

  @override
  String toString() {
    return message;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthException && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
