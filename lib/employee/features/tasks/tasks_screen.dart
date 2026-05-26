import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final _tasks = [
    const _Task(
      id: 1,
      title: 'Bersih-bersih area meja',
      desc: 'Lap semua meja dan kursi area indoor',
      deadline: '23 Mei 2024',
      status: TaskStatus.pending,
      points: 10,
    ),
    const _Task(
      id: 2,
      title: 'Stok bahan baku',
      desc: 'Cek dan lapor stok kopi, susu, dan sirup',
      deadline: '23 Mei 2024',
      status: TaskStatus.pending,
      points: 15,
    ),
    const _Task(
      id: 3,
      title: 'Briefing pagi',
      desc: 'Ikut briefing rutin pagi bersama tim',
      deadline: '22 Mei 2024',
      status: TaskStatus.approved,
      points: 5,
    ),
    const _Task(
      id: 4,
      title: 'Laporan harian',
      desc: 'Buat dan submit laporan penjualan harian',
      deadline: '21 Mei 2024',
      status: TaskStatus.rejected,
      points: 20,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tugas Saya'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.secondary,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Disetujui'),
            Tab(text: 'Ditolak'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _TaskList(
            tasks: _tasks.where((t) => t.status == TaskStatus.pending).toList(),
          ),
          _TaskList(
            tasks:
                _tasks.where((t) => t.status == TaskStatus.approved).toList(),
          ),
          _TaskList(
            tasks:
                _tasks.where((t) => t.status == TaskStatus.rejected).toList(),
          ),
        ],
      ),
    );
  }
}

enum TaskStatus { pending, approved, rejected }

class _Task {
  final int id;
  final String title, desc, deadline;
  final TaskStatus status;
  final int points;
  const _Task({
    required this.id,
    required this.title,
    required this.desc,
    required this.deadline,
    required this.status,
    required this.points,
  });
}

class _TaskList extends StatelessWidget {
  final List<_Task> tasks;
  const _TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_alt, size: 56, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              'Tidak ada tugas',
              style:
                  GoogleFonts.outfit(fontSize: 16, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _TaskCard(task: tasks[i]),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final _Task task;
  const _TaskCard({required this.task});

  Color get _statusColor {
    switch (task.status) {
      case TaskStatus.pending:
        return AppColors.secondary;
      case TaskStatus.approved:
        return AppColors.success;
      case TaskStatus.rejected:
        return AppColors.error;
    }
  }

  String get _statusLabel {
    switch (task.status) {
      case TaskStatus.pending:
        return 'Menunggu';
      case TaskStatus.approved:
        return 'Disetujui';
      case TaskStatus.rejected:
        return 'Ditolak';
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(task.desc, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                task.deadline,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              const Icon(Icons.stars_rounded,
                  size: 14, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text(
                '+${task.points} pts',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          if (task.status == TaskStatus.pending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showSubmitDialog(context),
                    icon: const Icon(Icons.upload_file, size: 16),
                    label: const Text('Submit'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SubmitTaskSheet(taskTitle: task.title),
    );
  }
}

class _SubmitTaskSheet extends StatefulWidget {
  final String taskTitle;
  const _SubmitTaskSheet({required this.taskTitle});

  @override
  State<_SubmitTaskSheet> createState() => _SubmitTaskSheetState();
}

class _SubmitTaskSheetState extends State<_SubmitTaskSheet> {
  final _noteCtrl = TextEditingController();
  bool _hasPhoto = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Submit Tugas',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(widget.taskTitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),

          // Photo upload
          GestureDetector(
            onTap: () => setState(() => _hasPhoto = !_hasPhoto),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hasPhoto ? AppColors.success : AppColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _hasPhoto ? Icons.check_circle : Icons.camera_alt_outlined,
                    size: 32,
                    color: _hasPhoto ? AppColors.success : AppColors.textMuted,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _hasPhoto ? 'Foto terpilih' : 'Tap untuk ambil foto',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color:
                          _hasPhoto ? AppColors.success : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _noteCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Catatan (opsional)',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Kirim Tugas'),
            ),
          ),
        ],
      ),
    );
  }
}
