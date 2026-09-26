import 'package:flutter/material.dart';

class EmployeeAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double radius;
  const EmployeeAvatar({super.key, required this.name, this.avatarUrl, required this.radius});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty ? NetworkImage(avatarUrl!) : null,
      child: avatarUrl == null || avatarUrl!.isEmpty
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: TextStyle(fontSize: radius * 0.7, fontWeight: FontWeight.bold),
            )
          : null,
    );
  }
}
