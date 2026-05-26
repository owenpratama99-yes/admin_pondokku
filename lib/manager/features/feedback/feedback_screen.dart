import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/feedback_model.dart';
import '../../widgets/manager_scaffold.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _selectedBranch = 'ALL';
  String _selectedRating = 'ALL';

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Customer Feedback',
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildFeedbackList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final feedbacks = _getMockFeedbacks();
    final avgRating = feedbacks.fold<double>(0, (sum, f) => sum + f.rating) / feedbacks.length;

    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Avg Rating', avgRating.toStringAsFixed(1), Icons.star, AppColors.secondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('Total', '${feedbacks.length}', Icons.feedback, AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('Pending', '${feedbacks.where((f) => f.response == null).length}', Icons.pending, AppColors.warning),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('Responded', '${feedbacks.where((f) => f.response != null).length}', Icons.check_circle, AppColors.success),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary),
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
            child: DropdownButtonFormField<String>(
              value: _selectedRating,
              decoration: const InputDecoration(labelText: 'Rating'),
              items: ['ALL', '5 Stars', '4 Stars', '3 Stars', '2 Stars', '1 Star']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedRating = v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackList() {
    final feedbacks = _getMockFeedbacks();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: feedbacks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildFeedbackCard(feedbacks[index]);
      },
    );
  }

  Widget _buildFeedbackCard(CustomerFeedback feedback) {
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
              CircleAvatar(
                backgroundColor: AppColors.primarySurface,
                child: Text(
                  feedback.customerName.substring(0, 1),
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
                      feedback.customerName,
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${feedback.branchName} • ${_formatDate(feedback.createdAt)}',
                      style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < feedback.rating ? Icons.star : Icons.star_border,
                  color: AppColors.secondary,
                  size: 18,
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            feedback.description,
            style: GoogleFonts.outfit(fontSize: 14, height: 1.6),
          ),
          if (feedback.response != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.successSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.reply, size: 16, color: AppColors.success),
                      const SizedBox(width: 8),
                      Text(
                        'Response:',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feedback.response ?? '',
                    style: GoogleFonts.outfit(fontSize: 13),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Respond to feedback')),
                );
              },
              icon: const Icon(Icons.reply, size: 18),
              label: const Text('Respond'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<CustomerFeedback> _getMockFeedbacks() {
    return [
      CustomerFeedback(
        id: 'FB001',
        customerName: 'John Doe',
        branchId: 'BR001',
        branchName: 'Dago',
        category: 'Service',
        description: 'Pelayanan sangat baik! Kopi enak dan barista ramah.',
        rating: 5,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'RESPONDED',
        response: 'Terima kasih atas feedback positifnya! Kami senang Anda menikmati kopi kami.',
        respondedAt: DateTime.now().subtract(const Duration(hours: 1)),
        respondedBy: 'MGR001',
      ),
      CustomerFeedback(
        id: 'FB002',
        customerName: 'Jane Smith',
        branchId: 'BR002',
        branchName: 'Dipatiukur',
        category: 'Service',
        description: 'Kopinya enak tapi agak lama nunggu',
        rating: 4,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: 'PENDING',
      ),
      CustomerFeedback(
        id: 'FB003',
        customerName: 'Ahmad',
        branchId: 'BR001',
        branchName: 'Dago',
        category: 'Facility',
        description: 'Tempat nyaman, wifi cepat, cocok untuk kerja',
        rating: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: 'RESPONDED',
        response: 'Senang mendengarnya! Terima kasih sudah berkunjung.',
        respondedAt: DateTime.now().subtract(const Duration(hours: 20)),
        respondedBy: 'MGR001',
      ),
    ];
  }
}
