import 'employee_exception.dart';

class EmployeeExceptionMapper {
  const EmployeeExceptionMapper._();

  static EmployeeException fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return const BadRequestException();

      case 401:
        return const UnauthorizedException();

      case 403:
        return const UnauthorizedException('You do not have permission to perform this action.');

      case 404:
        return const NotFoundException();

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return const ServerException();

      default:
        return UnknownEmployeeException('Request failed with status code $statusCode.');
    }
  }
}
