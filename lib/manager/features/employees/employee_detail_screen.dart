import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/employee_model.dart';
import '../../widgets/manager_scaffold.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final employee = _getMockEmployee();

    return ManagerScaffold(
      title: employee.name,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                _buildHeader(context, employee),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildInfoSection(employee),
                          const SizedBox(height: 20),
                          _buildPointsSection(employee),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          _buildStatsSection(employee),
                          const SizedBox(height: 20),
                          _buildQuickActions(context, employee),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Employee employee) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            employee.isAtRisk ? AppColors.error : AppColors.primary,
            employee.isAtRisk ? AppColors.error.withOpacity(0.7) : AppColors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              employee.initials,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${employee.id} • ${employee.role}',
                  style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit employee')),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('View performance')),
                  );
                },
                icon: const Icon(Icons.bar_chart, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Employee employee) {
    return _buildSection(
      'Informasi Karyawan',
      Column(
        children: [
          _buildInfoRow(Icons.email, 'Email', employee.email),
          _buildInfoRow(Icons.store, 'Cabang', employee.branchName),
          _buildInfoRow(Icons.badge, 'Role', employee.role),
          _buildInfoRow(
            Icons.circle,
            'Status',
            employee.isActive ? 'Aktif' : 'Nonaktif',
            valueColor: employee.isActive ? AppColors.success : AppColors.error,
          ),
          _buildInfoRow(Icons.calendar_today, 'Bergabung', _formatDate(employee.joinDate)),
          if (employee.lastAttendance != null)
            _buildInfoRow(Icons.access_time, 'Absen Terakhir', _formatDate(employee.lastAttendance!)),
        ],
      ),
    );
  }

  Widget _buildPointsSection(Employee employee) {
    return _buildSection(
      'Poin & Performa',
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildPointCard(
                  'Poin Bulan Ini',
                  employee.currentPoints.toString(),
                  _getPointsColor(employee.currentPoints),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPointCard(
                  'Poin Tahunan',
                  employee.yearlyPoints.toString(),
                  AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPointCard(
                  'Jumlah SP',
                  employee.spCount.toString(),
                  employee.spCount > 0 ? AppColors.error : AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPointCard(
                  'Status',
                  employee.isAtRisk ? 'Berisiko' : 'Aman',
                  employee.isAtRisk ? AppColors.error : AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Employee employee) {
    return _buildSection(
      'Statistik',
      Column(
        children: [
          _buildStatItem('Kehadiran Bulan Ini', '22/24 hari', Icons.check_circle, AppColors.success),
          const SizedBox(height: 12),
          _buildStatItem('Tugas Selesai', '45/50', Icons.task_alt, AppColors.primary),
          const SizedBox(height: 12),
          _buildStatItem('Keterlambatan', '3 kali', Icons.schedule, AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Employee employee) {
    return _buildSection(
      'Aksi Cepat',
      Column(
        children: [
          _buildActionButton(
            context,
            'Berikan Poin',
            Icons.add_circle,
            AppColors.success,
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Give points')),
            ),
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            context,
            'Potong Poin',
            Icons.remove_circle,
            AppColors.error,
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deduct points')),
            ),
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            context,
            'Terbitkan SP',
            Icons.description,
            AppColors.warning,
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Issue SP')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted)),
              Text(value, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPointsColor(int points) {
    if (points < -100) return AppColors.error;
    if (points < 0) return AppColors.warning;
    return AppColors.success;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Employee _getMockEmployee() {
    return Employee(
      id: employeeId,
      name: 'Rudi Pratama',
      email: 'rudi.pratama@madjudjadja.com',
      role: 'BARISTA',
      branchId: 'BR001',
      branchName: 'Dago',
      currentPoints: -85,
      yearlyPoints: 450,
      spCount: 0,
      status: 'ACTIVE',
      joinDate: DateTime(2024, 1, 15),
      lastAttendance: DateTime.now().subtract(const Duration(days: 1)),
    );
  }
}
