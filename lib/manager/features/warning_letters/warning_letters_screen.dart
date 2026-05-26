import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class WarningLettersScreen extends StatefulWidget {
  const WarningLettersScreen({super.key});

  @override
  State<WarningLettersScreen> createState() => _WarningLettersScreenState();
}

class _WarningLettersScreenState extends State<WarningLettersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock data
  final _atRiskEmployees = [
    _AtRiskEmployee(
      id: 'EMP001',
      name: 'Ahmad Fauzi',
      branch: 'Dago',
      currentPoints: -120,
      spCount: 0,
      photoUrl: null,
    ),
    _AtRiskEmployee(
      id: 'EMP015',
      name: 'Siti Nurhaliza',
      branch: 'Dipatiukur',
      currentPoints: -105,
      spCount: 1,
      photoUrl: null,
    ),
    _AtRiskEmployee(
      id: 'EMP032',
      name: 'Budi Santoso',
      branch: 'Pasteur',
      currentPoints: -150,
      spCount: 2,
      photoUrl: null,
    ),
  ];

  final _activeWarnings = [
    _WarningLetter(
      id: 'SP001',
      employeeId: 'EMP015',
      employeeName: 'Siti Nurhaliza',
      branch: 'Dipatiukur',
      level: 1,
      issuedDate: DateTime.now().subtract(const Duration(days: 15)),
      reason: 'Akumulasi poin minus mencapai -105',
      issuedBy: 'Manager Dipatiukur',
      status: 'ACTIVE',
    ),
    _WarningLetter(
      id: 'SP002',
      employeeId: 'EMP032',
      employeeName: 'Budi Santoso',
      branch: 'Pasteur',
      level: 2,
      issuedDate: DateTime.now().subtract(const Duration(days: 30)),
      reason: 'Akumulasi poin minus mencapai -150, SP kedua',
      issuedBy: 'Manager Pasteur',
      status: 'ACTIVE',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Surat Peringatan (SP)',
      body: Column(
        children: [
          // Stats Cards
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Karyawan Berisiko',
                    value: _atRiskEmployees.length.toString(),
                    subtitle: 'Poin < -100',
                    icon: Icons.warning_amber,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'SP Aktif',
                    value: _activeWarnings.length.toString(),
                    subtitle: 'Belum dicabut',
                    icon: Icons.description,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'SP Bulan Ini',
                    value: '3',
                    subtitle: 'Diterbitkan',
                    icon: Icons.calendar_today,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.secondary,
              tabs: const [
                Tab(text: 'Berisiko SP'),
                Tab(text: 'SP Aktif'),
                Tab(text: 'Riwayat'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAtRiskTab(),
                _buildActiveWarningsTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAtRiskTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_atRiskEmployees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text('Tidak Ada Karyawan Berisiko', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('Semua karyawan memiliki poin di atas threshold', style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _atRiskEmployees.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final employee = _atRiskEmployees[index];
        return _AtRiskEmployeeCard(
          employee: employee,
          onIssueSP: () => _showIssueSPDialog(employee),
        );
      },
    );
  }

  Widget _buildActiveWarningsTab() {
    if (_activeWarnings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.description_outlined, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text('Tidak Ada SP Aktif', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('Belum ada surat peringatan yang diterbitkan', style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _activeWarnings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final warning = _activeWarnings[index];
        return _WarningLetterCard(
          warning: warning,
          onView: () => _viewWarningDetail(warning),
          onRescind: () => _rescindWarning(warning),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return const Center(
      child: Text('Riwayat SP akan ditampilkan di sini'),
    );
  }

  void _showIssueSPDialog(_AtRiskEmployee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Terbitkan SP untuk ${employee.name}',
          style: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Karyawan: ${employee.name}'),
            Text('Cabang: ${employee.branch}'),
            Text('Poin Saat Ini: ${employee.currentPoints}'),
            Text('SP Saat Ini: ${employee.spCount}'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.warning),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'SP Level ${employee.spCount + 1} akan diterbitkan',
                      style: GoogleFonts.outfit(fontSize: 13),
                    ),
                  ),
                ],
              ),
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
              // TODO: Navigate to issue SP form
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigasi ke form SP')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    );
  }

  void _viewWarningDetail(_WarningLetter warning) {
    // TODO: Navigate to detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View detail SP: ${warning.id}')),
    );
  }

  void _rescindWarning(_WarningLetter warning) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cabut Surat Peringatan?'),
        content: Text(
          'Apakah Anda yakin ingin mencabut SP Level ${warning.level} untuk ${warning.employeeName}?',
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Ya, Cabut'),
          ),
        ],
      ),
    );
  }
}

// ─── Models ────────────────────────────────────────────────────────────

class _AtRiskEmployee {
  final String id;
  final String name;
  final String branch;
  final int currentPoints;
  final int spCount;
  final String? photoUrl;

  _AtRiskEmployee({
    required this.id,
    required this.name,
    required this.branch,
    required this.currentPoints,
    required this.spCount,
    this.photoUrl,
  });
}

class _WarningLetter {
  final String id;
  final String employeeId;
  final String employeeName;
  final String branch;
  final int level;
  final DateTime issuedDate;
  final String reason;
  final String issuedBy;
  final String status;

  _WarningLetter({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.branch,
    required this.level,
    required this.issuedDate,
    required this.reason,
    required this.issuedBy,
    required this.status,
  });
}

// ─── Widgets ───────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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
    );
  }
}

class _AtRiskEmployeeCard extends StatelessWidget {
  final _AtRiskEmployee employee;
  final VoidCallback onIssueSP;

  const _AtRiskEmployeeCard({
    required this.employee,
    required this.onIssueSP,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.errorSurface,
            child: Text(
              employee.name.substring(0, 2).toUpperCase(),
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${employee.branch} • ${employee.id}',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${employee.currentPoints} pts',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SP: ${employee.spCount}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onIssueSP,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.description, size: 18),
            label: const Text('Terbitkan SP'),
          ),
        ],
      ),
    );
  }
}

class _WarningLetterCard extends StatelessWidget {
  final _WarningLetter warning;
  final VoidCallback onView;
  final VoidCallback onRescind;

  const _WarningLetterCard({
    required this.warning,
    required this.onView,
    required this.onRescind,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'SP Level ${warning.level}',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                warning.id,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            warning.employeeName,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${warning.branch} • ${warning.employeeId}',
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            warning.reason,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                '${warning.issuedDate.day}/${warning.issuedDate.month}/${warning.issuedDate.year}',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.person, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                warning.issuedBy,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onView,
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('Lihat Detail'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onRescind,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  icon: const Icon(Icons.cancel, size: 18),
                  label: const Text('Cabut SP'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
