import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/branch_model.dart';
import '../../widgets/manager_scaffold.dart';

class BranchDetailScreen extends StatelessWidget {
  final String branchId;

  const BranchDetailScreen({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch from API
    final branch = _getMockBranch();

    return ManagerScaffold(
      title: branch.name,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, branch),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildInfoSection(context, branch),
                          const SizedBox(height: 20),
                          _buildLocationSection(context, branch),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          _buildStatsSection(context, branch),
                          const SizedBox(height: 20),
                          _buildOperatingHours(context, branch),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Branch branch) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.store, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.name,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  branch.id,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: Navigate to edit
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit branch')),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: () => _showDeleteDialog(context, branch),
                icon: const Icon(Icons.delete, color: Colors.white),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Branch branch) {
    return _buildSection(
      context,
      title: 'Informasi Cabang',
      child: Column(
        children: [
          _buildInfoRow(Icons.location_on, 'Alamat', branch.address),
          _buildInfoRow(Icons.phone, 'Telepon', branch.phoneNumber ?? '-'),
          _buildInfoRow(Icons.person, 'Manager', branch.managerName ?? 'Belum ada'),
          _buildInfoRow(Icons.people, 'Jumlah Karyawan', '${branch.employeeCount} orang'),
          _buildInfoRow(
            Icons.circle,
            'Status',
            branch.isActive ? 'Aktif' : 'Nonaktif',
            valueColor: branch.isActive ? AppColors.success : AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, Branch branch) {
    return _buildSection(
      context,
      title: 'Lokasi & Geofencing',
      child: Column(
        children: [
          _buildInfoRow(Icons.gps_fixed, 'Latitude', branch.latitude.toString()),
          _buildInfoRow(Icons.gps_fixed, 'Longitude', branch.longitude.toString()),
          _buildInfoRow(Icons.radio_button_checked, 'Radius', '${branch.radiusMeters} meter'),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, size: 48, color: AppColors.textMuted),
                  const SizedBox(height: 8),
                  Text(
                    'Map Preview',
                    style: GoogleFonts.outfit(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TODO: Integrate Google Maps',
                    style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, Branch branch) {
    return _buildSection(
      context,
      title: 'Statistik',
      child: Column(
        children: [
          _buildStatCard('Total Karyawan', '${branch.employeeCount}', Icons.people, AppColors.primary),
          const SizedBox(height: 12),
          _buildStatCard('Hadir Hari Ini', '${branch.employeeCount - 2}', Icons.check_circle, AppColors.success),
          const SizedBox(height: 12),
          _buildStatCard('Tugas Pending', '5', Icons.pending_actions, AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatingHours(BuildContext context, Branch branch) {
    if (branch.operatingHours == null) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      context,
      title: 'Jam Operasional',
      child: Column(
        children: branch.operatingHours!.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    _getDayName(entry.key),
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  entry.value,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
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

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Branch branch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Cabang?'),
        content: Text('Apakah Anda yakin ingin menghapus cabang ${branch.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: API call to delete
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cabang berhasil dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String _getDayName(String key) {
    final days = {
      'monday': 'Senin',
      'tuesday': 'Selasa',
      'wednesday': 'Rabu',
      'thursday': 'Kamis',
      'friday': 'Jumat',
      'saturday': 'Sabtu',
      'sunday': 'Minggu',
    };
    return days[key] ?? key;
  }

  Branch _getMockBranch() {
    return Branch(
      id: 'BR001',
      name: 'Dago',
      address: 'Jl. Ir. H. Djuanda No. 123, Dago, Bandung',
      latitude: -6.8700,
      longitude: 107.6100,
      radiusMeters: 50,
      managerId: 'MGR001',
      managerName: 'Budi Santoso',
      employeeCount: 18,
      status: 'ACTIVE',
      phoneNumber: '022-1234567',
      operatingHours: {
        'monday': '08:00-22:00',
        'tuesday': '08:00-22:00',
        'wednesday': '08:00-22:00',
        'thursday': '08:00-22:00',
        'friday': '08:00-23:00',
        'saturday': '08:00-23:00',
        'sunday': '09:00-22:00',
      },
    );
  }
}
