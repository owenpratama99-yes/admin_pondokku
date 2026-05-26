import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class WasteTrackingScreen extends StatefulWidget {
  const WasteTrackingScreen({super.key});

  @override
  State<WasteTrackingScreen> createState() => _WasteTrackingScreenState();
}

class _WasteTrackingScreenState extends State<WasteTrackingScreen> {
  String _selectedBranch = 'ALL';
  String _selectedPeriod = 'Minggu Ini';

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Waste Tracking',
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildWasteList()),
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
            child: _buildStatCard('Total Waste', '45 kg', Icons.delete, AppColors.error),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('Nilai Kerugian', 'Rp 2.5M', Icons.money_off, AppColors.warning),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('Items', '12', Icons.inventory_2, AppColors.info),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Record waste')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Record Waste'),
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
              value: _selectedBranch,
              decoration: const InputDecoration(labelText: 'Cabang'),
              items: ['ALL', 'Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas']
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedBranch = v!),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPeriod,
              decoration: const InputDecoration(labelText: 'Periode'),
              items: ['Hari Ini', 'Minggu Ini', 'Bulan Ini']
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedPeriod = v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWasteList() {
    final wastes = _getMockWastes();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: wastes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildWasteCard(wastes[index]);
      },
    );
  }

  Widget _buildWasteCard(Map<String, dynamic> waste) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.errorSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.delete, color: AppColors.error, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  waste['item'],
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${waste['branch']} • ${waste['date']}',
                  style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getReasonColor(waste['reason']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    waste['reason'],
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: _getReasonColor(waste['reason']),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${waste['qty']} ${waste['unit']}',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
              Text(
                waste['cost'],
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getReasonColor(String reason) {
    switch (reason.toLowerCase()) {
      case 'expired':
        return AppColors.error;
      case 'damaged':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  List<Map<String, dynamic>> _getMockWastes() {
    return [
      {
        'item': 'Kopi Arabica',
        'branch': 'Dago',
        'date': '25 Mei 2026',
        'qty': 2,
        'unit': 'kg',
        'reason': 'Expired',
        'cost': 'Rp 400K',
      },
      {
        'item': 'Susu Full Cream',
        'branch': 'Dipatiukur',
        'date': '24 Mei 2026',
        'qty': 5,
        'unit': 'liter',
        'reason': 'Damaged',
        'cost': 'Rp 125K',
      },
      {
        'item': 'Gula Pasir',
        'branch': 'Pasteur',
        'date': '23 Mei 2026',
        'qty': 1,
        'unit': 'kg',
        'reason': 'Spilled',
        'cost': 'Rp 25K',
      },
    ];
  }
}
