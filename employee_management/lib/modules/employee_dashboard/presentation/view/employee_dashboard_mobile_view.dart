import 'package:employee_management/modules/authentication/presentation/bloc/auth_bloc.dart';
import 'package:employee_management/modules/employee_dashboard/data/model/create_employee_request_model.dart';
import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/bloc/employee_dashboard_bloc.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/widgets/detail_row_widget.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/widgets/employee_avatar.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/widgets/employee_card_widget.dart';
import 'package:employee_management/utils/theme_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeDashboardMobileView extends StatefulWidget {
  const EmployeeDashboardMobileView({super.key});

  @override
  State<EmployeeDashboardMobileView> createState() => _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardMobileView> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'ID';

  List<GetAllEmployeesAttributeModel> _getFilteredEmployees(List<GetAllEmployeesAttributeModel> employees) {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return employees;
    }

    return employees.where((employee) {
      final value = switch (_selectedFilter) {
        'ID' => employee.id ?? '',
        'Name' => employee.name ?? '',
        'Email' => employee.emailId ?? employee.email ?? '',
        'Mobile' => employee.mobile ?? '',
        'Country' => employee.country ?? '',
        _ => '',
      };

      return value.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshEmployees() async {
    if (!mounted) return;

    context.read<EmployeeDashboardBloc>().add(GetAllEmployeesEvent());
  }

  void _showDeleteDialog(GetAllEmployeesAttributeModel employee) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<EmployeeDashboardBloc>(),
          child: BlocConsumer<EmployeeDashboardBloc, EmployeeDashboardState>(
            listener: (context, state) {
              if (state is DeleteEmployeeSuccess) {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${employee.name} deleted successfully')));
              }

              if (state is DeleteEmployeeFailure) {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('Failed to delete ${employee.name}')));
              }
            },
            builder: (context, state) {
              final bool isDeleting = state is DeleteEmployeeLoading;
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer, shape: BoxShape.circle),
                      child: Icon(Icons.delete_outline_rounded, color: Theme.of(context).colorScheme.onErrorContainer),
                    ),
                    const SizedBox(width: 12),
                    const Text('Delete Employee'),
                  ],
                ),
                content: Text(
                  'Are you sure you want to delete ${employee.name}?\n\n'
                  'This action cannot be undone.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                actions: [
                  TextButton(
                    onPressed: isDeleting
                        ? null
                        : () {
                            Navigator.pop(dialogContext);
                          },
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
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
          ),
        );
      },
    );
  }

  void _showEditEmployeeDialog(GetAllEmployeesAttributeModel employee) {
    final nameController = TextEditingController(text: employee.name ?? '');

    final avatarController = TextEditingController(text: employee.avatar ?? '');

    final emailIdController = TextEditingController(text: employee.emailId ?? '');

    final mobileController = TextEditingController(text: employee.mobile ?? '');

    final countryController = TextEditingController(text: employee.country ?? '');

    final stateController = TextEditingController(text: employee.state ?? '');

    final districtController = TextEditingController(text: employee.district ?? '');

    final emailController = TextEditingController(text: employee.email ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<EmployeeDashboardBloc>(),
          child: BlocConsumer<EmployeeDashboardBloc, EmployeeDashboardState>(
            listener: (context, state) {
              if (state is UpdateEmployeeSuccess) {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Employee updated successfully')));
              }

              if (state is UpdateEmployeeFailure) {
                ScaffoldMessenger.of(
                  this.context,
                ).showSnackBar(SnackBar(content: Text('Failed to update employee: ${state.message}')));
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
                          decoration: const InputDecoration(
                            labelText: 'Alternate Email',
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
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
                            Navigator.pop(dialogContext);
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

                            context.read<EmployeeDashboardBloc>().add(
                              UpdateEmployeeEvent(id: employee.id ?? '', request: request),
                            );
                          },
                    child: isUpdating
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Update'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showEmployeeDetails(GetAllEmployeesAttributeModel employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    EmployeeAvatar(name: employee.name ?? "", avatarUrl: employee.avatar, radius: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee.name ?? "",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Employee ID: ${employee.id ?? ""}', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DetailRowWidget(icon: Icons.email_outlined, label: 'Email', value: employee.emailId ?? ""),
                DetailRowWidget(icon: Icons.alternate_email, label: 'Alternate Email', value: employee.email ?? ""),
                DetailRowWidget(icon: Icons.phone_outlined, label: 'Mobile', value: employee.mobile ?? ""),
                DetailRowWidget(icon: Icons.public, label: 'Country', value: employee.country ?? ""),
                DetailRowWidget(icon: Icons.location_city_outlined, label: 'State', value: employee.state ?? ""),
                DetailRowWidget(icon: Icons.location_on_outlined, label: 'District', value: employee.district ?? ""),
                if (employee.createdAt != null) ...[
                  DetailRowWidget(icon: Icons.calendar_today_outlined, label: 'Created At', value: employee.createdAt!),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          color: colorScheme.primary,
          onRefresh: _refreshEmployees,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),

                        const SizedBox(height: 28),

                        _buildSearchAndFilter(context),

                        const SizedBox(height: 22),

                        _buildEmployeeCount(context),

                        const SizedBox(height: 14),

                        _buildEmployeeList(context),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4,
        onPressed: _showAddEmployeeDialog,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add Employee', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showAddEmployeeDialog() {
    final nameController = TextEditingController();
    final avatarController = TextEditingController();
    final emailIdController = TextEditingController();
    final mobileController = TextEditingController();
    final countryController = TextEditingController();
    final stateController = TextEditingController();
    final districtController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<EmployeeDashboardBloc>(),
          child: BlocConsumer<EmployeeDashboardBloc, EmployeeDashboardState>(
            listener: (context, state) {
              if (state is CreateEmployeeSuccess) {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Employee created successfully')));
              }

              if (state is CreateEmployeeFailure) {
                ScaffoldMessenger.of(
                  this.context,
                ).showSnackBar(SnackBar(content: Text('Failed to create employee: ${state.message}')));
              }
            },
            builder: (context, state) {
              final bool isCreating = state is CreateEmployeeLoading;

              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

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

                actions: [
                  TextButton(
                    onPressed: isCreating
                        ? null
                        : () {
                            Navigator.pop(dialogContext);
                          },
                    child: const Text('Cancel'),
                  ),

                  FilledButton.icon(
                    onPressed: isCreating
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

                            context.read<EmployeeDashboardBloc>().add(CreateEmployeeEvent(request: request));
                          },
                    icon: isCreating
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.check_rounded),
                    label: Text(isCreating ? 'Creating...' : 'Create Employee'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    User? user;

    try {
      final authBloc = context.read<AuthBloc>();

      if (authBloc.state is Authenticated) {
        user = (authBloc.state as Authenticated).user;
      }
    } catch (_) {
      user = null;
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primaryContainer, colorScheme.surfaceContainerHighest],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 650;

          if (isSmall) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderTitle(context),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(child: _buildProfileSummary(context, user)),
                    const SizedBox(width: 8),
                    _buildThemeButton(context),
                    _buildLogoutButton(context),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: _buildHeaderTitle(context)),

              _buildProfileSummary(context, user),

              const SizedBox(width: 10),

              _buildThemeButton(context),

              _buildLogoutButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(14)),
              child: Icon(Icons.people_alt_rounded, color: colorScheme.onPrimary, size: 24),
            ),

            const SizedBox(width: 12),

            Text('Employees', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          'Manage your employees and keep your team organized.',
          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildProfileSummary(BuildContext context, User? user) {
    if (user == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final imageUrl = user.photoURL ?? '';
    final name = user.displayName?.trim().isNotEmpty == true ? user.displayName! : 'Employee User';

    final email = user.email ?? 'No email available';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: imageUrl.isEmpty
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
                  )
                : null,
          ),

          const SizedBox(width: 10),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [BoxShadow(blurRadius: 20, offset: const Offset(0, 6), color: Colors.black.withValues(alpha: 0.04))],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 650;

          if (isSmall) {
            return Column(children: [_buildSearchField(), const SizedBox(height: 12), _buildFilterDropdown()]);
          }

          return Row(
            children: [
              Expanded(child: _buildSearchField()),

              const SizedBox(width: 14),

              SizedBox(width: 210, child: _buildFilterDropdown()),
            ],
          );
        },
      ),
    );
  }
  // Widget _buildSearchAndFilter(BuildContext context) {
  //   return Card(
  //     elevation: 0,
  //     margin: EdgeInsets.zero,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: LayoutBuilder(
  //         builder: (context, constraints) {
  //           final isSmall = constraints.maxWidth < 640;

  //           if (isSmall) {
  //             return Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [_buildSearchField(), const SizedBox(height: 12), _buildFilterDropdown()],
  //             );
  //           }

  //           return Row(
  //             children: [
  //               Expanded(child: _buildSearchField()),
  //               const SizedBox(width: 12),
  //               SizedBox(width: 200, child: _buildFilterDropdown()),
  //             ],
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
  Widget _buildSearchField() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: _selectedFilter == 'ID' ? 'Search by employee ID' : 'Search by $_selectedFilter',
        prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close_rounded),
              )
            : null,
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }

  // Widget _buildSearchField() {
  //   return TextField(
  //     controller: _searchController,
  //     onChanged: (_) => setState(() {}),
  //     textInputAction: TextInputAction.search,
  //     decoration: InputDecoration(
  //       hintText: _selectedFilter == 'ID' ? 'Search by employee ID' : 'Search by $_selectedFilter',
  //       prefixIcon: const Icon(Icons.search_rounded),
  //       suffixIcon: _searchController.text.isNotEmpty
  //           ? IconButton(
  //               onPressed: () {
  //                 _searchController.clear();
  //                 setState(() {});
  //               },
  //               icon: const Icon(Icons.clear_rounded),
  //             )
  //           : null,
  //       filled: true,
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide(color: Colors.grey.shade300),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildFilterDropdown() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DropdownButtonFormField<String>(
      initialValue: _selectedFilter,
      decoration: InputDecoration(
        labelText: 'Filter employees',
        prefixIcon: Icon(Icons.filter_list_rounded, color: colorScheme.primary),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'ID', child: Text('Employee ID')),
        DropdownMenuItem(value: 'Name', child: Text('Name')),
        DropdownMenuItem(value: 'Email', child: Text('Email')),
        DropdownMenuItem(value: 'Mobile', child: Text('Mobile')),
        DropdownMenuItem(value: 'Country', child: Text('Country')),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedFilter = value;
        });
      },
    );
  }
  // Widget _buildFilterDropdown() {
  //   return DropdownButtonFormField<String>(
  //     initialValue: _selectedFilter,
  //     decoration: InputDecoration(
  //       labelText: 'Filter by',
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //     items: const [
  //       DropdownMenuItem(value: 'ID', child: Text('ID')),
  //       DropdownMenuItem(value: 'Name', child: Text('Name')),
  //       DropdownMenuItem(value: 'Email', child: Text('Email')),
  //       DropdownMenuItem(value: 'Mobile', child: Text('Mobile')),
  //       DropdownMenuItem(value: 'Country', child: Text('Country')),
  //     ],
  //     onChanged: (value) {
  //       if (value == null) return;

  //       setState(() {
  //         _selectedFilter = value;
  //       });
  //     },
  //   );
  // }
  Widget _buildEmployeeCount(BuildContext context) {
    return BlocBuilder<EmployeeDashboardBloc, EmployeeDashboardState>(
      builder: (context, state) {
        if (state is EmployeeDashboardSuccess) {
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.groups_rounded, size: 18, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    const SizedBox(width: 7),
                    Text(
                      '${state.employees.length} Employees',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
  // Widget _buildEmployeeCount(BuildContext context) {
  //   return BlocBuilder<EmployeeDashboardBloc, EmployeeDashboardState>(
  //     builder: (context, state) {
  //       if (state is EmployeeDashboardSuccess) {
  //         return Row(
  //           children: [
  //             Text(
  //               '${state.employees.length} Employees',
  //               style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         );
  //       }

  //       return const SizedBox();
  //     },
  //   );
  // }

  Widget _buildEmployeeList(BuildContext context) {
    return BlocBuilder<EmployeeDashboardBloc, EmployeeDashboardState>(
      builder: (context, state) {
        // if (state is EmployeeDashboardLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        if (state is EmployeeDashboardLoading) {
          return SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 36, height: 36, child: CircularProgressIndicator(strokeWidth: 3)),
                  const SizedBox(height: 16),
                  Text(
                    'Loading employees...',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is EmployeeDashboardFailure) {
          final colorScheme = Theme.of(context).colorScheme;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: colorScheme.errorContainer, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Icon(Icons.cloud_off_rounded, size: 52, color: colorScheme.onErrorContainer),

                const SizedBox(height: 16),

                Text(
                  'Something went wrong',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onErrorContainer),
                ),

                const SizedBox(height: 8),

                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.onErrorContainer),
                ),

                const SizedBox(height: 18),

                FilledButton.icon(
                  onPressed: _refreshEmployees,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          );
        }
        // if (state is EmployeeDashboardFailure) {
        //   return Center(child: Text(state.message, textAlign: TextAlign.center));
        // }

        if (state is EmployeeDashboardSuccess) {
          final employees = _getFilteredEmployees(state.employees);

          if (state.employees.isEmpty) {
            return _buildEmptyState();
          }

          if (employees.isEmpty) {
            return _buildEmptyState(message: 'No employees match your search');
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              int crossAxisCount;

              if (width >= 1100) {
                crossAxisCount = 3;
              } else if (width >= 700) {
                crossAxisCount = 2;
              } else {
                crossAxisCount = 1;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: employees.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 330,
                ),
                itemBuilder: (context, index) {
                  final employee = employees[index];

                  return EmployeeCardWidget(
                    employee: employee,
                    onView: () {
                      _showEmployeeDetails(employee);
                    },
                    onEdit: () {
                      _showEditEmployeeDialog(employee);
                    },
                    onDelete: () {
                      _showDeleteDialog(employee);
                    },
                  );
                },
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildEmptyState({String message = 'No employees found'}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isSearching = _searchController.text.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 55),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(shape: BoxShape.circle, color: colorScheme.primaryContainer),
            child: Icon(
              isSearching ? Icons.search_off_rounded : Icons.people_outline_rounded,
              size: 46,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            message,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            isSearching ? 'Try changing your search or filter.' : 'Add your first employee to get started.',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),

          if (!isSearching) ...[
            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: _showAddEmployeeDialog,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Add Employee'),
            ),
          ],
        ],
      ),
    );
  }
  // Widget _buildEmptyState({String message = 'No employees found'}) {
  //   return SizedBox(
  //     height: 300,
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.people_outline, size: 64, color: Colors.grey.shade500),
  //           const SizedBox(height: 16),
  //           Text(
  //             message,
  //             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: 8),
  //           const Text('Try changing your search or filter.'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildThemeButton(BuildContext context) {
    final isDark = AppThemeController.themeMode.value == ThemeMode.dark;

    return IconButton.filledTonal(
      tooltip: isDark ? 'Light mode' : 'Dark mode',
      onPressed: () async {
        await AppThemeController.toggle();
      },
      icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return IconButton(
      tooltip: 'Logout',
      style: IconButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
      onPressed: () {
        if (context.mounted) {
          try {
            context.read<AuthBloc>().add(LogoutRequested());
          } catch (_) {}
        }
      },
      icon: const Icon(Icons.logout_rounded),
    );
  }
}
