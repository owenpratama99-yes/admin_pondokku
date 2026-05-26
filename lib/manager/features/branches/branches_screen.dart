import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/branch_model.dart';
import '../../widgets/manager_scaffold.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  bool _isLoading = false;
  List<Branch> _branches = [];

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    setState(() => _isLoading = true);
    // TODO: API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _branches = _getMockBranches();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Manajemen Cabang',
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildBranchGrid(),
          ),
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
                  'Total ${_branches.length} Cabang',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_branches.where((b) => b.isActive).length} aktif',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to create branch
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to create branch')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Cabang'),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2,
      ),
      itemCount: _branches.length,
      itemBuilder: (context, index) {
        return _BranchCard(
          branch: _branches[index],
          onTap: () => _viewBranchDetail(_branches[index]),
        );
      },
    );
  }

  void _viewBranchDetail(Branch branch) {
    // TODO: Navigate to detail
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View detail: ${branch.name}')),
    );
  }

  List<Branch> _getMockBranches() {
    return [
      Branch(
        id: 'BR001',
        name: 'Dago',
        address: 'Jl. Ir. H. Djuanda No. 123, Dago',
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
      ),
      Branch(
        id: 'BR002',
        name: 'Dipatiukur',
        address: 'Jl. Dipatiukur No. 45, Bandung',
        latitude: -6.8800,
        longitude: 107.6200,
        radiusMeters: 50,
        managerId: 'MGR002',
        managerName: 'Siti Rahayu',
        employeeCount: 15,
        status: 'ACTIVE',
        phoneNumber: '022-2345678',
      ),
      Branch(
        id: 'BR003',
        name: 'Pasteur',
        address: 'Jl. Dr. Djunjunan No. 78, Pasteur',
        latitude: -6.8900,
        longitude: 107.6300,
        radiusMeters: 50,
        managerId: 'MGR003',
        managerName: 'Ahmad Fauzi',
        employeeCount: 20,
        status: 'ACTIVE',
        phoneNumber: '022-3456789',
      ),
      Branch(
        id: 'BR004',
        name: 'Cihampelas',
        address: 'Jl. Cihampelas No. 90, Bandung',
        latitude: -6.9000,
        longitude: 107.6400,
        radiusMeters: 50,
        employeeCount: 17,
        status: 'ACTIVE',
        phoneNumber: '022-4567890',
      ),
    ];
  }
}

class _BranchCard extends StatelessWidget {
  final Branch branch;
  final VoidCallback onTap;

  const _BranchCard({required this.branch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: branch.isActive
                        ? AppColors.successSurface
                        : AppColors.errorSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    branch.isActive ? 'AKTIF' : 'NONAKTIF',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: branch.isActive
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              branch.name,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              branch.address,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(
                  '${branch.employeeCount} karyawan',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (branch.hasManager) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      branch.managerName ?? 'No manager',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
