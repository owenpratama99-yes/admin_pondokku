import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/employee_model.dart';
import '../../widgets/manager_scaffold.dart';

class EditEmployeeScreen extends StatefulWidget {
  final String employeeId;

  const EditEmployeeScreen({super.key, required this.employeeId});

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  
  bool _isLoading = false;
  bool _isActive = true;
  String? _selectedBranch;
  String _selectedRole = 'BARISTA';
  Employee? _employee;

  @override
  void initState() {
    super.initState();
    _loadEmployee();
  }

  Future<void> _loadEmployee() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final employee = _getMockEmployee();
    setState(() {
      _employee = employee;
      _nameCtrl.text = employee.name;
      _emailCtrl.text = employee.email;
      _selectedBranch = employee.branchName;
      _selectedRole = employee.role;
      _isActive = employee.isActive;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data karyawan berhasil diupdate'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengupdate data: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_employee == null) {
      return ManagerScaffold(
        title: 'Edit Karyawan',
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return ManagerScaffold(
      title: 'Edit: ${_employee!.name}',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Informasi Pribadi',
                    [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap *',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Nama harus diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email harus diisi';
                          if (!v.contains('@')) return 'Format email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Status Karyawan'),
                        subtitle: Text(_isActive ? 'Aktif' : 'Nonaktif'),
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    'Penempatan Kerja',
                    [
                      DropdownButtonFormField<String>(
                        value: _selectedBranch,
                        decoration: const InputDecoration(
                          labelText: 'Cabang *',
                          prefixIcon: Icon(Icons.store),
                        ),
                        items: ['Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas']
                            .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedBranch = v),
                        validator: (v) => v == null ? 'Cabang harus dipilih' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Role *',
                          prefixIcon: Icon(Icons.badge),
                        ),
                        items: ['BARISTA', 'MANAGER']
                            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedRole = v!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Simpan Perubahan'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Employee _getMockEmployee() {
    return Employee(
      id: widget.employeeId,
      name: 'Rudi Pratama',
      email: 'rudi.pratama@madjudjadja.com',
      role: 'BARISTA',
      branchId: 'BR001',
      branchName: 'Dago',
      currentPoints: -85,
      yearlyPoints: 450,
      spCount: 0,
      status: 'ACTIVE',
      joinDate: DateTime(2024, 1, 15),
      lastAttendance: DateTime.now().subtract(const Duration(days: 1)),
    );
  }
}
