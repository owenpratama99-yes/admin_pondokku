import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/announcement_model.dart';
import '../../widgets/manager_scaffold.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final String announcementId;

  const AnnouncementDetailScreen({super.key, required this.announcementId});

  @override
  Widget build(BuildContext context) {
    final announcement = _getMockAnnouncement();

    return ManagerScaffold(
      title: 'Detail Pengumuman',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(announcement),
                const SizedBox(height: 24),
                _buildContent(announcement),
                const SizedBox(height: 24),
                _buildReadReceipts(announcement),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Announcement announcement) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (announcement.isPinned)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.push_pin, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    'PINNED',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          Text(
            announcement.title,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Text(
                  announcement.createdByName.substring(0, 1),
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.createdByName,
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _formatDate(announcement.createdAt),
                    style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Announcement announcement) {
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
            'Isi Pengumuman',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            announcement.content,
            style: GoogleFonts.outfit(fontSize: 15, height: 1.8),
          ),
        ],
      ),
    );
  }

  Widget _buildReadReceipts(Announcement announcement) {
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
            'Read Receipts',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${announcement.readBy.length} karyawan sudah membaca',
            style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          ...announcement.readBy.map((empId) => ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.successSurface,
              child: const Icon(Icons.check, color: AppColors.success, size: 16),
            ),
            title: Text('Employee $empId'),
            subtitle: const Text('Read 2 hours ago'),
          )),
          if (announcement.readBy.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(Icons.visibility_off, size: 48, color: AppColors.textMuted),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada yang membaca',
                      style: GoogleFonts.outfit(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Announcement _getMockAnnouncement() {
    return Announcement(
      id: announcementId,
      title: 'Update Kebijakan Shift',
      content: 'Mulai bulan depan, akan ada perubahan kebijakan shift. Shift malam akan mendapat bonus tambahan 20%. Harap semua karyawan membaca kebijakan lengkap di portal.\n\nPerubahan ini berlaku untuk semua cabang dan akan mulai efektif tanggal 1 Juni 2026. Untuk informasi lebih lanjut, silakan hubungi manager masing-masing cabang.',
      createdBy: 'MGR001',
      createdByName: 'Manager Dago',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isPinned: true,
      readBy: ['EMP001', 'EMP002', 'EMP003'],
    );
  }
}
