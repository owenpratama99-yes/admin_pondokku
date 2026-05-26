import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/warning_letter_model.dart';
import '../../widgets/manager_scaffold.dart';

class SPDetailScreen extends StatelessWidget {
  final String spId;

  const SPDetailScreen({super.key, required this.spId});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch SP data from API
    final sp = _getMockSP();

    return ManagerScaffold(
      title: 'Detail Surat Peringatan',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, sp),
                const SizedBox(height: 32),
                _buildEmployeeInfo(context, sp),
                const SizedBox(height: 32),
                _buildSPDetails(context, sp),
                const SizedBox(height: 32),
                _buildTimeline(context, sp),
                const SizedBox(height: 32),
                _buildActions(context, sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WarningLetter sp) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getSPColor(sp.level), _getSPColor(sp.level).withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.description, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SP Level ${sp.level}',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  sp.id,
                  style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          _buildStatusBadge(sp),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(WarningLetter sp) {
    final isActive = sp.isActive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.success : AppColors.textMuted,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'AKTIF' : 'DICABUT',
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmployeeInfo(BuildContext context, WarningLetter sp) {
    return _buildSection(
      context,
      title: 'Informasi Karyawan',
      child: Column(
        children: [
          _buildInfoRow('Nama', sp.employeeName),
          _buildInfoRow('ID Karyawan', sp.employeeId),
          _buildInfoRow('Cabang', sp.branchName),
        ],
      ),
    );
  }

  Widget _buildSPDetails(BuildContext context, WarningLetter sp) {
    return _buildSection(
      context,
      title: 'Detail Surat Peringatan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Kategori', sp.category),
          _buildInfoRow('Tanggal Terbit', _formatDate(sp.issuedDate)),
          _buildInfoRow('Diterbitkan Oleh', sp.issuedByName),
          const SizedBox(height: 16),
          Text(
            'Alasan:',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              sp.reason,
              style: GoogleFonts.outfit(fontSize: 14, height: 1.6),
            ),
          ),
          if (sp.notes != null) ...[
            const SizedBox(height: 16),
            Text(
              'Catatan Tambahan:',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.infoSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Text(
                sp.notes!,
                style: GoogleFonts.outfit(fontSize: 14, height: 1.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, WarningLetter sp) {
    return _buildSection(
      context,
      title: 'Timeline',
      child: Column(
        children: [
          _buildTimelineItem(
            'Diterbitkan',
            _formatDate(sp.issuedDate),
            sp.issuedByName,
            Icons.add_circle,
            AppColors.error,
          ),
          if (sp.rescindedDate != null)
            _buildTimelineItem(
              'Dicabut',
              _formatDate(sp.rescindedDate!),
              sp.rescindedBy ?? 'Unknown',
              Icons.cancel,
              AppColors.success,
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String date, String by, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  '$date • $by',
                  style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, WarningLetter sp) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Print/Export PDF
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export PDF coming soon')),
              );
            },
            icon: const Icon(Icons.print),
            label: const Text('Print SP'),
          ),
        ),
        if (sp.isActive) ...[
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showRescindDialog(context, sp),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              icon: const Icon(Icons.cancel),
              label: const Text('Cabut SP'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
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
        const SizedBox(height: 16),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showRescindDialog(BuildContext context, WarningLetter sp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cabut Surat Peringatan?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apakah Anda yakin ingin mencabut SP Level ${sp.level} untuk ${sp.employeeName}?'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Alasan Pencabutan',
                hintText: 'Jelaskan alasan pencabutan SP...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: API call to rescind
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('SP berhasil dicabut')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Ya, Cabut'),
          ),
        ],
      ),
    );
  }

  Color _getSPColor(int level) {
    switch (level) {
      case 1: return AppColors.warning;
      case 2: return const Color(0xFFFF6B00);
      case 3: return AppColors.error;
      default: return AppColors.error;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  WarningLetter _getMockSP() {
    return WarningLetter(
      id: 'SP001',
      employeeId: 'EMP015',
      employeeName: 'Siti Nurhaliza',
      branchId: 'BR002',
      branchName: 'Dipatiukur',
      level: 1,
      issuedDate: DateTime.now().subtract(const Duration(days: 15)),
      reason: 'Akumulasi poin minus mencapai -105 poin. Karyawan sering terlambat dan beberapa kali tidak hadir tanpa keterangan yang jelas.',
      category: 'Akumulasi Poin Minus',
      notes: 'Karyawan telah diberikan peringatan lisan sebelumnya.',
      issuedBy: 'MGR002',
      issuedByName: 'Manager Dipatiukur',
      status: 'ACTIVE',
    );
  }
}
