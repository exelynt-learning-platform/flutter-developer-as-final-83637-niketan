import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/bloc/employee_dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteEmployeeDialog extends StatelessWidget {
  final GetAllEmployeesAttributeModel employee;

  const DeleteEmployeeDialog({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeDashboardBloc, EmployeeDashboardState>(
      listener: (context, state) {
        if (state is DeleteEmployeeSuccess) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${employee.name} deleted successfully')));
        }

        if (state is DeleteEmployeeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete ${employee.name}')));
        }
      },
      builder: (context, state) {
        final isDeleting = state is DeleteEmployeeLoading;

        return AlertDialog(
          title: const Text('Delete Employee'),
          content: Text(
            'Are you sure you want to delete ${employee.name}?\n\n'
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(onPressed: isDeleting ? null : () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: isDeleting
                  ? null
                  : () {
                      context.read<EmployeeDashboardBloc>().add(DeleteEmployeeEvent(id: employee.id ?? ''));
                    },
              child: isDeleting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
