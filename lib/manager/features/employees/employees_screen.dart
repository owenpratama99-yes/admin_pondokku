import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/employee_model.dart';
import '../../widgets/manager_scaffold.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  bool _isLoading = false;
  List<Employee> _employees = [];
  String _searchQuery = '';
  String _filterBranch = 'ALL';
  String _filterRole = 'ALL';
  String _filterStatus = 'ACTIVE';

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _employees = _getMockEmployees();
      _isLoading = false;
    });
  }

  List<Employee> get _filteredEmployees {
    return _employees.where((emp) {
      final matchesSearch = emp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          emp.id.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesBranch = _filterBranch == 'ALL' || emp.branchName == _filterBranch;
      final matchesRole = _filterRole == 'ALL' || emp.role == _filterRole;
      final matchesStatus = _filterStatus == 'ALL' || emp.status == _filterStatus;
      return matchesSearch && matchesBranch && matchesRole && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Manajemen Karyawan',
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildEmployeeList(),
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
                  'Total ${_filteredEmployees.length} Karyawan',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_employees.where((e) => e.isActive).length} aktif • ${_employees.where((e) => e.isAtRisk).length} berisiko SP',
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to create employee')),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Tambah Karyawan'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.background,
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Cari nama atau ID karyawan...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterBranch,
                  decoration: const InputDecoration(labelText: 'Cabang'),
                  items: ['ALL', 'Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas']
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                  onChanged: (v) => setState(() => _filterBranch = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: ['ALL', 'BARISTA', 'MANAGER', 'OWNER']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => _filterRole = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['ALL', 'ACTIVE', 'INACTIVE']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _filterStatus = v!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList() {
    if (_filteredEmployees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text('Tidak ada karyawan', style: GoogleFonts.outfit(fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _filteredEmployees.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _EmployeeCard(
          employee: _filteredEmployees[index],
          onTap: () => _viewEmployeeDetail(_filteredEmployees[index]),
        );
      },
    );
  }

  void _viewEmployeeDetail(Employee employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View detail: ${employee.name}')),
    );
  }

  List<Employee> _getMockEmployees() {
    return List.generate(25, (i) => Employee(
      id: 'EMP${(i + 1).toString().padLeft(3, '0')}',
      name: 'Employee ${i + 1}',
      email: 'emp${i + 1}@madjudjadja.com',
      role: ['BARISTA', 'MANAGER'][i % 2],
      branchId: 'BR00${(i % 4) + 1}',
      branchName: ['Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas'][i % 4],
      currentPoints: -50 + (i * 10),
      yearlyPoints: i * 100,
      spCount: i % 5 == 0 ? 1 : 0,
      status: i % 10 == 0 ? 'INACTIVE' : 'ACTIVE',
      joinDate: DateTime.now().subtract(Duration(days: i * 30)),
      lastAttendance: DateTime.now().subtract(Duration(days: i % 3)),
    ));
  }
}

class _EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  const _EmployeeCard({required this.employee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: employee.isAtRisk ? AppColors.error.withOpacity(0.3) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: employee.isAtRisk ? AppColors.errorSurface : AppColors.primarySurface,
              child: Text(
                employee.initials,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: employee.isAtRisk ? AppColors.error : AppColors.primary,
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
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${employee.id} • ${employee.branchName}',
                    style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPointsColor(employee.currentPoints).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${employee.currentPoints} pts',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getPointsColor(employee.currentPoints),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.role,
                  style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Color _getPointsColor(int points) {
    if (points < -100) return AppColors.error;
    if (points < 0) return AppColors.warning;
    return AppColors.success;
  }
}
