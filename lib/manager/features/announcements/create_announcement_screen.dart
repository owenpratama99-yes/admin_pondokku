import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  String _target = 'ALL';
  bool _isPinned = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Buat Pengumuman',
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
                      labelText: 'Judul Pengumuman *',
                      hintText: 'Contoh: Update Kebijakan Shift',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Judul harus diisi' : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _contentCtrl,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Isi Pengumuman *',
                      hintText: 'Tulis pengumuman lengkap di sini...',
                      prefixIcon: Icon(Icons.description),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Isi harus diisi' : null,
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: _target,
                    decoration: const InputDecoration(
                      labelText: 'Target Pengumuman *',
                      prefixIcon: Icon(Icons.people),
                    ),
                    items: [
                      const DropdownMenuItem(value: 'ALL', child: Text('Semua Cabang')),
                      const DropdownMenuItem(value: 'Dago', child: Text('Dago')),
                      const DropdownMenuItem(value: 'Dipatiukur', child: Text('Dipatiukur')),
                      const DropdownMenuItem(value: 'Pasteur', child: Text('Pasteur')),
                      const DropdownMenuItem(value: 'Cihampelas', child: Text('Cihampelas')),
                    ],
                    onChanged: (v) => setState(() => _target = v!),
                  ),
                  const SizedBox(height: 24),
                  SwitchListTile(
                    title: const Text('Pin Pengumuman'),
                    subtitle: const Text('Pengumuman akan muncul di atas'),
                    value: _isPinned,
                    onChanged: (v) => setState(() => _isPinned = v),
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
                              : const Text('Publish Pengumuman'),
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

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengumuman berhasil dipublish'),
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
            content: Text('Gagal publish: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
