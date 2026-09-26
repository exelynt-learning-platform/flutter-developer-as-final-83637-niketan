import 'package:employee_management/modules/employee_dashboard/data/model/create_employee_request_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';

abstract class EmployeeDashboardRepo {
  Future<List<GetAllEmployeesAttributeModel>> getAllEmployees();
  Future<bool> createEmployee(CreateEmployeeRequestModel createEmployeeRequestModel);
  Future<bool> updateEmployee(String id, CreateEmployeeRequestModel request);

  Future<bool> deleteEmployee(String id);
}
