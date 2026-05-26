import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'System Settings',
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSection('General Settings', [
            _buildSettingItem(Icons.business, 'Company Profile', 'Manage company information', () {}),
            _buildSettingItem(Icons.language, 'Language & Region', 'English (US)', () {}),
            _buildSettingItem(Icons.access_time, 'Timezone', 'GMT+7 (Jakarta)', () {}),
          ]),
          const SizedBox(height: 24),
          _buildSection('Point System', [
            _buildSettingItem(Icons.stars, 'Point Rules', 'Configure point calculation', () {}),
            _buildSettingItem(Icons.calendar_today, 'Reset Schedule', 'Monthly: 1st, Yearly: Jan 1st', () {}),
            _buildSettingItem(Icons.trending_up, 'Point Multipliers', 'Set bonus multipliers', () {}),
          ]),
          const SizedBox(height: 24),
          _buildSection('Notifications', [
            _buildSettingItem(Icons.notifications, 'Push Notifications', 'Enabled', () {}),
            _buildSettingItem(Icons.email, 'Email Notifications', 'Enabled', () {}),
            _buildSettingItem(Icons.sms, 'SMS Notifications', 'Disabled', () {}),
          ]),
          const SizedBox(height: 24),
          _buildSection('Security', [
            _buildSettingItem(Icons.lock, 'Password Policy', 'Configure password requirements', () {}),
            _buildSettingItem(Icons.security, 'Two-Factor Auth', 'Recommended', () {}),
            _buildSettingItem(Icons.history, 'Session Timeout', '30 minutes', () {}),
          ]),
          const SizedBox(height: 24),
          _buildSection('Data & Privacy', [
            _buildSettingItem(Icons.backup, 'Backup & Restore', 'Last backup: 2 hours ago', () {}),
            _buildSettingItem(Icons.download, 'Export Data', 'Download all system data', () {}),
            _buildSettingItem(Icons.delete_forever, 'Data Retention', 'Keep data for 2 years', () {}),
          ]),
          const SizedBox(height: 24),
          _buildSection('Integrations', [
            _buildSettingItem(Icons.api, 'API Keys', 'Manage API access', () {}),
            _buildSettingItem(Icons.webhook, 'Webhooks', 'Configure webhooks', () {}),
            _buildSettingItem(Icons.extension, 'Third-party Apps', 'Connected: 3', () {}),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
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
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMuted),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
