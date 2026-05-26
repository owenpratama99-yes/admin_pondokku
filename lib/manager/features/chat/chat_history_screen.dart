import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  String _selectedBranch = 'ALL';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Chat History',
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildHistoryList()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedBranch,
              decoration: const InputDecoration(labelText: 'Cabang'),
              items: ['ALL', 'Dago', 'Dipatiukur', 'Pasteur', 'Cihampelas']
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedBranch = v!),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ListTile(
              title: const Text('Start Date'),
              subtitle: Text(_formatDate(_startDate)),
              trailing: const Icon(Icons.calendar_today, size: 20),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _startDate = date);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ListTile(
              title: const Text('End Date'),
              subtitle: Text(_formatDate(_endDate)),
              trailing: const Icon(Icons.calendar_today, size: 20),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: _startDate,
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _endDate = date);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export chat history')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    final history = _getMockHistory();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildHistoryCard(history[index]);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
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
                radius: 20,
                backgroundColor: AppColors.primarySurface,
                child: Text(
                  item['room'].toString().substring(0, 1),
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
                      item['room'],
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${item['date']} • ${item['messageCount']} messages',
                      style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('View: ${item['room']}')),
                  );
                },
                icon: const Icon(Icons.visibility),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item['lastMessage'],
              style: GoogleFonts.outfit(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Map<String, dynamic>> _getMockHistory() {
    return [
      {
        'room': 'Dago Branch',
        'date': '26 Mei 2026',
        'messageCount': 45,
        'lastMessage': 'Manager: Ok semua hadir ya',
      },
      {
        'room': 'Dipatiukur Branch',
        'date': '26 Mei 2026',
        'messageCount': 32,
        'lastMessage': 'Rudi: Siap pak',
      },
      {
        'room': 'All Staff',
        'date': '25 Mei 2026',
        'messageCount': 78,
        'lastMessage': 'Owner: Libur tanggal 17',
      },
      {
        'room': 'Pasteur Branch',
        'date': '25 Mei 2026',
        'messageCount': 23,
        'lastMessage': 'Siti: Stock kopi habis',
      },
    ];
  }
}
