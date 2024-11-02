class GoogleSigninCancelException implements Exception {
  final String message;
  final dynamic originalException;

  GoogleSigninCancelException(this.message, [this.originalException]);

  @override
  String toString() => message;
}
