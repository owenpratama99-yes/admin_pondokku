import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class CreateAchievementScreen extends StatefulWidget {
  const CreateAchievementScreen({super.key});

  @override
  State<CreateAchievementScreen> createState() => _CreateAchievementScreenState();
}

class _CreateAchievementScreenState extends State<CreateAchievementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController();
  
  String _selectedIcon = 'star';
  String _selectedCategory = 'attendance';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _pointsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Buat Achievement',
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
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nama Achievement *',
                      hintText: 'Contoh: Perfect Attendance',
                      prefixIcon: Icon(Icons.emoji_events),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Nama harus diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi *',
                      hintText: 'Jelaskan kriteria achievement...',
                      prefixIcon: Icon(Icons.description),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Deskripsi harus diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pointsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Poin Reward *',
                      hintText: '100',
                      prefixIcon: Icon(Icons.stars),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Poin harus diisi';
                      if (int.tryParse(v) == null) return 'Harus berupa angka';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategori *',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: [
                      DropdownMenuItem(value: 'attendance', child: Text('Attendance')),
                      DropdownMenuItem(value: 'sales', child: Text('Sales')),
                      DropdownMenuItem(value: 'service', child: Text('Service')),
                      DropdownMenuItem(value: 'performance', child: Text('Performance')),
                      DropdownMenuItem(value: 'teamwork', child: Text('Teamwork')),
                      DropdownMenuItem(value: 'efficiency', child: Text('Efficiency')),
                    ],
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Pilih Badge Icon',
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildIconOption('star', Icons.star),
                      _buildIconOption('trophy', Icons.emoji_events),
                      _buildIconOption('fire', Icons.local_fire_department),
                      _buildIconOption('heart', Icons.favorite),
                      _buildIconOption('diamond', Icons.diamond),
                      _buildIconOption('medal', Icons.military_tech),
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
                              : const Text('Buat Achievement'),
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

  Widget _buildIconOption(String value, IconData icon) {
    final isSelected = _selectedIcon == value;
    
    return InkWell(
      onTap: () => setState(() => _selectedIcon = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.secondary : AppColors.textMuted,
          size: 28,
        ),
      ),
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
            content: Text('Achievement berhasil dibuat'),
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
            content: Text('Gagal membuat achievement: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
