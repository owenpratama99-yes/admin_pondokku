import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  String _selectedAction = 'ALL';
  String _selectedUser = 'ALL';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Audit Log',
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildLogList()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedAction,
                  decoration: const InputDecoration(labelText: 'Action Type'),
                  items: ['ALL', 'CREATE', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT']
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedAction = v!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedUser,
                  decoration: const InputDecoration(labelText: 'User'),
                  items: ['ALL', 'Owner', 'Manager Dago', 'Manager Dipatiukur', 'Admin']
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedUser = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Start Date'),
                  subtitle: Text(_formatDate(_startDate)),
                  trailing: const Icon(Icons.calendar_today, size: 20),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _startDate = date);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ListTile(
                  title: const Text('End Date'),
                  subtitle: Text(_formatDate(_endDate)),
                  trailing: const Icon(Icons.calendar_today, size: 20),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: _startDate,
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _endDate = date);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export audit log')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Export'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogList() {
    final logs = _getMockLogs();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _buildLogItem(logs[index]);
      },
    );
  }

  Widget _buildLogItem(Map<String, dynamic> log) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getActionColor(log['action']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getActionIcon(log['action']),
              color: _getActionColor(log['action']),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['description'],
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      log['user'],
                      style: GoogleFonts.outfit(fontSize: 12, color: AppColors.primary),
                    ),
                    Text(
                      ' • ${log['timestamp']}',
                      style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getActionColor(log['action']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              log['action'],
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: _getActionColor(log['action']),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'CREATE':
        return AppColors.success;
      case 'UPDATE':
        return AppColors.info;
      case 'DELETE':
        return AppColors.error;
      case 'LOGIN':
        return AppColors.primary;
      case 'LOGOUT':
        return AppColors.textMuted;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action) {
      case 'CREATE':
        return Icons.add_circle;
      case 'UPDATE':
        return Icons.edit;
      case 'DELETE':
        return Icons.delete;
      case 'LOGIN':
        return Icons.login;
      case 'LOGOUT':
        return Icons.logout;
      default:
        return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Map<String, dynamic>> _getMockLogs() {
    return [
      {
        'action': 'CREATE',
        'description': 'Created new employee: Rudi Pratama',
        'user': 'Manager Dago',
        'timestamp': '2 hours ago',
      },
      {
        'action': 'UPDATE',
        'description': 'Updated branch settings: Dipatiukur',
        'user': 'Manager Dipatiukur',
        'timestamp': '3 hours ago',
      },
      {
        'action': 'DELETE',
        'description': 'Deleted SP record: SP-2024-001',
        'user': 'Admin System',
        'timestamp': '5 hours ago',
      },
      {
        'action': 'LOGIN',
        'description': 'User logged in',
        'user': 'Owner',
        'timestamp': '1 day ago',
      },
      {
        'action': 'UPDATE',
        'description': 'Updated point rules',
        'user': 'Owner',
        'timestamp': '1 day ago',
      },
      {
        'action': 'CREATE',
        'description': 'Created new achievement: Perfect Attendance',
        'user': 'Manager Dago',
        'timestamp': '2 days ago',
      },
    ];
  }
}
