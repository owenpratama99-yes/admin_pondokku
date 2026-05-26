import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/shift_model.dart';
import '../../widgets/manager_scaffold.dart';

class ShiftsScreen extends StatefulWidget {
  const ShiftsScreen({super.key});

  @override
  State<ShiftsScreen> createState() => _ShiftsScreenState();
}

class _ShiftsScreenState extends State<ShiftsScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedBranch = 'ALL';

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Manajemen Shift',
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildShiftCalendar()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal Shift',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_formatDate(_selectedDate)}',
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create shift schedule')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Buat Jadwal'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.background,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2025),
                        );
                        if (date != null) {
                          setState(() => _selectedDate = date);
                        }
                      },
                      child: Text(
                        _formatWeek(_selectedDate),
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 7));
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 200,
            child: DropdownButtonFormField<String>(
              value: _selectedBranch,
              decoration: const InputDecoration(labelText: 'Cabang'),
              items: ['ALL', 'Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas']
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedBranch = v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftCalendar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildShiftTypeSection('MORNING', 'Shift Pagi (08:00-16:00)', AppColors.info),
          const SizedBox(height: 20),
          _buildShiftTypeSection('AFTERNOON', 'Shift Siang (14:00-22:00)', AppColors.warning),
          const SizedBox(height: 20),
          _buildShiftTypeSection('NIGHT', 'Shift Malam (20:00-04:00)', AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildShiftTypeSection(String type, String title, Color color) {
    final shifts = _getMockShifts().where((s) => s.shiftType == type).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.access_time, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                '${shifts.length} karyawan',
                style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: shifts.map((shift) => _buildShiftChip(shift, color)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftChip(Shift shift, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('View shift: ${shift.employeeName}')),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: color,
              child: Text(
                shift.employeeName.substring(0, 1),
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              shift.employeeName,
              style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            if (shift.isOvertime) ...[
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 14, color: AppColors.secondary),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatWeek(DateTime date) {
    final start = date.subtract(Duration(days: date.weekday - 1));
    final end = start.add(const Duration(days: 6));
    return '${start.day}-${end.day} ${_formatDate(start).split(' ')[1]} ${start.year}';
  }

  List<Shift> _getMockShifts() {
    return [
      Shift(
        id: 'SH001',
        employeeId: 'EMP001',
        employeeName: 'Rudi',
        branchId: 'BR001',
        branchName: 'Dago',
        date: _selectedDate,
        shiftType: 'MORNING',
        startTime: '08:00',
        endTime: '16:00',
        status: 'SCHEDULED',
      ),
      Shift(
        id: 'SH002',
        employeeId: 'EMP002',
        employeeName: 'Siti',
        branchId: 'BR001',
        branchName: 'Dago',
        date: _selectedDate,
        shiftType: 'MORNING',
        startTime: '08:00',
        endTime: '16:00',
        status: 'SCHEDULED',
      ),
      Shift(
        id: 'SH003',
        employeeId: 'EMP003',
        employeeName: 'Ahmad',
        branchId: 'BR001',
        branchName: 'Dago',
        date: _selectedDate,
        shiftType: 'AFTERNOON',
        startTime: '14:00',
        endTime: '22:00',
        status: 'SCHEDULED',
      ),
      Shift(
        id: 'SH004',
        employeeId: 'EMP004',
        employeeName: 'Budi',
        branchId: 'BR001',
        branchName: 'Dago',
        date: _selectedDate,
        shiftType: 'AFTERNOON',
        startTime: '14:00',
        endTime: '22:00',
        status: 'SCHEDULED',
        isOvertime: true,
      ),
      Shift(
        id: 'SH005',
        employeeId: 'EMP005',
        employeeName: 'Dewi',
        branchId: 'BR001',
        branchName: 'Dago',
        date: _selectedDate,
        shiftType: 'NIGHT',
        startTime: '20:00',
        endTime: '04:00',
        status: 'SCHEDULED',
      ),
    ];
  }
}
