import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/widgets/employee_avatar.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/widgets/detail_row_widget.dart';
import 'package:flutter/material.dart';

class EmployeeDetailsBottomSheet extends StatelessWidget {
  final GetAllEmployeesAttributeModel employee;

  const EmployeeDetailsBottomSheet({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------
            // EMPLOYEE HEADER
            // ------------------------------------------------
            Row(
              children: [
                EmployeeAvatar(name: employee.name ?? '', avatarUrl: employee.avatar, radius: 28),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name ?? '',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 4),

                      Text('Employee ID: ${employee.id ?? ''}', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ------------------------------------------------
            // EMPLOYEE DETAILS
            // ------------------------------------------------
            DetailRowWidget(icon: Icons.email_outlined, label: 'Email', value: employee.emailId ?? ''),

            DetailRowWidget(icon: Icons.alternate_email, label: 'Alternate Email', value: employee.email ?? ''),

            DetailRowWidget(icon: Icons.phone_outlined, label: 'Mobile', value: employee.mobile ?? ''),

            DetailRowWidget(icon: Icons.public, label: 'Country', value: employee.country ?? ''),

            DetailRowWidget(icon: Icons.location_city_outlined, label: 'State', value: employee.state ?? ''),

            DetailRowWidget(icon: Icons.location_on_outlined, label: 'District', value: employee.district ?? ''),

            // ------------------------------------------------
            // CREATED AT
            // ------------------------------------------------
            if (employee.createdAt != null) ...[
              DetailRowWidget(icon: Icons.calendar_today_outlined, label: 'Created At', value: employee.createdAt!),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
