import 'package:employee_management/modules/employee_dashboard/data/model/get_all_employees_response_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';

extension GetAllEmployeesMapper on GetAllEmployeesModelResponse {
  GetAllEmployeesAttributeModel toAttributeModel() {
    return GetAllEmployeesAttributeModel(
      createdAt: createdAt,
      name: name,
      avatar: avatar,
      emailId: emailId,
      mobile: mobile,
      country: country,
      state: state,
      district: district,
      id: id,
      email: email,
      profilePhoto: profilePhoto,
    );
  }
}

extension GetAllEmployeesListMapper on List<GetAllEmployeesModelResponse> {
  List<GetAllEmployeesAttributeModel> toAttributeModelList() {
    return map((employee) => employee.toAttributeModel()).toList();
  }
}
