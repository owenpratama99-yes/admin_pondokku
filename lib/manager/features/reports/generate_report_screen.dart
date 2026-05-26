import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class GenerateReportScreen extends StatefulWidget {
  const GenerateReportScreen({super.key});

  @override
  State<GenerateReportScreen> createState() => _GenerateReportScreenState();
}

class _GenerateReportScreenState extends State<GenerateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String _reportType = 'ATTENDANCE';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _selectedBranch = 'ALL';
  String _format = 'PDF';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Generate Report',
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
                  _buildSection('Tipe Laporan', [
                    DropdownButtonFormField<String>(
                      value: _reportType,
                      decoration: const InputDecoration(
                        labelText: 'Pilih Tipe Laporan *',
                        prefixIcon: Icon(Icons.description),
                      ),
                      items: [
                        DropdownMenuItem(value: 'ATTENDANCE', child: Text('Attendance Report')),
                        DropdownMenuItem(value: 'POINT', child: Text('Point History')),
                        DropdownMenuItem(value: 'PERFORMANCE', child: Text('Performance Report')),
                        DropdownMenuItem(value: 'SP', child: Text('SP Report')),
                        DropdownMenuItem(value: 'PAYROLL', child: Text('Payroll Data')),
                      ],
                      onChanged: (v) => setState(() => _reportType = v!),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection('Periode', [
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('Start Date'),
                            subtitle: Text(_formatDate(_startDate)),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(2024),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() => _startDate = date);
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('End Date'),
                            subtitle: Text(_formatDate(_endDate)),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: _startDate,
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() => _endDate = date);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection('Filter', [
                    DropdownButtonFormField<String>(
                      value: _selectedBranch,
                      decoration: const InputDecoration(
                        labelText: 'Cabang',
                        prefixIcon: Icon(Icons.store),
                      ),
                      items: ['ALL', 'Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas']
                          .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedBranch = v!),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection('Format', [
                    DropdownButtonFormField<String>(
                      value: _format,
                      decoration: const InputDecoration(
                        labelText: 'Format File *',
                        prefixIcon: Icon(Icons.file_present),
                      ),
                      items: ['PDF', 'Excel', 'CSV']
                          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                          .toList(),
                      onChanged: (v) => setState(() => _format = v!),
                    ),
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
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _generate,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.download),
                          label: Text(_isLoading ? 'Generating...' : 'Generate & Download'),
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
          child: Column(children: children),
        ),
      ],
    );
  }

  Future<void> _generate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report generated: $_reportType.$_format'),
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
            content: Text('Failed to generate: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
