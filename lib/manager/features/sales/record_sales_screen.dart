import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class RecordSalesScreen extends StatefulWidget {
  const RecordSalesScreen({super.key});

  @override
  State<RecordSalesScreen> createState() => _RecordSalesScreenState();
}

class _RecordSalesScreenState extends State<RecordSalesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cashCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _tipsCtrl = TextEditingController();
  final _transCountCtrl = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String? _selectedBranch;
  String _shiftType = 'MORNING';
  bool _isLoading = false;

  @override
  void dispose() {
    _cashCtrl.dispose();
    _cardCtrl.dispose();
    _tipsCtrl.dispose();
    _transCountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Record Sales',
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
                  _buildSection('Informasi Dasar', [
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
                      title: const Text('Tanggal'),
                      subtitle: Text(_formatDate(_selectedDate)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 7)),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => _selectedDate = date);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _shiftType,
                      decoration: const InputDecoration(
                        labelText: 'Shift *',
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
                  const SizedBox(height: 24),
                  _buildSection('Detail Penjualan', [
                    TextFormField(
                      controller: _cashCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cash Sales *',
                        hintText: '0',
                        prefixText: 'Rp ',
                        prefixIcon: Icon(Icons.money),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cardCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Card Sales *',
                        hintText: '0',
                        prefixText: 'Rp ',
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tipsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Tips',
                        hintText: '0',
                        prefixText: 'Rp ',
                        prefixIcon: Icon(Icons.volunteer_activism),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _transCountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Transaksi *',
                        hintText: '0',
                        prefixIcon: Icon(Icons.receipt),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
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
                              : const Text('Simpan Sales'),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sales berhasil direcord'),
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
            content: Text('Gagal menyimpan: $e'),
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
