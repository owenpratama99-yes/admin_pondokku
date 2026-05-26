import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Export Data',
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildExportSection(
            context,
            'Master Data',
            'Export data master sistem',
            [
              _ExportItem('Employees', 'Semua data karyawan', Icons.people),
              _ExportItem('Branches', 'Semua data cabang', Icons.store),
              _ExportItem('Inventory', 'Data inventory', Icons.inventory_2),
            ],
          ),
          const SizedBox(height: 24),
          _buildExportSection(
            context,
            'Transactional Data',
            'Export data transaksi',
            [
              _ExportItem('Attendance', 'Data kehadiran', Icons.calendar_today),
              _ExportItem('Points', 'Riwayat poin', Icons.stars),
              _ExportItem('SP Records', 'Riwayat SP', Icons.description),
              _ExportItem('Shifts', 'Data shift', Icons.access_time),
            ],
          ),
          const SizedBox(height: 24),
          _buildExportSection(
            context,
            'Analytics Data',
            'Export data analytics',
            [
              _ExportItem('Performance', 'Data performa', Icons.bar_chart),
              _ExportItem('Sales', 'Data penjualan', Icons.shopping_cart),
              _ExportItem('Waste', 'Data waste', Icons.delete),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection(
    BuildContext context,
    String title,
    String subtitle,
    List<_ExportItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: items.map((item) => _buildExportTile(context, item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExportTile(BuildContext context, _ExportItem item) {
    return ListTile(
      leading: Icon(item.icon, color: AppColors.primary),
      title: Text(item.title),
      subtitle: Text(item.subtitle),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.download),
        onSelected: (format) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Exporting ${item.title} as $format')),
          );
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'CSV', child: Text('Export as CSV')),
          const PopupMenuItem(value: 'Excel', child: Text('Export as Excel')),
          const PopupMenuItem(value: 'PDF', child: Text('Export as PDF')),
        ],
      ),
    );
  }
}

class _ExportItem {
  final String title;
  final String subtitle;
  final IconData icon;

  _ExportItem(this.title, this.subtitle, this.icon);
}
