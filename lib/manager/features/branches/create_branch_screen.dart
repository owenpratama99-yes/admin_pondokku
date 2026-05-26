import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class CreateBranchScreen extends StatefulWidget {
  const CreateBranchScreen({super.key});

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();
}

class _CreateBranchScreenState extends State<CreateBranchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _latitudeCtrl = TextEditingController();
  final _longitudeCtrl = TextEditingController();
  final _radiusCtrl = TextEditingController(text: '50');
  
  bool _isLoading = false;
  String? _selectedManager;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _latitudeCtrl.dispose();
    _longitudeCtrl.dispose();
    _radiusCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: API call to create branch
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cabang berhasil ditambahkan'),
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
            content: Text('Gagal menambahkan cabang: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Tambah Cabang Baru',
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
                    title: 'Informasi Dasar',
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nama Cabang *',
                          hintText: 'Contoh: Dago',
                          prefixIcon: Icon(Icons.store),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama cabang harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Alamat Lengkap *',
                          hintText: 'Jl. ...',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon',
                          hintText: '022-1234567',
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    title: 'Lokasi & Geofencing',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _latitudeCtrl,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Latitude *',
                                hintText: '-6.8700',
                                prefixIcon: Icon(Icons.gps_fixed),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Latitude harus diisi';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Format tidak valid';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _longitudeCtrl,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Longitude *',
                                hintText: '107.6100',
                                prefixIcon: Icon(Icons.gps_fixed),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Longitude harus diisi';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Format tidak valid';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _radiusCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Radius Geofence (meter) *',
                          hintText: '50',
                          prefixIcon: Icon(Icons.radio_button_checked),
                          helperText: 'Jarak maksimal untuk absensi (default: 50 meter)',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Radius harus diisi';
                          }
                          final radius = int.tryParse(value);
                          if (radius == null || radius < 10 || radius > 200) {
                            return 'Radius harus antara 10-200 meter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
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
                                'Gunakan Google Maps untuk mendapatkan koordinat yang akurat',
                                style: GoogleFonts.outfit(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    title: 'Manager Cabang',
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedManager,
                        decoration: const InputDecoration(
                          labelText: 'Pilih Manager (Opsional)',
                          prefixIcon: Icon(Icons.person),
                          helperText: 'Manager dapat ditambahkan nanti',
                        ),
                        items: _getAvailableManagers().map((manager) {
                          return DropdownMenuItem(
                            value: manager['id'],
                            child: Text(manager['name']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedManager = value);
                        },
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
                              : const Text('Tambah Cabang'),
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

  Widget _buildSection({required String title, required List<Widget> children}) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  List<Map<String, String>> _getAvailableManagers() {
    // TODO: Fetch from API
    return [
      {'id': 'MGR001', 'name': 'Budi Santoso'},
      {'id': 'MGR002', 'name': 'Siti Rahayu'},
      {'id': 'MGR003', 'name': 'Ahmad Fauzi'},
    ];
  }
}
