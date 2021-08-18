class ServerConnectFailedException implements Exception {
  String cause;
  ServerConnectFailedException(this.cause);
}

class InvalidNicknameException implements Exception {
  String cause;
  InvalidNicknameException(this.cause);
}

class ServerRejectedRequestException implements Exception {
  String cause;
  ServerRejectedRequestException(this.cause);
}