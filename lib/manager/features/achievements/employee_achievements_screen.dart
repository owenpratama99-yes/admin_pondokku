import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class EmployeeAchievementsScreen extends StatefulWidget {
  final String employeeId;

  const EmployeeAchievementsScreen({super.key, required this.employeeId});

  @override
  State<EmployeeAchievementsScreen> createState() => _EmployeeAchievementsScreenState();
}

class _EmployeeAchievementsScreenState extends State<EmployeeAchievementsScreen> {
  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Employee Achievements',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildEmployeeHeader(),
            const SizedBox(height: 24),
            _buildAchievementsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.secondarySurface,
            child: Text(
              'RP',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rudi Pratama',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'EMP001 • Barista • Dago',
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '5',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                'Achievements',
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unlocked Achievements',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._getMockAchievements().map((achievement) => _buildAchievementCard(achievement)),
      ],
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(achievement['icon']),
              color: AppColors.secondary,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['title'],
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  achievement['description'],
                  style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlocked: ${achievement['date']}',
                  style: GoogleFonts.outfit(fontSize: 12, color: AppColors.info),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.successSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+${achievement['points']} pts',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'star':
        return Icons.star;
      case 'trophy':
        return Icons.emoji_events;
      case 'fire':
        return Icons.local_fire_department;
      case 'heart':
        return Icons.favorite;
      default:
        return Icons.emoji_events;
    }
  }

  List<Map<String, dynamic>> _getMockAchievements() {
    return [
      {
        'title': 'Perfect Attendance',
        'description': 'Hadir tepat waktu 30 hari berturut-turut',
        'icon': 'star',
        'points': 100,
        'date': '15 Mei 2026',
      },
      {
        'title': 'Sales Champion',
        'description': 'Mencapai target sales 3 bulan berturut-turut',
        'icon': 'trophy',
        'points': 150,
        'date': '10 Mei 2026',
      },
      {
        'title': 'Customer Favorite',
        'description': 'Rating 5.0 dari 50+ customer',
        'icon': 'heart',
        'points': 120,
        'date': '5 Mei 2026',
      },
      {
        'title': 'Speed Demon',
        'description': 'Selesaikan 100 transaksi dalam 1 shift',
        'icon': 'fire',
        'points': 80,
        'date': '1 Mei 2026',
      },
      {
        'title': 'Team Player',
        'description': 'Bantu 10 rekan kerja dalam 1 bulan',
        'icon': 'star',
        'points': 90,
        'date': '25 Apr 2026',
      },
    ];
  }
}
