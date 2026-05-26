import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class CreateShiftScreen extends StatefulWidget {
  const CreateShiftScreen({super.key});

  @override
  State<CreateShiftScreen> createState() => _CreateShiftScreenState();
}

class _CreateShiftScreenState extends State<CreateShiftScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String _shiftType = 'MORNING';
  String? _selectedBranch;
  List<String> _selectedEmployees = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Buat Jadwal Shift',
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
                  _buildSection('Informasi Shift', [
                    ListTile(
                      title: const Text('Tanggal'),
                      subtitle: Text(_formatDate(_selectedDate)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                        );
                        if (date != null) {
                          setState(() => _selectedDate = date);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
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
                      value: _shiftType,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Shift *',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      items: [
                        DropdownMenuItem(value: 'MORNING', child: Text('Pagi (08:00-16:00)')),
                        DropdownMenuItem(value: 'AFTERNOON', child: Text('Siang (14:00-22:00)')),
                        DropdownMenuItem(value: 'NIGHT', child: Text('Malam (20:00-04:00)')),
                      ],
                      onChanged: (v) => setState(() => _shiftType = v!),
                    ),
                  ]),
                  const SizedBox(height: 32),
                  _buildSection('Pilih Karyawan', [
                    Text(
                      '${_selectedEmployees.length} karyawan dipilih',
                      style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 12),
                    ..._getAvailableEmployees().map((emp) => CheckboxListTile(
                      title: Text(emp['name']!),
                      subtitle: Text(emp['role']!),
                      value: _selectedEmployees.contains(emp['id']),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedEmployees.add(emp['id']!);
                          } else {
                            _selectedEmployees.remove(emp['id']);
                          }
                        });
                      },
                    )),
                  ]),
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
                              : const Text('Buat Jadwal'),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEmployees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 1 karyawan'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jadwal shift berhasil dibuat'),
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
            content: Text('Gagal membuat jadwal: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Map<String, String>> _getAvailableEmployees() {
    return [
      {'id': 'EMP001', 'name': 'Rudi Pratama', 'role': 'BARISTA'},
      {'id': 'EMP002', 'name': 'Siti Nurhaliza', 'role': 'BARISTA'},
      {'id': 'EMP003', 'name': 'Ahmad Fauzi', 'role': 'BARISTA'},
      {'id': 'EMP004', 'name': 'Budi Santoso', 'role': 'BARISTA'},
      {'id': 'EMP005', 'name': 'Dewi Lestari', 'role': 'BARISTA'},
    ];
  }
}
