import 'package:employee_management/modules/employee_dashboard/data/model/create_employee_request_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/repository/employee_dashboard_repo.dart';
import 'package:employee_management/utils/injectible.dart';

class GetAllEmployeesUseCase {
  Future<List<GetAllEmployeesAttributeModel>> getAllEmployees() async {
    return await serviceLocator<EmployeeDashboardRepo>().getAllEmployees();
  }

  Future<bool> createEmployee(CreateEmployeeRequestModel request) async {
    return await serviceLocator<EmployeeDashboardRepo>().createEmployee(request);
  }

  Future<bool> updateEmployee(String id, CreateEmployeeRequestModel request) async {
    return await serviceLocator<EmployeeDashboardRepo>().updateEmployee(id, request);
  }

  Future<bool> deleteEmployee(String id) async {
    return await serviceLocator<EmployeeDashboardRepo>().deleteEmployee(id);
  }
}
