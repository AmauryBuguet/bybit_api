class BybitException implements Exception {
  final String message;
  final int code;

  BybitException(this.message, this.code);

  @override
  String toString() => 'BybitException $code : $message';
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'API Exception : $message';
}
