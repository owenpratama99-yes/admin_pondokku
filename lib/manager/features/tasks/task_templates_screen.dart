import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/task_template_model.dart';
import '../../widgets/manager_scaffold.dart';

class TaskTemplatesScreen extends StatelessWidget {
  const TaskTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Task Templates',
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildTemplatesList()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                  'Task Templates',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Template tugas untuk efisiensi operasional',
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create template')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Buat Template'),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesList() {
    final templates = _getMockTemplates();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: templates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildTemplateCard(templates[index]);
      },
    );
  }

  Widget _buildTemplateCard(TaskTemplate template) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.task_alt, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.title,
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      template.category,
                      style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              if (template.isRecurring)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.infoSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.repeat, size: 14, color: AppColors.info),
                      const SizedBox(width: 4),
                      Text(
                        'Recurring',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            template.description,
            style: GoogleFonts.outfit(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.stars, '+${template.pointValue} pts', AppColors.success),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.assignment, size: 18),
                label: const Text('Assign'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 12, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  List<TaskTemplate> _getMockTemplates() {
    return [
      TaskTemplate(
        id: 'TT001',
        title: 'Opening Checklist',
        description: 'Checklist pembukaan toko: cek inventory, nyalakan mesin, bersihkan area',
        category: 'Opening',
        pointValue: 20,
        isRecurring: true,
        recurrencePattern: 'DAILY',
      ),
      TaskTemplate(
        id: 'TT002',
        title: 'Closing Checklist',
        description: 'Checklist penutupan toko: hitung kas, bersihkan mesin, matikan lampu',
        category: 'Closing',
        pointValue: 25,
        isRecurring: true,
        recurrencePattern: 'DAILY',
      ),
      TaskTemplate(
        id: 'TT003',
        title: 'Weekly Deep Clean',
        description: 'Pembersihan menyeluruh area toko dan storage',
        category: 'Cleaning',
        pointValue: 50,
        isRecurring: true,
        recurrencePattern: 'WEEKLY',
      ),
      TaskTemplate(
        id: 'TT004',
        title: 'Inventory Count',
        description: 'Hitung stock semua item inventory',
        category: 'Inventory',
        pointValue: 30,
        isRecurring: true,
        recurrencePattern: 'WEEKLY',
      ),
    ];
  }
}
