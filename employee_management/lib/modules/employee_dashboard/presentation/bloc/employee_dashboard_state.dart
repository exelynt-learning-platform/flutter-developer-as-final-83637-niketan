part of 'employee_dashboard_bloc.dart';

abstract class EmployeeDashboardState {}

class EmployeeDashboardInitial extends EmployeeDashboardState {}

class EmployeeDashboardLoading extends EmployeeDashboardState {}

class EmployeeDashboardSuccess extends EmployeeDashboardState {
  final List<GetAllEmployeesAttributeModel> employees;

  EmployeeDashboardSuccess({required this.employees});
}

// Create Employee States

class CreateEmployeeLoading extends EmployeeDashboardState {}

class CreateEmployeeSuccess extends EmployeeDashboardState {}

class CreateEmployeeFailure extends EmployeeDashboardState {
  final String message;

  CreateEmployeeFailure({required this.message});
}

// Get All Employees Failure

class EmployeeDashboardFailure extends EmployeeDashboardState {
  final String message;

  EmployeeDashboardFailure({required this.message});
}

class UpdateEmployeeLoading extends EmployeeDashboardState {}

class UpdateEmployeeSuccess extends EmployeeDashboardState {}

class UpdateEmployeeFailure extends EmployeeDashboardState {
  final String message;

  UpdateEmployeeFailure({required this.message});
}

class DeleteEmployeeLoading extends EmployeeDashboardState {}

class DeleteEmployeeSuccess extends EmployeeDashboardState {}

class DeleteEmployeeFailure extends EmployeeDashboardState {
  final String message;

  DeleteEmployeeFailure({required this.message});
}
