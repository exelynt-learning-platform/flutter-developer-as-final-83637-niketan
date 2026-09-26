part of 'employee_dashboard_bloc.dart';

abstract class EmployeeDashboardEvent {}

class GetAllEmployeesEvent extends EmployeeDashboardEvent {}

class CreateEmployeeEvent extends EmployeeDashboardEvent {
  final CreateEmployeeRequestModel request;

  CreateEmployeeEvent({required this.request});
}

class UpdateEmployeeEvent extends EmployeeDashboardEvent {
  final String id;
  final CreateEmployeeRequestModel request;

  UpdateEmployeeEvent({required this.id, required this.request});
}

class DeleteEmployeeEvent extends EmployeeDashboardEvent {
  final String id;

  DeleteEmployeeEvent({required this.id});
}
