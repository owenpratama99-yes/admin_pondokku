import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/achievement_model.dart';
import '../../widgets/manager_scaffold.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Achievements & Badges',
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildAchievementsList()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                  'Achievements',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage badges & achievements untuk gamification',
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create achievement')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Buat Achievement'),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList() {
    final achievements = _getMockAchievements();

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return _buildAchievementCard(achievements[index]);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
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
              color: AppColors.secondarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getBadgeIcon(achievement.badgeIcon),
              color: AppColors.secondary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            achievement.title,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            achievement.description,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.infoSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${achievement.requiredPoints} pts',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getBadgeIcon(String icon) {
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

  List<Achievement> _getMockAchievements() {
    return [
      Achievement(
        id: 'ACH001',
        title: 'Perfect Attendance',
        description: 'Hadir tepat waktu 30 hari berturut-turut',
        badgeIcon: 'star',
        requiredPoints: 100,
        category: 'attendance',
      ),
      Achievement(
        id: 'ACH002',
        title: 'Sales Champion',
        description: 'Mencapai target sales 3 bulan berturut-turut',
        badgeIcon: 'trophy',
        requiredPoints: 150,
        category: 'sales',
      ),
      Achievement(
        id: 'ACH003',
        title: 'Customer Favorite',
        description: 'Rating 5.0 dari 50+ customer',
        badgeIcon: 'heart',
        requiredPoints: 120,
        category: 'service',
      ),
      Achievement(
        id: 'ACH004',
        title: 'Speed Demon',
        description: 'Selesaikan 100 transaksi dalam 1 shift',
        badgeIcon: 'fire',
        requiredPoints: 80,
        category: 'performance',
      ),
      Achievement(
        id: 'ACH005',
        title: 'Team Player',
        description: 'Bantu 10 rekan kerja dalam 1 bulan',
        badgeIcon: 'star',
        requiredPoints: 90,
        category: 'teamwork',
      ),
      Achievement(
        id: 'ACH006',
        title: 'Zero Waste',
        description: 'Tidak ada waste selama 1 bulan',
        badgeIcon: 'trophy',
        requiredPoints: 110,
        category: 'efficiency',
      ),
    ];
  }
}
