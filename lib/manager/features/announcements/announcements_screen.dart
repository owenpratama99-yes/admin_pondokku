import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/announcement_model.dart';
import '../../widgets/manager_scaffold.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Announcements',
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildAnnouncementsList()),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengumuman',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Broadcast pengumuman ke karyawan',
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create announcement')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Buat Pengumuman'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsList() {
    final announcements = _getMockAnnouncements();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: announcements.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildAnnouncementCard(announcements[index]);
      },
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: announcement.isPinned
              ? AppColors.secondary.withOpacity(0.5)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (announcement.isPinned)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.push_pin, size: 14, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        'PINNED',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Text(
                  announcement.title,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(announcement.isPinned ? 'Unpin' : 'Pin'),
                    onTap: () {},
                  ),
                  const PopupMenuItem(
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            announcement.content,
            style: GoogleFonts.outfit(fontSize: 14, height: 1.6),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primarySurface,
                child: Text(
                  announcement.createdByName.substring(0, 1),
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                announcement.createdByName,
                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Text(
                '• ${_formatDate(announcement.createdAt)}',
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.infoSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.visibility, size: 14, color: AppColors.info),
                    const SizedBox(width: 4),
                    Text(
                      '${announcement.readBy.length} read',
                      style: GoogleFonts.outfit(fontSize: 11, color: AppColors.info),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Announcement> _getMockAnnouncements() {
    return [
      Announcement(
        id: 'ANN001',
        title: 'Update Kebijakan Shift',
        content: 'Mulai bulan depan, akan ada perubahan kebijakan shift. Shift malam akan mendapat bonus tambahan 20%. Harap semua karyawan membaca kebijakan lengkap di portal.',
        createdBy: 'MGR001',
        createdByName: 'Manager Dago',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isPinned: true,
        readBy: ['EMP001', 'EMP002', 'EMP003'],
      ),
      Announcement(
        id: 'ANN002',
        title: 'Libur Nasional 17 Agustus',
        content: 'Semua cabang akan tutup pada tanggal 17 Agustus 2026 untuk memperingati Hari Kemerdekaan Indonesia. Operasional normal kembali tanggal 18 Agustus.',
        createdBy: 'OWNER001',
        createdByName: 'Owner',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isPinned: true,
        readBy: ['EMP001'],
      ),
      Announcement(
        id: 'ANN003',
        title: 'Training Barista Baru',
        content: 'Akan ada training untuk barista baru minggu depan. Semua barista dengan pengalaman kurang dari 3 bulan wajib hadir.',
        createdBy: 'MGR002',
        createdByName: 'Manager Dipatiukur',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        readBy: [],
      ),
    ];
  }
}
