import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants.dart';

class ManagerScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  const ManagerScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isWide
          ? null
          : AppBar(
              title: Text(title),
              backgroundColor: AppColors.sidebarBg,
              foregroundColor: Colors.white,
            ),
      drawer: isWide ? null : const _Sidebar(),
      body: Row(
        children: [
          if (isWide) const _Sidebar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isWide)
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border:
                          Border(bottom: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        // Role Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: CurrentSession.isOwner
                                ? const Color(0xFFFBF5E6) // Gold tint for Owner
                                : (CurrentSession.isReadOnly
                                    ? AppColors.infoSurface
                                    : AppColors.primarySurface),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: CurrentSession.isOwner
                                  ? AppColors.secondary
                                  : (CurrentSession.isReadOnly
                                      ? AppColors.info
                                      : AppColors.primary),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CurrentSession.isOwner
                                    ? Icons.workspace_premium
                                    : (CurrentSession.isReadOnly
                                        ? Icons.visibility
                                        : Icons.admin_panel_settings),
                                size: 14,
                                color: CurrentSession.isOwner
                                    ? AppColors.secondaryDark
                                    : (CurrentSession.isReadOnly
                                        ? AppColors.info
                                        : AppColors.primary),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                CurrentSession.isOwner
                                    ? 'OWNER (SUPERADMIN)'
                                    : (CurrentSession.isReadOnly
                                        ? 'INVESTOR (READ ONLY)'
                                        : 'MANAJEMEN'),
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: CurrentSession.isOwner
                                      ? AppColors.secondaryDark
                                      : (CurrentSession.isReadOnly
                                          ? AppColors.info
                                          : AppColors.primary),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const CircleAvatar(
                          backgroundColor: AppColors.primarySurface,
                          child: Icon(Icons.person, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Container(
      width: 260,
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Madju Djaja',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
          Text(
            'Portal Manajer',
            style: GoogleFonts.outfit(
              fontSize: 12,
              letterSpacing: 2,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _NavItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  route: '/manager/dashboard',
                  isActive: currentRoute == '/manager/dashboard',
                ),
                const Divider(height: 24, color: Colors.white12),
                _NavItem(
                  icon: Icons.people,
                  label: 'Pegawai',
                  route: '/manager/employees',
                  isActive: currentRoute.contains('/manager/employees'),
                ),
                _NavItem(
                  icon: Icons.store,
                  label: 'Cabang',
                  route: '/manager/branches',
                  isActive: currentRoute.contains('/manager/branches'),
                ),
                const Divider(height: 24, color: Colors.white12),
                _NavItem(
                  icon: Icons.assignment_turned_in,
                  label: 'Review Tugas',
                  route: '/manager/tasks',
                  isActive: currentRoute == '/manager/tasks',
                ),
                _NavItem(
                  icon: Icons.task_alt,
                  label: 'Template Tugas',
                  route: '/manager/task-templates',
                  isActive: currentRoute.contains('/manager/task-templates'),
                ),
                const Divider(height: 24, color: Colors.white12),
                _NavItem(
                  icon: Icons.people_alt,
                  label: 'Roster Absensi',
                  route: '/manager/roster',
                  isActive: currentRoute == '/manager/roster',
                ),
                _NavItem(
                  icon: Icons.schedule,
                  label: 'Shift',
                  route: '/manager/shifts',
                  isActive: currentRoute.contains('/manager/shifts'),
                ),
                const Divider(height: 24, color: Colors.white12),
                _NavItem(
                  icon: Icons.control_point_duplicate,
                  label: 'Kelola Poin',
                  route: '/manager/points',
                  isActive: currentRoute == '/manager/points',
                ),
                _NavItem(
                  icon: Icons.warning_amber,
                  label: 'Surat Peringatan',
                  route: '/manager/sp',
                  isActive: currentRoute.contains('/manager/sp'),
                ),
                const Divider(height: 24, color: Colors.white12),
                _NavItem(
                  icon: Icons.inventory_2,
                  label: 'Inventori',
                  route: '/manager/inventory',
                  isActive: currentRoute.contains('/manager/inventory'),
                ),
                _NavItem(
                  icon: Icons.point_of_sale,
                  label: 'Penjualan',
                  route: '/manager/sales',
                  isActive: currentRoute.contains('/manager/sales'),
                ),
                const Divider(height: 24, color: Colors.white12),
                _NavItem(
                  icon: Icons.assessment,
                  label: 'Laporan',
                  route: '/manager/reports',
                  isActive: currentRoute.contains('/manager/reports'),
                ),
                _NavItem(
                  icon: Icons.analytics,
                  label: 'Analytics',
                  route: '/manager/analytics',
                  isActive: currentRoute.contains('/manager/analytics'),
                ),
                const Divider(height: 24, color: Colors.white12),
                _NavItem(
                  icon: Icons.campaign,
                  label: 'Pengumuman',
                  route: '/manager/announcements',
                  isActive: currentRoute.contains('/manager/announcements'),
                ),
                _NavItem(
                  icon: Icons.emoji_events,
                  label: 'Pencapaian',
                  route: '/manager/achievements',
                  isActive: currentRoute.contains('/manager/achievements'),
                ),
                _NavItem(
                  icon: Icons.chat,
                  label: 'Chat',
                  route: '/manager/chat',
                  isActive: currentRoute.contains('/manager/chat'),
                ),
                _NavItem(
                  icon: Icons.feedback,
                  label: 'Feedback',
                  route: '/manager/feedback',
                  isActive: currentRoute.contains('/manager/feedback'),
                ),
                const Divider(height: 24, color: Colors.white12),
                _NavItem(
                  icon: Icons.settings,
                  label: 'Pengaturan',
                  route: '/manager/settings',
                  isActive: currentRoute.contains('/manager/settings'),
                ),
              ],
            ),
          ),
          const _NavItem(
            icon: Icons.logout,
            label: 'Keluar',
            route: '/manager/login',
            isActive: false,
            isLogout: true,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label, route;
  final bool isActive, isLogout;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLogout
        ? AppColors.error
        : (isActive ? AppColors.secondary : AppColors.sidebarText);

    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: color,
        ),
      ),
      selected: isActive,
      selectedTileColor: AppColors.sidebarHover,
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      onTap: () {
        if (isLogout) {
          context.go(route);
        } else if (!isActive) {
          context.go(route); // Use replacement to avoid stack buildup
        }
      },
    );
  }
}
