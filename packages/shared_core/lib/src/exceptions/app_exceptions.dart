class AppException implements Exception {
  final String message;
  final String prefix;

  AppException(this.message, this.prefix);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class NetworkException extends AppException {
  NetworkException([String message = "A network error occurred."])
    : super(message, "Network Error: ");
}

class NotFoundException extends AppException {
  NotFoundException([String message = "The requested resource was not found."])
    : super(message, "Not Found Error: ");
}

class ServerException extends AppException {
  ServerException([String message = "An internal server error occurred."])
    : super(message, "Server Error: ");
}
