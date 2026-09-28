abstract class EmployeeException implements Exception {
  final String message;

  const EmployeeException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends EmployeeException {
  const NetworkException([super.message = 'Unable to connect to the server. Please check your internet connection.']);
}

class BadRequestException extends EmployeeException {
  const BadRequestException([super.message = 'Invalid employee request.']);
}

class UnauthorizedException extends EmployeeException {
  const UnauthorizedException([super.message = 'You are not authorized to perform this action.']);
}

class NotFoundException extends EmployeeException {
  const NotFoundException([super.message = 'Employee not found.']);
}

class ServerException extends EmployeeException {
  const ServerException([super.message = 'Server error. Please try again later.']);
}

class UnknownEmployeeException extends EmployeeException {
  const UnknownEmployeeException([super.message = 'Something went wrong. Please try again.']);
}
