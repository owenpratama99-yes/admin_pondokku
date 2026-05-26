import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class OvertimeScreen extends StatefulWidget {
  const OvertimeScreen({super.key});

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  String _selectedMonth = 'Mei 2026';
  String _selectedBranch = 'ALL';

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Overtime Tracking',
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildOvertimeList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildStatCard('Total Overtime', '245 jam', Icons.access_time, AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('Karyawan', '18', Icons.people, AppColors.info),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('Biaya', 'Rp 12.5M', Icons.payments, AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.background,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedMonth,
              decoration: const InputDecoration(labelText: 'Periode'),
              items: ['Mei 2026', 'April 2026', 'Maret 2026']
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedMonth = v!),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedBranch,
              decoration: const InputDecoration(labelText: 'Cabang'),
              items: ['ALL', 'Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas']
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedBranch = v!),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export overtime report')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildOvertimeList() {
    final overtimes = _getMockOvertimes();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: overtimes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildOvertimeCard(overtimes[index]);
      },
    );
  }

  Widget _buildOvertimeCard(Map<String, dynamic> overtime) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.secondarySurface,
            child: Text(
              overtime['name'].toString().substring(0, 2).toUpperCase(),
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overtime['name'],
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${overtime['branch']} • ${overtime['role']}',
                  style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondarySurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${overtime['hours']} jam',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                overtime['cost'],
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('View detail: ${overtime['name']}')),
              );
            },
            icon: const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockOvertimes() {
    return [
      {
        'name': 'Rudi Pratama',
        'branch': 'Dago',
        'role': 'BARISTA',
        'hours': 24,
        'cost': 'Rp 1.2M',
      },
      {
        'name': 'Siti Nurhaliza',
        'branch': 'Dipatiukur',
        'role': 'BARISTA',
        'hours': 18,
        'cost': 'Rp 900K',
      },
      {
        'name': 'Ahmad Fauzi',
        'branch': 'Pasteur',
        'role': 'BARISTA',
        'hours': 16,
        'cost': 'Rp 800K',
      },
      {
        'name': 'Budi Santoso',
        'branch': 'Dago',
        'role': 'BARISTA',
        'hours': 15,
        'cost': 'Rp 750K',
      },
      {
        'name': 'Dewi Lestari',
        'branch': 'Cihampelas',
        'role': 'BARISTA',
        'hours': 12,
        'cost': 'Rp 600K',
      },
    ];
  }
}
