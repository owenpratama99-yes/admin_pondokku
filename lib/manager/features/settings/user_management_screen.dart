import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'User Management',
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Users',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage user accounts and permissions',
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add new user')),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    final users = _getMockUsers();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildUserCard(users[index]);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: _getRoleColor(user['role']).withOpacity(0.2),
            child: Text(
              user['name'].toString().substring(0, 2).toUpperCase(),
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: _getRoleColor(user['role']),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  user['email'],
                  style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user['role']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user['role'],
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getRoleColor(user['role']),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (user['isActive'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.successSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Active',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.errorSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Inactive',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) => PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'permissions', child: Text('Permissions')),
                const PopupMenuItem(value: 'reset', child: Text('Reset Password')),
                const PopupMenuItem(value: 'deactivate', child: Text('Deactivate')),
              ],
              onSelected: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$value: ${user['name']}')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'OWNER':
        return AppColors.secondary;
      case 'MANAGER':
        return AppColors.primary;
      case 'ADMIN':
        return AppColors.info;
      default:
        return AppColors.textMuted;
    }
  }

  List<Map<String, dynamic>> _getMockUsers() {
    return [
      {
        'name': 'Owner Madju Djaja',
        'email': 'owner@madjudjadja.com',
        'role': 'OWNER',
        'isActive': true,
      },
      {
        'name': 'Manager Dago',
        'email': 'manager.dago@madjudjadja.com',
        'role': 'MANAGER',
        'isActive': true,
      },
      {
        'name': 'Manager Dipatiukur',
        'email': 'manager.dipatiukur@madjudjadja.com',
        'role': 'MANAGER',
        'isActive': true,
      },
      {
        'name': 'Admin System',
        'email': 'admin@madjudjadja.com',
        'role': 'ADMIN',
        'isActive': true,
      },
      {
        'name': 'Manager Pasteur',
        'email': 'manager.pasteur@madjudjadja.com',
        'role': 'MANAGER',
        'isActive': false,
      },
    ];
  }
}
