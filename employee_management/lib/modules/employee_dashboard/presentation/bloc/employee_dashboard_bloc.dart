import 'package:employee_management/modules/employee_dashboard/data/model/create_employee_request_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/usecase/get_all_employees_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_dashboard_event.dart';
part 'employee_dashboard_state.dart';

class EmployeeDashboardBloc extends Bloc<EmployeeDashboardEvent, EmployeeDashboardState> {
  final GetAllEmployeesUseCase getAllEmployeesUseCase;

  EmployeeDashboardBloc({required this.getAllEmployeesUseCase}) : super(EmployeeDashboardInitial()) {
    on<GetAllEmployeesEvent>(_getAllEmployees);
    on<CreateEmployeeEvent>(_createEmployee);
    on<UpdateEmployeeEvent>(_updateEmployee);
    on<DeleteEmployeeEvent>(_deleteEmployee);
  }

  Future<void> _getAllEmployees(GetAllEmployeesEvent event, Emitter<EmployeeDashboardState> emit) async {
    emit(EmployeeDashboardLoading());

    try {
      final List<GetAllEmployeesAttributeModel> employees = await getAllEmployeesUseCase.getAllEmployees();

      emit(EmployeeDashboardSuccess(employees: employees));
    } catch (e) {
      emit(EmployeeDashboardFailure(message: e.toString()));
    }
  }

  Future<void> _createEmployee(CreateEmployeeEvent event, Emitter<EmployeeDashboardState> emit) async {
    emit(CreateEmployeeLoading());

    try {
      final bool isCreated = await getAllEmployeesUseCase.createEmployee(event.request);

      if (isCreated) {
        emit(CreateEmployeeSuccess());

        // Refresh employee list
        add(GetAllEmployeesEvent());
      } else {
        emit(CreateEmployeeFailure(message: 'Failed to create employee'));
      }
    } catch (e) {
      emit(CreateEmployeeFailure(message: e.toString()));
    }
  }

  Future<void> _updateEmployee(UpdateEmployeeEvent event, Emitter<EmployeeDashboardState> emit) async {
    emit(UpdateEmployeeLoading());

    try {
      final bool isUpdated = await getAllEmployeesUseCase.updateEmployee(event.id, event.request);

      if (isUpdated) {
        emit(UpdateEmployeeSuccess());

        // Refresh employee list
        add(GetAllEmployeesEvent());
      } else {
        emit(UpdateEmployeeFailure(message: 'Failed to update employee'));
      }
    } catch (e) {
      emit(UpdateEmployeeFailure(message: e.toString()));
    }
  }

  Future<void> _deleteEmployee(DeleteEmployeeEvent event, Emitter<EmployeeDashboardState> emit) async {
    emit(DeleteEmployeeLoading());

    try {
      final bool isDeleted = await getAllEmployeesUseCase.deleteEmployee(event.id);

      if (isDeleted) {
        emit(DeleteEmployeeSuccess());

        // Refresh employee list
        add(GetAllEmployeesEvent());
      } else {
        emit(DeleteEmployeeFailure(message: 'Failed to delete employee'));
      }
    } catch (e) {
      emit(DeleteEmployeeFailure(message: e.toString()));
    }
  }
}
