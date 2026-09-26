import 'package:employee_management/modules/authentication/data/repository/auth_repository_impl.dart';
import 'package:employee_management/modules/authentication/domain/repository/auth_repository.dart';
import 'package:employee_management/modules/authentication/presentation/bloc/auth_bloc.dart';
import 'package:employee_management/modules/employee_dashboard/data/repository/employee_dashboard_repo_impl.dart';
import 'package:employee_management/modules/employee_dashboard/domain/repository/employee_dashboard_repo.dart';
import 'package:employee_management/modules/employee_dashboard/domain/usecase/get_all_employees_usecase.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/bloc/employee_dashboard_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  serviceLocator.registerLazySingleton<EmployeeDashboardRepo>(() => EmployeeDashboardRepoImpl());
  serviceLocator.registerLazySingleton<GetAllEmployeesUseCase>(() => GetAllEmployeesUseCase());
  serviceLocator.registerLazySingleton<EmployeeDashboardBloc>(() => EmployeeDashboardBloc());
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  serviceLocator.registerLazySingleton<AuthBloc>(() => AuthBloc(authRepository: serviceLocator<AuthRepository>()));
}
