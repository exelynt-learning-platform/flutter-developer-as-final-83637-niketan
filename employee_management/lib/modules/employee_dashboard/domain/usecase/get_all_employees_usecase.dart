import 'package:employee_management/modules/employee_dashboard/data/model/create_employee_request_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/repository/employee_dashboard_repo.dart';

class GetAllEmployeesUseCase {
  final EmployeeDashboardRepo repository;

  GetAllEmployeesUseCase({required this.repository});

  Future<List<GetAllEmployeesAttributeModel>> getAllEmployees() async {
    return await repository.getAllEmployees();
  }

  Future<bool> createEmployee(CreateEmployeeRequestModel request) async {
    return await repository.createEmployee(request);
  }

  Future<bool> updateEmployee(String id, CreateEmployeeRequestModel request) async {
    return await repository.updateEmployee(id, request);
  }

  Future<bool> deleteEmployee(String id) async {
    return await repository.deleteEmployee(id);
  }
}
