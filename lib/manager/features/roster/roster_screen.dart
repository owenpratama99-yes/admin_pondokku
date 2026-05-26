import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class RosterScreen extends StatefulWidget {
  const RosterScreen({super.key});

  @override
  State<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends State<RosterScreen> {
  String _searchQuery = '';
  String _selectedBranch = 'Semua';

  // Simulated daily attendance database
  final List<Map<String, dynamic>> _rosterData = [
    {
      'name': 'Budi Santoso',
      'role': 'Barista',
      'branch': 'Dago',
      'checkIn': '06:58',
      'checkOut': '15:05',
      'gpsStatus': 'Verified (Dago Cafe, 0.01 km)',
      'status': 'hadir',
    },
    {
      'name': 'Siti Rahma',
      'role': 'Kitchen Staff',
      'branch': 'Dipatiukur',
      'checkIn': '07:15',
      'checkOut': '15:00',
      'gpsStatus': 'Verified (DU Cafe, 0.03 km)',
      'status': 'terlambat',
    },
    {
      'name': 'Andi Wijaya',
      'role': 'Server',
      'branch': 'Pasteur',
      'checkIn': '14:55',
      'checkOut': '--:--',
      'gpsStatus': 'Verified (Pasteur Cafe, 0.02 km)',
      'status': 'hadir',
    },
    {
      'name': 'Dewi Lestari',
      'role': 'Barista',
      'branch': 'Dago',
      'checkIn': '--:--',
      'checkOut': '--:--',
      'gpsStatus': 'Izin Sakit (Surat Dokter Terlampir)',
      'status': 'izin',
    },
    {
      'name': 'Reza Fahmi',
      'role': 'Kitchen Staff',
      'branch': 'Pasteur',
      'checkIn': '--:--',
      'checkOut': '--:--',
      'gpsStatus': 'Tidak ada keterangan',
      'status': 'alpa',
    },
    {
      'name': 'Farhan Hakim',
      'role': 'Server',
      'branch': 'Dipatiukur',
      'checkIn': '15:02',
      'checkOut': '--:--',
      'gpsStatus': 'Verified (DU Cafe, 0.01 km)',
      'status': 'hadir',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final filteredList = _rosterData.where((emp) {
      final matchesSearch =
          emp['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              emp['role'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesBranch =
          _selectedBranch == 'Semua' || emp['branch'] == _selectedBranch;
      return matchesSearch && matchesBranch;
    }).toList();

    // Stats calculations
    final totalPresent =
        _rosterData.where((e) => e['status'] == 'hadir').length;
    final totalLate =
        _rosterData.where((e) => e['status'] == 'terlambat').length;
    final totalPermitted =
        _rosterData.where((e) => e['status'] == 'izin').length;
    final totalAbsent = _rosterData.where((e) => e['status'] == 'alpa').length;

    return ManagerScaffold(
      title: 'Roster & Presensi Pegawai',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Panel
            Row(
              children: [
                _buildStatTile(
                    'Hadir Tepat Waktu',
                    '$totalPresent',
                    AppColors.success,
                    AppColors.successSurface,
                    Icons.check_circle),
                const SizedBox(width: 16),
                _buildStatTile('Terlambat', '$totalLate', AppColors.warning,
                    AppColors.warningSurface, Icons.error),
                const SizedBox(width: 16),
                _buildStatTile(
                    'Izin / Sakit',
                    '$totalPermitted',
                    AppColors.info,
                    AppColors.infoSurface,
                    Icons.medical_services),
                const SizedBox(width: 16),
                _buildStatTile('Alpa / Absen', '$totalAbsent', AppColors.error,
                    AppColors.errorSurface, Icons.cancel),
              ],
            ),
            const SizedBox(height: 24),

            // Filter Bar Row
            Card(
              elevation: 0,
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Search bar
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Cari nama pegawai atau role...',
                          prefixIcon:
                              Icon(Icons.search, color: AppColors.primary),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          fillColor: AppColors.background,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Branch filter drop down
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedBranch,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          fillColor: AppColors.background,
                          prefixIcon: Icon(Icons.location_on,
                              color: AppColors.secondary),
                        ),
                        dropdownColor: AppColors.surfaceCard,
                        items: ['Semua', 'Dago', 'Dipatiukur', 'Pasteur']
                            .map((branch) {
                          return DropdownMenuItem<String>(
                            value: branch,
                            child: Text(branch == 'Semua'
                                ? 'Semua Cabang'
                                : 'Cabang $branch'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedBranch = val ?? 'Semua';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Roster Table Content
            Expanded(
              child: Card(
                elevation: 2,
                shadowColor: AppColors.primaryDark.withOpacity(0.04),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadwal & Kehadiran Hari Ini',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 32,
                              headingRowColor: WidgetStateProperty.all(
                                  AppColors.surfaceVariant),
                              dataRowMaxHeight: 64,
                              columns: [
                                DataColumn(
                                    label: Text('Nama Pegawai',
                                        style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Cabang',
                                        style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Masuk (Shift)',
                                        style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Pulang',
                                        style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Status Kehadiran',
                                        style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Verifikasi GPS',
                                        style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: filteredList.map((emp) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                AppColors.primarySurface,
                                            child: Text(
                                              emp['name'][0],
                                              style: GoogleFonts.outfit(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                emp['name'],
                                                style: GoogleFonts.outfit(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.textPrimary),
                                              ),
                                              Text(
                                                emp['role'],
                                                style: GoogleFonts.outfit(
                                                    fontSize: 12,
                                                    color: AppColors.textMuted),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        'Cabang ${emp['branch']}',
                                        style: GoogleFonts.outfit(
                                            fontSize: 13.5,
                                            color: AppColors.textSecondary),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        emp['checkIn'],
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w500,
                                          color: emp['status'] == 'terlambat'
                                              ? AppColors.error
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        emp['checkOut'],
                                        style: GoogleFonts.outfit(
                                            fontSize: 13.5,
                                            color: AppColors.textPrimary),
                                      ),
                                    ),
                                    DataCell(_buildStatusChip(emp['status'])),
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            emp['status'] == 'hadir' ||
                                                    emp['status'] == 'terlambat'
                                                ? Icons.location_on
                                                : Icons.info_outline,
                                            size: 14,
                                            color: emp['status'] == 'hadir' ||
                                                    emp['status'] == 'terlambat'
                                                ? AppColors.success
                                                : AppColors.textMuted,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            emp['gpsStatus'],
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              color: emp['status'] == 'hadir' ||
                                                      emp['status'] ==
                                                          'terlambat'
                                                  ? AppColors.textSecondary
                                                  : AppColors.textMuted,
                                              fontStyle: emp['status'] == 'izin'
                                                  ? FontStyle.italic
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
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

  Widget _buildStatTile(
      String label, String value, Color color, Color bg, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bg = AppColors.surfaceVariant;
    Color text = AppColors.textSecondary;
    String label = 'Hadir';

    switch (status) {
      case 'hadir':
        bg = AppColors.successSurface;
        text = AppColors.success;
        label = 'Hadir';
        break;
      case 'terlambat':
        bg = AppColors.warningSurface;
        text = AppColors.warning;
        label = 'Terlambat';
        break;
      case 'izin':
        bg = AppColors.infoSurface;
        text = AppColors.info;
        label = 'Izin';
        break;
      case 'alpa':
        bg = AppColors.errorSurface;
        text = AppColors.error;
        label = 'Alpa';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: text.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }
}
