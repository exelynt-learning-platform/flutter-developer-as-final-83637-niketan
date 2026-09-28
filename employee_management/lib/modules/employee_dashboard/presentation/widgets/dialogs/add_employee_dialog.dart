import 'package:employee_management/modules/employee_dashboard/data/model/create_employee_request_model.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/bloc/employee_dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployeeDialog extends StatefulWidget {
  const AddEmployeeDialog({super.key});

  @override
  State<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  late final TextEditingController nameController;
  late final TextEditingController avatarController;
  late final TextEditingController emailIdController;
  late final TextEditingController mobileController;
  late final TextEditingController countryController;
  late final TextEditingController stateController;
  late final TextEditingController districtController;
  late final TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    avatarController = TextEditingController();
    emailIdController = TextEditingController();
    mobileController = TextEditingController();
    countryController = TextEditingController();
    stateController = TextEditingController();
    districtController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    avatarController.dispose();
    emailIdController.dispose();
    mobileController.dispose();
    countryController.dispose();
    stateController.dispose();
    districtController.dispose();
    emailController.dispose();

    super.dispose();
  }

  void _createEmployee() {
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

    context.read<EmployeeDashboardBloc>().add(CreateEmployeeEvent(request: request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeDashboardBloc, EmployeeDashboardState>(
      listener: (context, state) {
        if (state is CreateEmployeeSuccess) {
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employee created successfully')));
        }

        if (state is CreateEmployeeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create employee: ${state.message}')));
        }
      },
      builder: (context, state) {
        final bool isCreating = state is CreateEmployeeLoading;

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

          // ------------------------------------------------
          // TITLE
          // ------------------------------------------------
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
                child: Icon(Icons.person_add_alt_1_rounded, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              const Text('Add Employee'),
            ],
          ),

          // ------------------------------------------------
          // CONTENT
          // ------------------------------------------------
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    enabled: !isCreating,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter employee name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: avatarController,
                    enabled: !isCreating,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Avatar URL',
                      hintText: 'Enter avatar URL',
                      prefixIcon: Icon(Icons.image_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: emailIdController,
                    enabled: !isCreating,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Employee Email ID',
                      hintText: 'Enter employee email ID',
                      prefixIcon: Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: mobileController,
                    enabled: !isCreating,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Mobile',
                      hintText: 'Enter mobile number',
                      prefixIcon: Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: countryController,
                    enabled: !isCreating,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      hintText: 'Enter country',
                      prefixIcon: Icon(Icons.public_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: stateController,
                    enabled: !isCreating,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      hintText: 'Enter state',
                      prefixIcon: Icon(Icons.map_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: districtController,
                    enabled: !isCreating,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'District',
                      hintText: 'Enter district',
                      prefixIcon: Icon(Icons.location_city_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: emailController,
                    enabled: !isCreating,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter email address',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ------------------------------------------------
          // ACTIONS
          // ------------------------------------------------
          actions: [
            TextButton(
              onPressed: isCreating
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              child: const Text('Cancel'),
            ),

            FilledButton.icon(
              onPressed: isCreating ? null : _createEmployee,
              icon: isCreating
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check_rounded),
              label: Text(isCreating ? 'Creating...' : 'Create Employee'),
            ),
          ],
        );
      },
    );
  }
}
