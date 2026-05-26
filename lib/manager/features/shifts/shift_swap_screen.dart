import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class ShiftSwapScreen extends StatefulWidget {
  const ShiftSwapScreen({super.key});

  @override
  State<ShiftSwapScreen> createState() => _ShiftSwapScreenState();
}

class _ShiftSwapScreenState extends State<ShiftSwapScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Swap Shift Requests',
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.secondary,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'History'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendingTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTab() {
    final requests = _getMockRequests().where((r) => r['status'] == 'PENDING').toList();

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.swap_horiz, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text('Tidak ada request pending', style: GoogleFonts.outfit(fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildRequestCard(requests[index]);
      },
    );
  }

  Widget _buildHistoryTab() {
    final requests = _getMockRequests().where((r) => r['status'] != 'PENDING').toList();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildRequestCard(requests[index]);
      },
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    final isPending = request['status'] == 'PENDING';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primarySurface,
                child: Text(
                  request['from'].toString().substring(0, 1),
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['from'],
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      request['date'],
                      style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(request['status']),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildShiftInfo('Current', request['currentShift'], AppColors.error),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.swap_horiz, color: AppColors.textMuted),
              ),
              Expanded(
                child: _buildShiftInfo('Swap With', request['swapWith'], AppColors.success),
              ),
            ],
          ),
          if (request['reason'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.infoSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppColors.info),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      request['reason'],
                      style: GoogleFonts.outfit(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleReject(request),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleApprove(request),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShiftInfo(String label, String shift, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            shift,
            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'APPROVED':
        color = AppColors.success;
        break;
      case 'REJECTED':
        color = AppColors.error;
        break;
      default:
        color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _handleApprove(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Swap Request?'),
        content: Text('Approve swap shift untuk ${request['from']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Swap request approved'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _handleReject(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Swap Request?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reject swap shift untuk ${request['from']}?'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Alasan (opsional)',
                hintText: 'Jelaskan alasan penolakan...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Swap request rejected'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockRequests() {
    return [
      {
        'id': 'SW001',
        'from': 'Rudi Pratama',
        'date': '25 Mei 2026',
        'currentShift': 'Pagi (08:00-16:00)',
        'swapWith': 'Siang (14:00-22:00)',
        'reason': 'Ada keperluan keluarga di pagi hari',
        'status': 'PENDING',
      },
      {
        'id': 'SW002',
        'from': 'Siti Nurhaliza',
        'date': '26 Mei 2026',
        'currentShift': 'Malam (20:00-04:00)',
        'swapWith': 'Pagi (08:00-16:00)',
        'reason': null,
        'status': 'PENDING',
      },
      {
        'id': 'SW003',
        'from': 'Ahmad Fauzi',
        'date': '24 Mei 2026',
        'currentShift': 'Siang (14:00-22:00)',
        'swapWith': 'Pagi (08:00-16:00)',
        'reason': 'Sudah disetujui oleh rekan kerja',
        'status': 'APPROVED',
      },
      {
        'id': 'SW004',
        'from': 'Budi Santoso',
        'date': '23 Mei 2026',
        'currentShift': 'Pagi (08:00-16:00)',
        'swapWith': 'Malam (20:00-04:00)',
        'reason': 'Request tidak sesuai kebijakan',
        'status': 'REJECTED',
      },
    ];
  }
}
