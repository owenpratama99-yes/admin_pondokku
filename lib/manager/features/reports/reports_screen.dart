import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Reports & Analytics',
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2,
        children: [
          _buildReportCard(
            context,
            'Attendance Report',
            'Laporan kehadiran karyawan',
            Icons.calendar_today,
            AppColors.primary,
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Generate attendance report')),
            ),
          ),
          _buildReportCard(
            context,
            'Point History',
            'Riwayat poin karyawan',
            Icons.stars,
            AppColors.secondary,
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Generate point report')),
            ),
          ),
          _buildReportCard(
            context,
            'Performance Report',
            'Laporan performa bulanan',
            Icons.bar_chart,
            AppColors.info,
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Generate performance report')),
            ),
          ),
          _buildReportCard(
            context,
            'SP Report',
            'Laporan surat peringatan',
            Icons.description,
            AppColors.error,
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Generate SP report')),
            ),
          ),
          _buildReportCard(
            context,
            'Payroll Data',
            'Data untuk payroll',
            Icons.payments,
            AppColors.success,
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Generate payroll data')),
            ),
          ),
          _buildReportCard(
            context,
            'Custom Report',
            'Buat laporan custom',
            Icons.tune,
            AppColors.warning,
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Create custom report')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
