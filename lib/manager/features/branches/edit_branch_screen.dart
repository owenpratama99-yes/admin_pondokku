import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/branch_model.dart';
import '../../widgets/manager_scaffold.dart';

class EditBranchScreen extends StatefulWidget {
  final String branchId;

  const EditBranchScreen({super.key, required this.branchId});

  @override
  State<EditBranchScreen> createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _latitudeCtrl = TextEditingController();
  final _longitudeCtrl = TextEditingController();
  final _radiusCtrl = TextEditingController();
  
  bool _isLoading = false;
  bool _isActive = true;
  String? _selectedManager;
  Branch? _branch;

  @override
  void initState() {
    super.initState();
    _loadBranch();
  }

  Future<void> _loadBranch() async {
    // TODO: Fetch from API
    await Future.delayed(const Duration(milliseconds: 500));
    
    final branch = _getMockBranch();
    setState(() {
      _branch = branch;
      _nameCtrl.text = branch.name;
      _addressCtrl.text = branch.address;
      _phoneCtrl.text = branch.phoneNumber ?? '';
      _latitudeCtrl.text = branch.latitude.toString();
      _longitudeCtrl.text = branch.longitude.toString();
      _radiusCtrl.text = branch.radiusMeters.toString();
      _isActive = branch.isActive;
      _selectedManager = branch.managerId;
    });
  }

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
      // TODO: API call to update branch
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cabang berhasil diupdate'),
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
            content: Text('Gagal mengupdate cabang: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_branch == null) {
      return ManagerScaffold(
        title: 'Edit Cabang',
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return ManagerScaffold(
      title: 'Edit Cabang: ${_branch!.name}',
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
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Status Cabang'),
                        subtitle: Text(_isActive ? 'Aktif' : 'Nonaktif'),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() => _isActive = value);
                        },
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
                          prefixIcon: Icon(Icons.radio_button_checked),
                          helperText: 'Jarak maksimal untuk absensi',
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
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    title: 'Manager Cabang',
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedManager,
                        decoration: const InputDecoration(
                          labelText: 'Manager Cabang',
                          prefixIcon: Icon(Icons.person),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Tidak ada manager'),
                          ),
                          ..._getAvailableManagers().map((manager) {
                            return DropdownMenuItem(
                              value: manager['id'],
                              child: Text(manager['name']!),
                            );
                          }),
                        ],
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

  Branch _getMockBranch() {
    return Branch(
      id: widget.branchId,
      name: 'Dago',
      address: 'Jl. Ir. H. Djuanda No. 123, Dago, Bandung',
      latitude: -6.8700,
      longitude: 107.6100,
      radiusMeters: 50,
      managerId: 'MGR001',
      managerName: 'Budi Santoso',
      employeeCount: 18,
      status: 'ACTIVE',
      phoneNumber: '022-1234567',
    );
  }
}
