class NetException implements Exception {
  final code;
  final message;

  NetException(this.code, this.message);

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
