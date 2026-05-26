import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class PointArchiveScreen extends StatefulWidget {
  const PointArchiveScreen({super.key});

  @override
  State<PointArchiveScreen> createState() => _PointArchiveScreenState();
}

class _PointArchiveScreenState extends State<PointArchiveScreen> {
  String _selectedYear = '2024';
  String _selectedMonth = 'ALL';

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Arsip Poin',
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildArchiveList()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedYear,
              decoration: const InputDecoration(
                labelText: 'Tahun',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              items: ['2024', '2023', '2022']
                  .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedYear = v!),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedMonth,
              decoration: const InputDecoration(
                labelText: 'Bulan',
                prefixIcon: Icon(Icons.event),
              ),
              items: [
                'ALL',
                'Januari',
                'Februari',
                'Maret',
                'April',
                'Mei',
                'Juni',
                'Juli',
                'Agustus',
                'September',
                'Oktober',
                'November',
                'Desember'
              ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (v) => setState(() => _selectedMonth = v!),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export to Excel')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildArchiveList() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildArchiveSection(
          'Desember 2024',
          'Reset dilakukan: 1 Januari 2025',
          [
            _ArchiveItem('Total Poin Diberikan', '+12,450', AppColors.success),
            _ArchiveItem('Total Poin Dikurangi', '-3,200', AppColors.error),
            _ArchiveItem('Net Poin', '+9,250', AppColors.info),
            _ArchiveItem('Karyawan Aktif', '70', AppColors.primary),
          ],
        ),
        const SizedBox(height: 20),
        _buildArchiveSection(
          'November 2024',
          'Reset dilakukan: 1 Desember 2024',
          [
            _ArchiveItem('Total Poin Diberikan', '+11,800', AppColors.success),
            _ArchiveItem('Total Poin Dikurangi', '-2,900', AppColors.error),
            _ArchiveItem('Net Poin', '+8,900', AppColors.info),
            _ArchiveItem('Karyawan Aktif', '68', AppColors.primary),
          ],
        ),
        const SizedBox(height: 20),
        _buildArchiveSection(
          'Oktober 2024',
          'Reset dilakukan: 1 November 2024',
          [
            _ArchiveItem('Total Poin Diberikan', '+13,200', AppColors.success),
            _ArchiveItem('Total Poin Dikurangi', '-3,500', AppColors.error),
            _ArchiveItem('Net Poin', '+9,700', AppColors.info),
            _ArchiveItem('Karyawan Aktif', '67', AppColors.primary),
          ],
        ),
      ],
    );
  }

  Widget _buildArchiveSection(String title, String subtitle, List<_ArchiveItem> items) {
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('View detail: $title')),
                  );
                },
                icon: const Icon(Icons.visibility),
                tooltip: 'Lihat Detail',
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: items.map((item) => _buildStatCard(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(_ArchiveItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: item.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ArchiveItem {
  final String label;
  final String value;
  final Color color;

  _ArchiveItem(this.label, this.value, this.color);
}
