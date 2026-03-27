class Failure {
  final String? message;
  final int? statusCode;
  // final ErrorType? errorType;

  const Failure({this.statusCode, this.message});
}

class Success {
  final Enum? successType;

  const Success({this.successType});
}
