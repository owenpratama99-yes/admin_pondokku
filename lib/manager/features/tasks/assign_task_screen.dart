import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class AssignTaskScreen extends StatefulWidget {
  const AssignTaskScreen({super.key});

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTemplate;
  String? _selectedBranch;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  List<String> _selectedEmployees = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Assign Task',
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
                  DropdownButtonFormField<String>(
                    value: _selectedTemplate,
                    decoration: const InputDecoration(
                      labelText: 'Pilih Template *',
                      prefixIcon: Icon(Icons.task_alt),
                    ),
                    items: _getTemplates()
                        .map((t) => DropdownMenuItem(value: t['id'], child: Text(t['title']!)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedTemplate = v),
                    validator: (v) => v == null ? 'Pilih template' : null,
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
                    validator: (v) => v == null ? 'Pilih cabang' : null,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Due Date'),
                    subtitle: Text(_formatDate(_dueDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (date != null) {
                        setState(() => _dueDate = date);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Assign ke Karyawan',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: _getEmployees().map((emp) {
                        return CheckboxListTile(
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
                        );
                      }).toList(),
                    ),
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
                              : const Text('Assign Task'),
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
            content: Text('Task berhasil di-assign'),
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
            content: Text('Gagal assign task: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Map<String, String>> _getTemplates() {
    return [
      {'id': 'TT001', 'title': 'Opening Checklist'},
      {'id': 'TT002', 'title': 'Closing Checklist'},
      {'id': 'TT003', 'title': 'Weekly Deep Clean'},
      {'id': 'TT004', 'title': 'Inventory Count'},
    ];
  }

  List<Map<String, String>> _getEmployees() {
    return [
      {'id': 'EMP001', 'name': 'Rudi Pratama', 'role': 'BARISTA'},
      {'id': 'EMP002', 'name': 'Siti Nurhaliza', 'role': 'BARISTA'},
      {'id': 'EMP003', 'name': 'Ahmad Fauzi', 'role': 'BARISTA'},
      {'id': 'EMP004', 'name': 'Budi Santoso', 'role': 'BARISTA'},
    ];
  }
}
