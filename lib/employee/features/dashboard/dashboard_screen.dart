import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class EmployeeDashboardScreen extends StatelessWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Madju Djaja',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: AppColors.primarySurface,
              radius: 18,
              child: Text(
                'RP',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Points Hero Card ─────────────────────────────────────
            _PointsHeroCard(),
            const SizedBox(height: 24),

            // ─── Quick Actions ────────────────────────────────────────
            Text(
              'Aksi Cepat',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _QuickActionsGrid(),
            const SizedBox(height: 24),

            // ─── Today Status ─────────────────────────────────────────
            Text(
              'Status Hari Ini',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _TodayStatusCard(),
            const SizedBox(height: 24),

            // ─── Recent Activity ──────────────────────────────────────
            Text(
              'Aktivitas Terbaru',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _RecentActivityList(),
          ],
        ),
      ),
      bottomNavigationBar: _EmployeeBottomNav(),
    );
  }
}

// ─── Points Hero Card ─────────────────────────────────────────────────────
class _PointsHeroCard extends StatefulWidget {
  @override
  State<_PointsHeroCard> createState() => _PointsHeroCardState();
}

class _PointsHeroCardState extends State<_PointsHeroCard> with SingleTickerProviderStateMixin {
  int _currentPoints = 850;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _cyclePointsSimulation() {
    setState(() {
      if (_currentPoints == 850) {
        _currentPoints = 75; // SP1
      } else if (_currentPoints == 75) {
        _currentPoints = 55; // SP2
      } else if (_currentPoints == 55) {
        _currentPoints = 35; // SP3 / Critical
      } else {
        _currentPoints = 850; // Reset to healthy
      }
    });
  }

  // Get gradient and status based on points
  List<Color> get _gradientColors {
    if (_currentPoints >= 80) {
      return [const Color(0xFF2C1810), const Color(0xFF4A2C1E)]; // Espresso & Warm Dark
    } else if (_currentPoints >= 60) {
      return [const Color(0xFF9E7A28), const Color(0xFFC9A84C)]; // Amber Gold
    } else if (_currentPoints >= 40) {
      return [const Color(0xFFB04040), const Color(0xFF802020)]; // Deep Red
    } else {
      return [const Color(0xFF1A0F09), const Color(0xFFB04040)]; // Dark Charcoal & Blood Red
    }
  }

  Color get _statusColor {
    if (_currentPoints >= 80) return const Color(0xFF5CB85C); // Green
    if (_currentPoints >= 60) return const Color(0xFFF0AD4E); // Amber Warning
    if (_currentPoints >= 40) return const Color(0xFFD9534F); // Danger Red
    return const Color(0xFFD9534F); // Pulsing Critical
  }

  String get _statusLabel {
    if (_currentPoints >= 80) return 'Aman';
    if (_currentPoints >= 60) return 'Peringatan: Rawan SP1';
    if (_currentPoints >= 40) return 'Bahaya: Rawan SP2!';
    return 'Kritis: Rekomendasi SP3 / PHK!';
  }

  String get _thresholdNotice {
    if (_currentPoints >= 80) return 'Ambang SP1: < 80 pts';
    if (_currentPoints >= 60) return 'Ambang SP2: < 60 pts';
    if (_currentPoints >= 40) return 'Ambang SP3: < 40 pts';
    return 'Batas Kritis Tersentuh!';
  }

