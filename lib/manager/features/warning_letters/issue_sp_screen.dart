import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class IssueSPScreen extends StatefulWidget {
  final String employeeId;
  final String employeeName;
  final int currentPoints;
  final int currentSPLevel;

  const IssueSPScreen({
    super.key,
    required this.employeeId,
    required this.employeeName,
    required this.currentPoints,
    required this.currentSPLevel,
  });

  @override
  State<IssueSPScreen> createState() => _IssueSPScreenState();
}

class _IssueSPScreenState extends State<IssueSPScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _isLoading = false;

  late int _spLevel;
  String? _selectedCategory;

  final _categories = [
    'Akumulasi Poin Minus',
    'Pelanggaran Disiplin',
    'Kinerja Buruk',
    'Pelanggaran SOP',
    'Ketidakhadiran Berulang',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-detect SP level
    _spLevel = widget.currentSPLevel + 1;
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitSP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: API call to issue SP
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('SP Level $_spLevel berhasil diterbitkan'),
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
            content: Text('Gagal menerbitkan SP: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Terbitkan Surat Peringatan',
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
                  // Warning Banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.errorSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber, color: AppColors.error, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tindakan Serius',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Penerbitan SP adalah tindakan formal yang akan tercatat permanen dalam sistem. Pastikan semua informasi sudah benar.',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Employee Info
                  Text(
                    'Informasi Karyawan',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(label: 'Nama', value: widget.employeeName),
                  _InfoRow(label: 'ID Karyawan', value: widget.employeeId),
                  _InfoRow(
                    label: 'Poin Saat Ini',
                    value: '${widget.currentPoints} pts',
                    valueColor: AppColors.error,
                  ),
                  _InfoRow(
                    label: 'SP Saat Ini',
                    value: 'Level ${widget.currentSPLevel}',
                  ),
                  const SizedBox(height: 32),

                  // SP Level (Auto-detected)
                  Text(
                    'Level SP yang Akan Diterbitkan',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getSPColor(_spLevel).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.description,
                            color: _getSPColor(_spLevel),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SP Level $_spLevel',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: _getSPColor(_spLevel),
                                ),
                              ),
                              Text(
                                _getSPDescription(_spLevel),
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Category
                  Text(
                    'Kategori Pelanggaran',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      hintText: 'Pilih kategori pelanggaran',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategory = value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kategori harus dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Reason
                  Text(
                    'Alasan Penerbitan SP',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reasonCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Jelaskan alasan penerbitan SP secara detail...',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alasan tidak boleh kosong';
                      }
                      if (value.length < 20) {
                        return 'Alasan minimal 20 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Additional Notes
                  Text(
                    'Catatan Tambahan (Opsional)',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Catatan tambahan untuk audit trail...',
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Confirmation Checkbox
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.infoSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.info.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.info),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'SP yang diterbitkan akan tercatat permanen dan dapat dilihat oleh owner. Pastikan semua informasi sudah benar sebelum melanjutkan.',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
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
                          onPressed: _isLoading ? null : _submitSP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
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
                              : Text(
                                  'Terbitkan SP Level $_spLevel',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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

  Color _getSPColor(int level) {
    switch (level) {
      case 1:
        return AppColors.warning;
      case 2:
        return const Color(0xFFFF6B00);
      case 3:
        return AppColors.error;
      default:
        return AppColors.error;
    }
  }

  String _getSPDescription(int level) {
    switch (level) {
      case 1:
        return 'Peringatan pertama - Masih ada kesempatan perbaikan';
      case 2:
        return 'Peringatan kedua - Situasi serius, perlu perbaikan segera';
      case 3:
        return 'Peringatan terakhir - Risiko terminasi tinggi';
      default:
        return 'Level maksimal tercapai - Rekomendasi terminasi';
    }
  }
}

// ─── Info Row Widget ──────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
