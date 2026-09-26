import 'package:employee_management/modules/employee_dashboard/presentation/view/employee_dashboard_mobile_view.dart';
import 'package:employee_management/utils/injectible.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:employee_management/modules/employee_dashboard/presentation/bloc/employee_dashboard_bloc.dart';

class EmployeeDashboardScreen extends StatelessWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<EmployeeDashboardBloc>()..add(GetAllEmployeesEvent()),
      child: const EmployeeDashboardMobileView(),
    );
  }
}
