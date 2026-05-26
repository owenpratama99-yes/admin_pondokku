import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';
import '../../../core/constants.dart';

class TaskReviewScreen extends StatefulWidget {
  const TaskReviewScreen({super.key});

  @override
  State<TaskReviewScreen> createState() => _TaskReviewScreenState();
}

class _TaskReviewScreenState extends State<TaskReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Simulated submissions data
  final List<Map<String, dynamic>> _submissions = [
    {
      'id': 'sub-001',
      'employee': 'Budi Santoso',
      'role': 'Barista - Cabang Dago',
      'task': 'Deep Clean Mesin Espresso La Marzocco',
      'points': 150,
      'submittedAt': '23 Mei 2026, 21:15',
      'notes':
          'Sudah selesai dibersihkan bagian group head, steam wand, dan tray bawah. Backflush obat pembersih juga sudah dilakukan.',
      'status': 'pending',
      'image': 'assets/images/espresso_cleaning.png',
    },
    {
      'id': 'sub-002',
      'employee': 'Siti Rahma',
      'role': 'Kitchen - Cabang Dipatiukur',
      'task': 'Prep Bahan Signature Mocktail (Coffee Brew)',
      'points': 100,
      'submittedAt': '23 Mei 2026, 20:30',
      'notes':
          'Persiapan cold brew batch baru untuk signature menu es kopi susu madju. Stok cukup untuk 2 hari kedepan.',
      'status': 'pending',
      'image': 'assets/images/cold_brew_prep.png',
    },
    {
      'id': 'sub-003',
      'employee': 'Andi Wijaya',
      'role': 'Server - Cabang Pasteur',
      'task': 'Restock & Rapikan Shelf Biji Kopi (Retail)',
      'points': 75,
      'submittedAt': '23 Mei 2026, 18:45',
      'notes':
          'Display depan sudah full. House blend medium roast 10 pack, Flores Bajawa 8 pack, Mandheling 5 pack.',
      'status': 'approved',
      'image': 'assets/images/shelf_restock.png',
    },
    {
      'id': 'sub-004',
      'employee': 'Dewi Lestari',
      'role': 'Barista - Cabang Dago',
      'task': 'Kalibrasi Espresso Espresso Grind Size & Yield',
      'points': 120,
      'submittedAt': '23 Mei 2026, 07:05',
      'notes':
          'Kalibrasi pagi. Espresso yield 36gr dari 18gr coffee in. Time 28s. Taste profile balance sweet-acidity.',
      'status': 'approved',
      'image': 'assets/images/calibration.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleApproval(String id, bool approved) {
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

    setState(() {
      final index = _submissions.indexWhere((sub) => sub['id'] == id);
      if (index != -1) {
        _submissions[index]['status'] = approved ? 'approved' : 'rejected';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              approved ? Icons.check_circle : Icons.cancel,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              approved
                  ? 'Tugas berhasil DISETUJUI & poin ditambahkan!'
                  : 'Tugas telah DITOLAK untuk revisi.',
              style: GoogleFonts.outfit(),
            ),
          ],
        ),
        backgroundColor: approved ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingList =
        _submissions.where((sub) => sub['status'] == 'pending').toList();
    final approvedList =
        _submissions.where((sub) => sub['status'] == 'approved').toList();
    final rejectedList =
        _submissions.where((sub) => sub['status'] == 'rejected').toList();

    return ManagerScaffold(
      title: 'Review Tugas Pegawai',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header stats
            Row(
              children: [
                _buildStatMiniCard('Menunggu', '${pendingList.length} Tugas',
                    AppColors.secondary, AppColors.secondarySurface),
                const SizedBox(width: 16),
                _buildStatMiniCard('Disetujui', '${approvedList.length} Tugas',
                    AppColors.success, AppColors.successSurface),
                const SizedBox(width: 16),
                _buildStatMiniCard('Ditolak', '${rejectedList.length} Tugas',
                    AppColors.error, AppColors.errorSurface),
              ],
            ),
            const SizedBox(height: 24),

            // Tab bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600, fontSize: 14),
                unselectedLabelStyle: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500, fontSize: 14),
                tabs: const [
                  Tab(text: 'Perlu Review'),
                  Tab(text: 'Disetujui'),
                  Tab(text: 'Ditolak / Revisi'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab contents
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSubmissionsList(pendingList, true),
                  _buildSubmissionsList(approvedList, false),
                  _buildSubmissionsList(rejectedList, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatMiniCard(String label, String value, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionsList(List<Map<String, dynamic>> items, bool isPending) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined,
                size: 64, color: AppColors.textMuted.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pengajuan tugas di kategori ini',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (isPending) {
      return _TinderSwipeDeck(
        items: items,
        onReview: _handleApproval,
      );
    }

    // Historical scroll list for Approved and Rejected tabs
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final sub = items[index];
        final isApproved = sub['status'] == 'approved';
        final statusColor = isApproved ? AppColors.success : AppColors.error;
        final statusBg = isApproved ? AppColors.successSurface : AppColors.errorSurface;

        return Card(
          elevation: 2,
          shadowColor: AppColors.primaryDark.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mini Camera Preview Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.photo_camera_rounded,
                    color: AppColors.textMuted,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              sub['task'],
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isApproved ? 'DISETUJUI' : 'DITOLAK',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Diajukan oleh: ${sub['employee']} (${sub['role']})',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Catatan: "${sub['notes']}"',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Tinder Style Swipable Card Deck ─────────────────────────────────────────
class _TinderSwipeDeck extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function(String id, bool approved) onReview;
  const _TinderSwipeDeck({required this.items, required this.onReview});

  @override
  State<_TinderSwipeDeck> createState() => _TinderSwipeDeckState();
}

class _TinderSwipeDeckState extends State<_TinderSwipeDeck> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  double _swipeOffset = 0.0;
  late AnimationController _animController;
  late Animation<double> _swipeAnimation;
  bool? _dragApproved; // null = none, true = right, false = left

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _swipe(bool approved) {
    if (_currentIndex >= widget.items.length) return;
    setState(() {
      _dragApproved = approved;
    });
    
    _swipeAnimation = Tween<double>(
      begin: _swipeOffset,
      end: approved ? 600.0 : -600.0,
    ).animate(_animController)
      ..addListener(() {
        setState(() {
          _swipeOffset = _swipeAnimation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          final swipedItem = widget.items[_currentIndex];
          widget.onReview(swipedItem['id'], approved);
          
          setState(() {
            _swipeOffset = 0.0;
            _currentIndex++;
            _dragApproved = null;
          });
          _animController.reset();
        }
      });

    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.items.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.successSurface,
              child: Icon(Icons.celebration, color: AppColors.success, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Semua Tugas Selesai Direview!',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kerja bagus! Seluruh pengajuan cabang Anda bersih.',
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final topItem = widget.items[_currentIndex];
    final nextItem = _currentIndex + 1 < widget.items.length ? widget.items[_currentIndex + 1] : null;

    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate rotation angle based on swipe offset
    final rotation = (_swipeOffset / (screenWidth > 0 ? screenWidth : 500)) * 0.3; // radians
    
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 580,
              height: 440,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Next Card (background placeholder)
                  if (nextItem != null)
                    Transform.scale(
                      scale: 0.95,
                      child: Opacity(
                        opacity: 0.6,
                        child: _TinderCardContent(item: nextItem),
                      ),
                    ),
                  
                  // Top Card (swipable)
                  GestureDetector(
                    onPanStart: (_) {},
                    onPanUpdate: (details) {
                      setState(() {
                        _swipeOffset += details.delta.dx;
                        if (_swipeOffset > 40) {
                          _dragApproved = true;
                        } else if (_swipeOffset < -40) {
                          _dragApproved = false;
                        } else {
                          _dragApproved = null;
                        }
                      });
                    },
                    onPanEnd: (details) {
                      if (_swipeOffset.abs() > 120) {
                        // Swipe away!
                        _swipe(_swipeOffset > 0);
                      } else {
                        // Bounce back!
                        _animController.reset();
                        final double startOffset = _swipeOffset;
                        final Animation<double> bounceAnim = Tween<double>(begin: startOffset, end: 0.0)
                            .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutBack));
                        
                        bounceAnim.addListener(() {
                          setState(() {
                            _swipeOffset = bounceAnim.value;
                          });
                        });
                        
                        _animController.forward(from: 0.0).then((_) {
                          setState(() {
                            _swipeOffset = 0.0;
                            _dragApproved = null;
                          });
                        });
                      }
                    },
                    child: Transform.translate(
                      offset: Offset(_swipeOffset, 0),
                      child: Transform.rotate(
                        angle: rotation,
                        child: Stack(
                          children: [
                            _TinderCardContent(item: topItem),
                            
                            // Swipe Stamps overlay
                            if (_dragApproved != null)
                              Positioned(
                                top: 40,
                                left: _dragApproved! ? 40 : null,
                                right: _dragApproved! ? null : 40,
                                child: Transform.rotate(
                                  angle: _dragApproved! ? -0.2 : 0.2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _dragApproved! ? AppColors.success : AppColors.error,
                                        width: 4,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white.withOpacity(0.95),
                                    ),
                                    child: Text(
                                      _dragApproved! ? 'APPROVE' : 'REJECT',
                                      style: GoogleFonts.outfit(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: _dragApproved! ? AppColors.success : AppColors.error,
                                      ),
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
          ),
        ),
        
        // Circular quick action buttons at the bottom of the card stack
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reject Button (Red Cross)
              _buildRoundActionButton(
                icon: Icons.close_rounded,
                color: AppColors.error,
                onTap: () => _swipe(false),
                tooltip: 'Reject (Swipe Kiri)',
              ),
              const SizedBox(width: 32),
              Text(
                'Geser kartu atau gunakan tombol aksi',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(width: 32),
              // Approve Button (Green Check)
              _buildRoundActionButton(
                icon: Icons.check_rounded,
                color: AppColors.success,
                onTap: () => _swipe(true),
                tooltip: 'Approve (Swipe Kanan)',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoundActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white,
        shape: CircleBorder(side: BorderSide(color: color.withOpacity(0.3), width: 1.5)),
        elevation: 4,
        shadowColor: color.withOpacity(0.2),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
      ),
    );
  }
}

// ─── Tinder Card Content ─────────────────────────────────────────────────────
class _TinderCardContent extends StatelessWidget {
  final Map<String, dynamic> item;
  const _TinderCardContent({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.primaryDark.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.border, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // Upper part: Cam Proof Image simulated
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2C1810), Color(0xFF1E0F08)],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Simulated photo texture
                    Opacity(
                      opacity: 0.15,
                      child: Icon(
                        Icons.coffee_maker_rounded,
                        size: 120,
                        color: AppColors.secondary.withOpacity(0.5),
                      ),
                    ),
                    // Elegant image mock frame
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.photo_camera, color: AppColors.secondary, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'BUKTI FOTO KAMERA (SOP)',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Points bubble
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars, color: Colors.white, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              '+${item['points']} pts',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Lower part: Task details
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['task'],
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item['employee']} · ${item['role']}',
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Catatan karyawan
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            item['notes'],
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
