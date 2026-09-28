import 'package:employee_management/modules/employee_dashboard/data/model/create_employee_request_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/bloc/employee_dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEmployeeDialog extends StatelessWidget {
  final GetAllEmployeesAttributeModel employee;

  const EditEmployeeDialog({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: employee.name ?? '');

    final avatarController = TextEditingController(text: employee.avatar ?? '');

    final emailIdController = TextEditingController(text: employee.emailId ?? '');

    final mobileController = TextEditingController(text: employee.mobile ?? '');

    final countryController = TextEditingController(text: employee.country ?? '');

    final stateController = TextEditingController(text: employee.state ?? '');

    final districtController = TextEditingController(text: employee.district ?? '');

    final emailController = TextEditingController(text: employee.email ?? '');

    return BlocConsumer<EmployeeDashboardBloc, EmployeeDashboardState>(
      listener: (context, state) {
        if (state is UpdateEmployeeSuccess) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employee updated successfully')));

          _disposeControllers(
            nameController,
            avatarController,
            emailIdController,
            mobileController,
            countryController,
            stateController,
            districtController,
            emailController,
          );
        }

        if (state is UpdateEmployeeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update employee: ${state.message}')));
        }
      },
      builder: (context, state) {
        final bool isUpdating = state is UpdateEmployeeLoading;

        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
                child: Icon(Icons.edit_rounded, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              const Text('Edit Employee'),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    enabled: !isUpdating,
                    decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline)),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: avatarController,
                    enabled: !isUpdating,
                    decoration: const InputDecoration(labelText: 'Avatar URL', prefixIcon: Icon(Icons.image_outlined)),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: emailIdController,
                    enabled: !isUpdating,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email ID', prefixIcon: Icon(Icons.email_outlined)),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: mobileController,
                    enabled: !isUpdating,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Mobile', prefixIcon: Icon(Icons.phone_outlined)),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: countryController,
                    enabled: !isUpdating,
                    decoration: const InputDecoration(labelText: 'Country', prefixIcon: Icon(Icons.public)),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: stateController,
                    enabled: !isUpdating,
                    decoration: const InputDecoration(labelText: 'State', prefixIcon: Icon(Icons.location_city_outlined)),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: districtController,
                    enabled: !isUpdating,
                    decoration: const InputDecoration(labelText: 'District', prefixIcon: Icon(Icons.location_on_outlined)),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: emailController,
                    enabled: !isUpdating,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Alternate Email', prefixIcon: Icon(Icons.alternate_email)),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isUpdating
                  ? null
                  : () {
                      _disposeControllers(
                        nameController,
                        avatarController,
                        emailIdController,
                        mobileController,
                        countryController,
                        stateController,
                        districtController,
                        emailController,
                      );

                      Navigator.pop(context);
                    },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: isUpdating
                  ? null
                  : () {
                      final request = CreateEmployeeRequestModel(
                        name: nameController.text.trim(),
                        avatar: avatarController.text.trim(),
                        emailId: emailIdController.text.trim(),
                        mobile: mobileController.text.trim(),
                        country: countryController.text.trim(),
                        state: stateController.text.trim(),
                        district: districtController.text.trim(),
                        email: emailController.text.trim(),
                      );

                      context.read<EmployeeDashboardBloc>().add(UpdateEmployeeEvent(id: employee.id ?? '', request: request));
                    },
              child: isUpdating
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _disposeControllers(
    TextEditingController nameController,
    TextEditingController avatarController,
    TextEditingController emailIdController,
    TextEditingController mobileController,
    TextEditingController countryController,
    TextEditingController stateController,
    TextEditingController districtController,
    TextEditingController emailController,
  ) {
    nameController.dispose();
    avatarController.dispose();
    emailIdController.dispose();
    mobileController.dispose();
    countryController.dispose();
    stateController.dispose();
    districtController.dispose();
    emailController.dispose();
  }
}
