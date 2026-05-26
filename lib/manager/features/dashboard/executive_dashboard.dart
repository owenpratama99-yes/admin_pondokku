import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants.dart';
import '../../widgets/manager_scaffold.dart';

class ExecutiveDashboard extends StatelessWidget {
  const ExecutiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Executive Dashboard',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── KPI Summary ──────────────────────────────────────────
            Text(
              'Ringkasan Hari Ini',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const _KpiGrid(),
            const SizedBox(height: 48),

            // ─── Chart & Branches ─────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kehadiran Mingguan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      const _AttendanceChart(),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status Cabang',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      const _BranchGrid(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // ─── Leaderboard & Red List ────────────────────────────────
            const _LeaderboardAndRedList(),
          ],
        ),
      ),
    );
  }
}

// ─── KPI Grid ─────────────────────────────────────────────────────────────
class _KpiGrid extends StatelessWidget {
  const _KpiGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _KpiCard(
            title: 'Total Hadir',
            value: '42/48',
            subtitle: 'Pegawai Hari Ini',
            icon: Icons.how_to_reg,
            color: AppColors.success,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _KpiCard(
            title: 'Tugas Menunggu',
            value: '18',
            subtitle: 'Perlu Validasi',
            icon: Icons.pending_actions,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _KpiCard(
            title: 'Pegawai Rawan SP',
            value: '3',
            subtitle: 'Saldo Poin < 50',
            icon: Icons.warning_amber_rounded,
            color: AppColors.error,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _KpiCard(
            title: 'Efisiensi Finansial',
            value: 'Rp 2.450.000',
            subtitle: 'Potongan Poin Disiplin',
            icon: Icons.account_balance_wallet_rounded,
            color: AppColors.secondaryDark,
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title, value, subtitle;
  final IconData icon;
  final Color color;
  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
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
        ],
      ),
    );
  }
}

// ─── Attendance Chart ─────────────────────────────────────────────────────
class _AttendanceChart extends StatelessWidget {
  const _AttendanceChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 50,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  const days = [
                    'Sen',
                    'Sel',
                    'Rab',
                    'Kam',
                    'Jum',
                    'Sab',
                    'Min'
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[val.toInt()],
                      style: GoogleFonts.outfit(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) => Text(
                  val.toInt().toString(),
                  style: GoogleFonts.outfit(
                      fontSize: 12, color: AppColors.textMuted),
                ),
                reservedSize: 28,
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (val) => const FlLine(
              color: AppColors.divider,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeGroup(0, 45, 3),
            _makeGroup(1, 46, 2),
            _makeGroup(2, 44, 4),
            _makeGroup(3, 48, 0),
            _makeGroup(4, 47, 1),
            _makeGroup(5, 42, 6),
            _makeGroup(6, 40, 8),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroup(int x, double present, double absent) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: present + absent,
          rodStackItems: [
            BarChartRodStackItem(0, present, AppColors.primary),
            BarChartRodStackItem(
                present, present + absent, AppColors.error.withOpacity(0.5)),
          ],
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

// ─── Branch Grid ──────────────────────────────────────────────────────────
class _BranchGrid extends StatelessWidget {
  const _BranchGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: AppConstants.branches.length,
      itemBuilder: (ctx, i) =>
          _BranchCard(name: AppConstants.branches[i], index: i),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final String name;
  final int index;
  const _BranchCard({required this.name, required this.index});

  @override
  Widget build(BuildContext context) {
    final staffCount = 10 + (index * 2);
    final present = staffCount - (index % 3);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.storefront, color: AppColors.secondary, size: 28),
          const Spacer(),
          Text(
            name,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: present / staffCount,
            backgroundColor: AppColors.surfaceVariant,
            color: AppColors.success,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 8),
          Text(
            '$present / $staffCount Hadir',
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Leaderboard & Red List Row ───────────────────────────────────────────
class _LeaderboardAndRedList extends StatelessWidget {
  const _LeaderboardAndRedList();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Leaderboard Podium (Flex 3)
        Expanded(
          flex: 3,
          child: Container(
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
                    const Icon(Icons.workspace_premium, color: AppColors.secondary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Global Leaderboard - Staf Teladan',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _PodiumVisual(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Right: Red List SP (Flex 2)
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.errorSurface.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.report_problem_rounded, color: AppColors.error, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Daftar Merah - Staf Rawan SP',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _RedListStack(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Podium Visual Widget ──────────────────────────────────────────────────
class _PodiumVisual extends StatelessWidget {
  const _PodiumVisual();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildPodiumColumn(
          rank: 2,
          name: 'Siti Rahma',
          score: '960 pts',
          branch: 'DU Cafe',
          height: 120,
          podiumColor: const Color(0xFFC0C0C0),
          avatarLetter: 'S',
        ),
        _buildPodiumColumn(
          rank: 1,
          name: 'Budi Santoso',
          score: '985 pts',
          branch: 'Dago Cafe',
          height: 160,
          podiumColor: AppColors.secondary,
          avatarLetter: 'B',
        ),
        _buildPodiumColumn(
          rank: 3,
          name: 'Farhan Hakim',
          score: '935 pts',
          branch: 'Pasteur Cafe',
          height: 100,
          podiumColor: const Color(0xFFCD7F32),
          avatarLetter: 'F',
        ),
      ],
    );
  }

  Widget _buildPodiumColumn({
    required int rank,
    required String name,
    required String score,
    required String branch,
    required double height,
    required Color podiumColor,
    required String avatarLetter,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CircleAvatar(
                radius: rank == 1 ? 32 : 26,
                backgroundColor: AppColors.primarySurface,
                child: Text(
                  avatarLetter,
                  style: GoogleFonts.outfit(
                    fontSize: rank == 1 ? 20 : 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 10,
              backgroundColor: podiumColor,
              child: Text(
                '$rank',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        Text(
          branch,
          style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMuted),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [podiumColor, podiumColor.withOpacity(0.5)],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: podiumColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              score,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Red List Stack Widget ─────────────────────────────────────────────────
class _RedListStack extends StatelessWidget {
  const _RedListStack();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lowPerformers = [
      {'name': 'Reza Fahmi', 'score': 35, 'status': 'Rawan SP3 (PHK)', 'branch': 'Pasteur'},
      {'name': 'Dewi Lestari', 'score': 48, 'status': 'Rawan SP2', 'branch': 'Dago'},
      {'name': 'Andi Wijaya', 'score': 55, 'status': 'Rawan SP1', 'branch': 'Pasteur'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lowPerformers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final emp = lowPerformers[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.error.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.errorSurface,
                child: Text(
                  '${emp['score']}',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emp['name'],
                      style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Row(
                      children: [
                        Text(
                          'Cabang ${emp['branch']} · ',
                          style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMuted),
                        ),
                        Text(
                          emp['status'],
                          style: GoogleFonts.outfit(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Peringatan SP berhasil dikirimkan secara otomatis ke ${emp['name']}!',
                        style: GoogleFonts.outfit(),
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: Text(
                  'Kirim SP',
                  style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
