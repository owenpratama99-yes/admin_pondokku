import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Poin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: const NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'), // Subtle pattern
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.1),
                      BlendMode.dstIn,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Poin Saat Ini',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '850',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.account_balance_wallet,
                      size: 48,
                      color: AppColors.secondary.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Bulan Ini (Mei 2024)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final isPositive = index % 3 != 0; // Fake some negative values
                final txId = 'TX-MD-260524-${9820 - index}';
                
                String category = 'SOP Tugas';
                String authorizedBy = 'Manager Budi';
                String title = 'Tugas Selesai (Lap Meja)';
                IconData icon = Icons.task_alt;
                
                if (!isPositive) {
                  if (index % 6 == 0) {
                    category = 'Tilang Manual';
                    authorizedBy = 'Manager Owen';
                    title = 'Seragam Tidak Sesuai SOP';
                    icon = Icons.warning_amber_rounded;
                  } else {
                    category = 'Denda Absensi';
                    authorizedBy = 'Sistem Smart-GPS';
                    title = 'Keterlambatan (15 menit)';
                    icon = Icons.location_off_outlined;
                  }
                } else {
                  if (index % 4 == 0) {
                    category = 'Manual Reward';
                    authorizedBy = 'Owner Owen';
                    title = 'Service Excellence Pelanggan';
                    icon = Icons.military_tech_rounded;
                  } else {
                    category = 'SOP Tugas';
                    authorizedBy = 'Sistem HRIS';
                    title = 'Bersih-bersih Mesin Kopi';
                    icon = Icons.coffee_maker_rounded;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: isPositive ? AppColors.successSurface : AppColors.errorSurface,
                                child: Icon(
                                  icon,
                                  size: 18,
                                  color: isPositive ? AppColors.success : AppColors.error,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceVariant,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            category,
                                            style: GoogleFonts.outfit(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${24 - (index ~/ 2)} Mei 2026',
                                          style: GoogleFonts.outfit(
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                isPositive ? '+15' : '-10',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isPositive ? AppColors.success : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16, color: AppColors.divider),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ref: $txId',
                                style: GoogleFonts.outfit(
                                  fontSize: 10.5,
                                  color: AppColors.textMuted,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.verified_user_outlined, size: 10, color: AppColors.secondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Otorisasi: $authorizedBy',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: 15, // Dummy data count
            ),
          ),
        ],
      ),
    );
  }
}
