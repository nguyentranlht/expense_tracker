// Core error handling
abstract class Failure {
  const Failure();
}

class DatabaseFailure extends Failure {
  final String message;
  const DatabaseFailure(this.message);
}

class ValidationFailure extends Failure {
  final String message;
  const ValidationFailure(this.message);
}