import 'package:employee_management/modules/authentication/presentation/bloc/auth_bloc.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/bloc/employee_dashboard_bloc.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/view/employee_dashboard_mobile_view.dart';
import 'package:employee_management/utils/injectible.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmployeeDashboardScreen extends StatelessWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/login');
        }
      },
      child: BlocProvider(
        create: (_) => serviceLocator<EmployeeDashboardBloc>()..add(GetAllEmployeesEvent()),
        child: const EmployeeDashboardMobileView(),
      ),
    );
  }
}
