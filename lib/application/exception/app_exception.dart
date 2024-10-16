class AppException implements Exception {
  final String message;
  final dynamic originalException;

  AppException(this.message, [this.originalException]);

  @override
  String toString() => message;
}
