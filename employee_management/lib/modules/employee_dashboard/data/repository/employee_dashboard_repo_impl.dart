import 'dart:convert';

import 'package:employee_management/modules/employee_dashboard/data/mapper/get_all_employees_response_mapper.dart';
import 'package:employee_management/modules/employee_dashboard/data/model/create_employee_request_model.dart';
import 'package:employee_management/modules/employee_dashboard/data/model/get_all_employees_response_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/repository/employee_dashboard_repo.dart';
import 'package:http/http.dart' as http;

class EmployeeDashboardRepoImpl implements EmployeeDashboardRepo {
  static const String _baseUrl = 'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee';
  final http.Client _client;

  EmployeeDashboardRepoImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<List<GetAllEmployeesAttributeModel>> getAllEmployees() async {
    final response = await _client.get(Uri.parse(_baseUrl), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      final List<GetAllEmployeesModelResponse> responseModels = jsonList
          .map((json) => GetAllEmployeesModelResponse.fromJson(json))
          .toList();

      return responseModels.toAttributeModelList();
    }

    throw Exception(
      'Failed to fetch employees. '
      'Status code: ${response.statusCode}',
    );
  }

  @override
  Future<bool> createEmployee(CreateEmployeeRequestModel request) async {
    final response = await _client.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }

  @override
  Future<bool> updateEmployee(String id, CreateEmployeeRequestModel request) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  @override
  Future<bool> deleteEmployee(String id) async {
    final response = await _client.delete(Uri.parse('$_baseUrl/$id'), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