  @override
  Widget build(BuildContext context) {
    final isCritical = _currentPoints < 40;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _gradientColors,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isCritical
                    ? Colors.red.withOpacity(0.3 + (_pulseController.value * 0.2))
                    : AppColors.primary.withOpacity(0.3),
                blurRadius: isCritical ? 20 + (_pulseController.value * 10) : 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Poin Anda',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$_currentPoints',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 56,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 6),
                            child: Text(
                              'pts',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Simulation Button
                  Tooltip(
                    message: 'Tap untuk simulasi threshold SP',
                    child: InkWell(
                      onTap: _cyclePointsSimulation,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.insights_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status: $_statusLabel',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: _statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _thresholdNotice,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.65),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _currentPoints / 1000,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      '💡 Tap tombol grafik di atas untuk simulasi turun naik poin & threshold SP',
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        color: Colors.white.withOpacity(0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Quick Actions ─────────────────────────────────────────────────────────
class _QuickActionsGrid extends StatelessWidget {
  final _actions = const [
    _ActionItem(
      icon: Icons.fingerprint,
      label: 'Absensi',
      route: '/employee/attendance',
      color: Color(0xFF2C1810),
    ),
    _ActionItem(
      icon: Icons.task_alt,
      label: 'Tugas',
      route: '/employee/tasks',
      color: Color(0xFF4A2C1E),
    ),
    _ActionItem(
      icon: Icons.receipt_long_outlined,
      label: 'Riwayat Poin',
      route: '/employee/ledger',
      color: Color(0xFF3D2010),
    ),
    _ActionItem(
      icon: Icons.person_outline,
      label: 'Profil',
      route: '/employee/profile',
      color: Color(0xFF5C3D28),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: _actions.length,
      itemBuilder: (ctx, i) => _ActionCard(action: _actions[i]),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label, route;
  final Color color;
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
  });
}

class _ActionCard extends StatelessWidget {
  final _ActionItem action;
  const _ActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(action.route),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: action.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(action.icon, color: AppColors.secondary, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Today Status Card ─────────────────────────────────────────────────────
class _TodayStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const _StatusDot(color: AppColors.success, label: 'Check-in\n08:05'),
          _StatusDivider(),
          const _StatusDot(color: AppColors.textMuted, label: 'Check-out\n–'),
          _StatusDivider(),
          const _StatusDot(
              color: AppColors.secondary, label: 'Tugas\n2 Pending'),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final Color color;
  final String label;
  const _StatusDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 40, height: 1, color: AppColors.border);
  }
}

// ─── Recent Activity ───────────────────────────────────────────────────────
class _RecentActivityList extends StatelessWidget {
  final _items = const [
    _ActivityItem(
      icon: Icons.login,
      title: 'Check-in berhasil',
      subtitle: 'Hari ini · 08:05',
      points: '+5',
      isPositive: true,
    ),
    _ActivityItem(
      icon: Icons.task_alt,
      title: 'Tugas disetujui',
      subtitle: 'Kemarin · Bersih-bersih area',
      points: '+10',
      isPositive: true,
    ),
    _ActivityItem(
      icon: Icons.warning_amber_outlined,
      title: 'Keterlambatan',
      subtitle: '20 Mei · 09:10',
      points: '-5',
      isPositive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: _items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _ActivityTile(item: item),
              if (i < _items.length - 1)
                const Divider(height: 1, color: AppColors.divider),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ActivityItem {
  final IconData icon;
  final String title, subtitle, points;
  final bool isPositive;
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.isPositive,
  });
}

class _ActivityTile extends StatelessWidget {
  final _ActivityItem item;
  const _ActivityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: item.isPositive
              ? AppColors.successSurface
              : AppColors.errorSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          item.icon,
          size: 18,
          color: item.isPositive ? AppColors.success : AppColors.error,
        ),
      ),
      title: Text(item.title, style: Theme.of(context).textTheme.titleMedium),
      subtitle:
          Text(item.subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: Text(
        item.points,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: item.isPositive ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }
}

// ─── Bottom Nav ─────────────────────────────────────────────────────────────
class _EmployeeBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      selectedLabelStyle: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11),
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fingerprint),
          label: 'Absensi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_outlined),
          activeIcon: Icon(Icons.task),
          label: 'Tugas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Poin',
        ),
      ],
      onTap: (i) {
        final routes = [
          '/employee/dashboard',
          '/employee/attendance',
          '/employee/tasks',
          '/employee/ledger',
        ];
        if (i != 0) context.go(routes[i]);
      },
    );
  }
}
