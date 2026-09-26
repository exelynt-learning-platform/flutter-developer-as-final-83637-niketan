import 'package:employee_management/modules/employee_dashboard/domain/entity/get_all_employees_attribute_model.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/widgets/employee_avatar.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/widgets/info_item_widget.dart';
import 'package:flutter/material.dart';

class EmployeeCardWidget extends StatelessWidget {
  final GetAllEmployeesAttributeModel employee;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EmployeeCardWidget({
    super.key,
    required this.employee,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------
            // Header
            // ---------------------------------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2), width: 2),
                  ),
                  child: EmployeeAvatar(name: employee.name ?? '', avatarUrl: employee.avatar, radius: 28),
                ),

                const SizedBox(width: 10),

                // Employee name + ID
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.1),
                      ),

                      const SizedBox(height: 5),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ID: ${employee.id ?? '-'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 4),

                // More menu
                SizedBox(
                  width: 40,
                  height: 40,
                  child: PopupMenuButton<String>(
                    tooltip: 'More options',
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert_rounded),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      switch (value) {
                        case 'view':
                          onView();
                          break;

                        case 'edit':
                          onEdit();
                          break;

                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(children: [Icon(Icons.visibility_outlined, size: 20), SizedBox(width: 10), Text('View')]),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [Icon(Icons.edit_outlined, size: 20), SizedBox(width: 10), Text('Edit')]),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 20, color: colorScheme.error),
                            const SizedBox(width: 10),
                            Text('Delete', style: TextStyle(color: colorScheme.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ---------------------------------------------------------
            // Divider
            // ---------------------------------------------------------
            Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.5)),

            const SizedBox(height: 14),

            // ---------------------------------------------------------
            // Employee Information
            // ---------------------------------------------------------
            _InfoContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InfoItemWidget(icon: Icons.email_outlined, text: employee.email ?? ''),

                  const SizedBox(height: 10),

                  InfoItemWidget(icon: Icons.phone_outlined, text: employee.mobile ?? ''),

                  const SizedBox(height: 10),

                  InfoItemWidget(icon: Icons.location_on_outlined, text: '${employee.district ?? '-'}, ${employee.state ?? '-'}'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------------------------------------------------------
            // Actions
            // ---------------------------------------------------------
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: onView,
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('View Details', maxLines: 1, overflow: TextOverflow.ellipsis),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: OutlinedButton(
                    onPressed: onEdit,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Icon(Icons.edit_outlined, size: 20),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: OutlinedButton(
                    onPressed: onDelete,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      padding: EdgeInsets.zero,
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error.withValues(alpha: 0.35)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Icon(Icons.delete_outline, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// Employee Information Container
// ===================================================================

class _InfoContainer extends StatelessWidget {
  final Widget child;

  const _InfoContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: child,
    );
  }
}
