import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/employee_model.dart';
import '../../widgets/manager_scaffold.dart';

class EmployeePerformanceScreen extends StatelessWidget {
  final String employeeId;

  const EmployeePerformanceScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final employee = _getMockEmployee();

    return ManagerScaffold(
      title: 'Performa: ${employee.name}',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                _buildSummaryCards(employee),
                const SizedBox(height: 24),
                _buildPointsChart(),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildAttendanceSection()),
                    const SizedBox(width: 20),
                    Expanded(child: _buildTasksSection()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(Employee employee) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Poin Bulan Ini',
            employee.currentPoints.toString(),
            Icons.stars,
            _getPointsColor(employee.currentPoints),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Poin Tahunan',
            employee.yearlyPoints.toString(),
            Icons.trending_up,
            AppColors.info,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Kehadiran',
            '92%',
            Icons.check_circle,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Tugas Selesai',
            '90%',
            Icons.task_alt,
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPointsChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trend Poin 30 Hari Terakhir',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(30, (i) => FlSpot(i.toDouble(), -50 + (i * 2).toDouble())),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kehadiran Bulan Ini',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildAttendanceItem('Hadir Tepat Waktu', '20 hari', AppColors.success),
          _buildAttendanceItem('Terlambat', '2 hari', AppColors.warning),
          _buildAttendanceItem('Tidak Hadir', '0 hari', AppColors.error),
          _buildAttendanceItem('Izin/Sakit', '2 hari', AppColors.info),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(fontSize: 13),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tugas Bulan Ini',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTaskItem('Selesai', '45', AppColors.success),
          _buildTaskItem('Ditolak', '3', AppColors.error),
          _buildTaskItem('Pending', '2', AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(fontSize: 13),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPointsColor(int points) {
    if (points < -100) return AppColors.error;
    if (points < 0) return AppColors.warning;
    return AppColors.success;
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
