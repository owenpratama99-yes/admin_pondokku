import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';
import '../../../core/constants.dart';

class ManualAdjustmentScreen extends StatefulWidget {
  const ManualAdjustmentScreen({super.key});

  @override
  State<ManualAdjustmentScreen> createState() => _ManualAdjustmentScreenState();
}

class _ManualAdjustmentScreenState extends State<ManualAdjustmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Input fields state
  String? _selectedEmployee;
  String _adjustmentType = 'credit'; // 'credit' = Add, 'debit' = Deduct
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedCategory;

  // Predefined SOP categories
  final List<Map<String, dynamic>> _predefinedCategories = [
    {
      'label': 'Service Excellence (+50)',
      'points': 50,
      'type': 'credit',
      'reason': 'Penghargaan atas pelayanan luar biasa yang diapresiasi oleh pelanggan (Service Excellence).'
    },
    {
      'label': 'Lembur Cover Shift (+100)',
      'points': 100,
      'type': 'credit',
      'reason': 'Bonus covering shift barista mendadak agar operasional kafe tetap berjalan lancar.'
    },
    {
      'label': 'Bintang 5 Ulasan (+75)',
      'points': 75,
      'type': 'credit',
      'reason': 'Mendapatkan ulasan bintang 5 spesifik dari pelanggan di Google Maps / Media Sosial.'
    },
    {
      'label': 'Keterlambatan Masuk (-30)',
      'points': 30,
      'type': 'debit',
      'reason': 'Potongan poin atas pelanggaran keterlambatan masuk shift kerja > 15 menit.'
    },
    {
      'label': 'Seragam Kotor / Atribut Tidak Lengkap (-15)',
      'points': 15,
      'type': 'debit',
      'reason': 'Temuan langsung (on-the-spot): Atribut seragam tidak lengkap atau kotor tidak sesuai standar SOP.'
    },
    {
      'label': 'SOP Kerja Terabaikan (-50)',
      'points': 50,
      'type': 'debit',
      'reason': 'Kelalaian kerja dalam melaksanakan SOP penutupan/pembukaan atau persiapan bahan.'
    },
    {
      'label': 'Lain-lain / Custom (Poin manual)',
      'points': null,
      'type': null,
      'reason': ''
    }
  ];

  // Simulated employee database
  final List<Map<String, String>> _employees = [
    {'id': 'emp-001', 'name': 'Budi Santoso', 'role': 'Barista (Dago)'},
    {'id': 'emp-002', 'name': 'Siti Rahma', 'role': 'Kitchen (Dipatiukur)'},
    {'id': 'emp-003', 'name': 'Andi Wijaya', 'role': 'Server (Pasteur)'},
    {'id': 'emp-004', 'name': 'Dewi Lestari', 'role': 'Barista (Dago)'},
    {'id': 'emp-005', 'name': 'Reza Fahmi', 'role': 'Kitchen (Pasteur)'},
  ];

  // Simulated adjustment logs history
  final List<Map<String, dynamic>> _adjustmentLogs = [
    {
      'date': '23 Mei 2026, 15:30',
      'employee': 'Siti Rahma',
      'type': 'credit',
      'points': 50,
      'reason': 'Lembur dadakan cover shift siang',
      'adjustedBy': 'Manager Owen',
    },
    {
      'date': '22 Mei 2026, 18:10',
      'employee': 'Andi Wijaya',
      'type': 'debit',
      'points': 30,
      'reason': 'Keterlambatan masuk shift sore > 30 menit',
      'adjustedBy': 'Manager Owen',
    },
    {
      'date': '21 Mei 2026, 11:20',
      'employee': 'Budi Santoso',
      'type': 'credit',
      'points': 100,
      'reason': 'Bonus review bintang 5 dari pelanggan menyebut nama',
      'adjustedBy': 'Manager Owen',
    },
  ];

  @override
  void dispose() {
    _pointsController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submitAdjustment() {
    if (CurrentSession.isReadOnly) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.lock, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Akses Ditolak: Akun Investor tidak diizinkan mengubah data.',
                style: GoogleFonts.outfit(),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate() || _selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap lengkapi semua isian form!',
              style: GoogleFonts.outfit()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final employeeName =
        _employees.firstWhere((emp) => emp['id'] == _selectedEmployee)['name'];
    final points = int.parse(_pointsController.text);
    final reason = _reasonController.text;

    setState(() {
      _adjustmentLogs.insert(0, {
        'date': 'Hari Ini, ${TimeOfDay.now().format(context)}',
        'employee': employeeName,
        'type': _adjustmentType,
        'points': points,
        'reason': reason,
        'adjustedBy': 'Manager Owen',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              'Poin untuk $employeeName berhasil disesuaikan!',
              style: GoogleFonts.outfit(),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );

    // Reset fields
    _pointsController.clear();
    _reasonController.clear();
    setState(() {
      _selectedEmployee = null;
      _adjustmentType = 'credit';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Kelola & Penyesuaian Poin',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: The Input Form (Flexible/Card)
            Expanded(
              flex: 4,
              child: Card(
                elevation: 2,
                shadowColor: AppColors.primaryDark.withOpacity(0.04),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Form Penyesuaian Poin Manual',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Berikan kredit bonus poin atau debit denda pelanggaran kepada pegawai.',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Employee Dropdown Selector
                        Text(
                          'Pilih Pegawai',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedEmployee,
                          decoration: const InputDecoration(
                            hintText: 'Cari nama pegawai...',
                            prefixIcon:
                                Icon(Icons.person, color: AppColors.primary),
                          ),
                          dropdownColor: AppColors.surfaceCard,
                          items: _employees.map((emp) {
                            return DropdownMenuItem<String>(
                              value: emp['id'],
                              child: Text('${emp['name']} - ${emp['role']}'),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedEmployee = val;
                            });
                          },
                          validator: (val) =>
                              val == null ? 'Pegawai wajib dipilih' : null,
                        ),
                        const SizedBox(height: 20),

                        // Predefined Category Dropdown
                        Text(
                          'Kategori Penyesuaian SOP',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(
                            hintText: 'Pilih kategori pelanggaran / prestasi...',
                            prefixIcon: Icon(Icons.category_outlined, color: AppColors.secondary),
                          ),
                          dropdownColor: AppColors.surfaceCard,
                          items: _predefinedCategories.map((cat) {
                            return DropdownMenuItem<String>(
                              value: cat['label'],
                              child: Text(cat['label']),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedCategory = val;
                              final match = _predefinedCategories.firstWhere((c) => c['label'] == val);
                              if (match['points'] != null) {
                                _pointsController.text = match['points'].toString();
                                _adjustmentType = match['type'];
                                _reasonController.text = match['reason'];
                              } else {
                                _pointsController.clear();
                                _reasonController.clear();
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Action Type Selector (Credit/Debit Tabs)
                        Text(
                          'Jenis Penyesuaian',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTypeButton(
                                type: 'credit',
                                label: 'Kredit Poin (Bonus)',
                                icon: Icons.add_circle_outline,
                                activeColor: AppColors.success,
                                activeBg: AppColors.successSurface,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTypeButton(
                                type: 'debit',
                                label: 'Debit Poin (Potongan)',
                                icon: Icons.remove_circle_outline,
                                activeColor: AppColors.error,
                                activeBg: AppColors.errorSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Point input
                        Text(
                          'Jumlah Poin',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _pointsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan jumlah poin (contoh: 50)',
                            prefixIcon:
                                Icon(Icons.star, color: AppColors.secondary),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Jumlah poin wajib diisi';
                            }
                            final parsed = int.tryParse(val);
                            if (parsed == null || parsed <= 0) {
                              return 'Masukkan angka positif yang valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Reason input
                        Text(
                          'Alasan Penyesuaian',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _reasonController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText:
                                'Tuliskan deskripsi alasan penyesuaian secara detail...',
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(bottom: 30),
                              child: Icon(Icons.note_alt,
                                  color: AppColors.primary),
                            ),
                          ),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Alasan penyesuaian wajib diisi'
                              : null,
                        ),
                        const SizedBox(height: 28),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: _submitAdjustment,
                            icon: const Icon(Icons.save),
                            label: Text(
                              'Proses Penyesuaian Poin',
                              style: GoogleFonts.outfit(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),

            // Right Column: Log History Table
            Expanded(
              flex: 5,
              child: Card(
                elevation: 2,
                shadowColor: AppColors.primaryDark.withOpacity(0.04),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.history,
                              color: AppColors.primary, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'Riwayat Penyesuaian Manual',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Daftar log penyesuaian poin terbaru oleh tim manajemen.',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Logs list
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _adjustmentLogs.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final log = _adjustmentLogs[index];
                          final isCredit = log['type'] == 'credit';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon badge
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: isCredit
                                      ? AppColors.successSurface
                                      : AppColors.errorSurface,
                                  child: Icon(
                                    isCredit
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 16,
                                    color: isCredit
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Text details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            log['employee'],
                                            style: GoogleFonts.outfit(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            '${isCredit ? "+" : "-"}${log['points']} Pts',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: isCredit
                                                  ? AppColors.success
                                                  : AppColors.error,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        log['reason'],
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text(
                                            'Oleh: ${log['adjustedBy']}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 11,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            log['date'],
                                            style: GoogleFonts.outfit(
                                              fontSize: 11,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String type,
    required String label,
    required IconData icon,
    required Color activeColor,
    required Color activeBg,
  }) {
    final isSelected = _adjustmentType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _adjustmentType = type;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
