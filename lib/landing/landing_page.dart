import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _fadeController;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late Animation<double> _contentFade;

  String _selectedGalleryCategory = 'Semua';
  int _selectedBranchIndex = 0;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _heroFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOut),
    );
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );
    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── HERO SECTION ────────────────────────────────────────
            _buildHeroSection(size, isWide),

            // ─── TAGLINE STRIP ───────────────────────────────────────
            _buildTaglineStrip(),

            // ─── BRAND STORY / ABOUT US ──────────────────────────────
            _buildBrandStorySection(isWide),

            // ─── MENU HIGHLIGHTS ─────────────────────────────────────
            _buildMenuSection(isWide),

            // ─── PORTAL LOGIN ────────────────────────────────────────
            _buildPortalSection(isWide),

            // ─── GALLERY ─────────────────────────────────────────────
            _buildGallerySection(isWide),

            // ─── LOCATION & CONTACT ──────────────────────────────────
            _buildLocationSection(isWide),

            // ─── FOOTER ──────────────────────────────────────────────
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ─── HERO ──────────────────────────────────────────────────────────────
  Widget _buildHeroSection(Size size, bool isWide) {
    return Container(
      height: size.height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A0F09), // Very dark espresso
            Color(0xFF2C1810), // Espresso
            Color(0xFF3D2010), // Warm dark brown
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(painter: _CoffeePatternPainter()),
          ),

          // Decorative gold circle
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: FadeTransition(
                opacity: _heroFade,
                child: SlideTransition(
                  position: _heroSlide,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo / Brand mark
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.secondary.withOpacity(0.5),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'EST · TRENGGALEK',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                            letterSpacing: 3.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Main headline
                      Text(
                        'Madju Djaja Group',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isWide ? 96 : 64,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 0.95,
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Gold divider
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 1,
                            color: AppColors.secondary,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 1,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Subtitle
                      Text(
                        'Where Every Cup Tells a Story',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: isWide ? 24 : 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.75),
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // CTA Buttons
                      FadeTransition(
                        opacity: _contentFade,
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            _GoldButton(
                              label: 'Portal Pegawai',
                              icon: Icons.person_outline,
                              onTap: () => context.go('/employee/login'),
                            ),
                            _OutlineButton(
                              label: 'Portal Manajer',
                              icon: Icons.manage_accounts_outlined,
                              onTap: () => context.go('/manager/login'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Scroll indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _contentFade,
              child: Column(
                children: [
                  Text(
                    'SCROLL',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      letterSpacing: 3,
                      color: Colors.white.withOpacity(0.4),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ScrollIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── TAGLINE STRIP ─────────────────────────────────────────────────────
  Widget _buildTaglineStrip() {
    final items = [
      'Kopi Spesialti',
      '✦',
      'Makanan Artisan',
      '✦',
      '4 Cabang',
      '✦',
      'Pelayanan Prima',
      '✦',
    ];

    return Container(
      color: AppColors.secondary,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            items.length * 3,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                items[i % items.length],
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── BRAND STORY / ABOUT US ─────────────────────────────────────────────
  Widget _buildBrandStorySection(bool isWide) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 90,
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final showSideBySide = isWide && width > 800;

              return Flex(
                direction: showSideBySide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Sisi Kiri: Story Image / Visual Frame
                  Expanded(
                    flex: showSideBySide ? 1 : 0,
                    child: Container(
                      height: 420,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Background card layer (gold frame)
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.secondary, width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          // Main Image layer (uses our coffee_moment or cafe_interior asset nicely)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 20,
                            bottom: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/coffee_moment.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFF1E0F08),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: AppColors.secondary, width: 1.5),
                                              color: Colors.white.withOpacity(0.03),
                                            ),
                                            child: const Icon(
                                              Icons.coffee_rounded,
                                              color: AppColors.secondary,
                                              size: 56,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'MADJU DJAJA STORY',
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.secondary,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Overlay vision tag
                          Positioned(
                            bottom: 40,
                            left: 24,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.secondary.withOpacity(0.5)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.favorite_rounded, color: AppColors.secondary, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Dibuat Dengan Cinta',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
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
                  if (showSideBySide) const SizedBox(width: 80) else const SizedBox(height: 48),

                  // Sisi Kanan: Narrative & Commitments
                  Expanded(
                    flex: showSideBySide ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'ABOUT US · DEDIKASI KAMI',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryDark,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Menyulam Kisah Kopi & Kehangatan Trenggalek',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Madju Djaja Group lahir dari gairah mendalam untuk mengangkat cita rasa autentik biji kopi pegunungan lokal Trenggalek langsung ke meja Anda.',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Dedikasi kami bermula dari proses kurasi ketat bersama kelompok tani lokal, diikuti pemanggangan higienis di roastery utama kami, hingga disajikan dengan senyum tulus oleh barista kami. Kami percaya, kopi terbaik tidak hanya memuaskan indra pengecap, namun juga membangun ikatan emosional dan menghidupkan ruang kolaborasi kreatif.',
                          style: GoogleFonts.outfit(
                            fontSize: 14.5,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Values icons panel
                        _buildStoryValueTile(
                          icon: Icons.eco_outlined,
                          title: '100% Biji Kopi Trenggalek Lokal',
                          desc: 'Bekerja langsung dengan petani lokal untuk memberdayakan ekonomi daerah dan menjaga kelestarian cita rasa khas pegunungan kita.',
                        ),
                        const SizedBox(height: 20),
                        _buildStoryValueTile(
                          icon: Icons.clean_hands_outlined,
                          title: 'Standar Kebersihan Higienis Mutlak',
                          desc: 'Protokol kebersihan steril dari roastery hingga penyajian cangkir Anda, menjamin kenyamanan nongkrong yang aman tanpa rasa khawatir.',
                        ),
                        const SizedBox(height: 20),
                        _buildStoryValueTile(
                          icon: Icons.stars_outlined,
                          title: 'Standar Pelayanan Prima (Prime Service)',
                          desc: 'Setiap kru kami dilatih untuk menghadirkan keramahan tulus khas Trenggalek untuk menciptakan ikatan emosional seperti rumah kedua Anda.',
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoryValueTile({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
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
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── MENU SECTION ──────────────────────────────────────────────────────
  Widget _buildMenuSection(bool isWide) {
    final menuItems = [
      const _MenuItem(
        name: 'Madju Djaja',
        desc:
            'Perpaduan biji kopi pilihan dengan seduhan barista bersertifikat.',
        price: 'Spesialti Espresso',
        icon: Icons.coffee_rounded,
        color: Color(0xFF2C1810),
      ),
      const _MenuItem(
        name: 'Warkop Moro-Moro',
        desc:
            'Nuansa kehangatan warkop tradisional dengan cita rasa khas Nusantara.',
        price: 'Kopi Tubruk & Jajanan',
        icon: Icons.storefront_rounded,
        color: Color(0xFF4A2C1E),
      ),
      const _MenuItem(
        name: 'Ruang Luang',
        desc:
            'Ruang kolaborasi kreatif untuk bekerja dan menikmati sore yang tenang.',
        price: 'Chill Space & Brew',
        icon: Icons.weekend_rounded,
        color: Color(0xFF3D2010),
      ),
      const _MenuItem(
        name: 'Ammor Coffe',
        desc:
            'Eksplorasi kreasi rasa baru dalam segelas kopi mocktail yang menyegarkan.',
        price: 'Mocktail Coffee & Artisan',
        icon: Icons.auto_awesome_rounded,
        color: Color(0xFF1E0F08),
      ),
    ];

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          // Section header
          Text(
            'Cafe Unggulan Kami',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Empat destinasi kopi terbaik dengan cita rasa khas dan suasana autentik di Trenggalek',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 2,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 48),

          // Menu grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide ? 4 : 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: isWide ? 0.8 : 0.85,
            ),
            itemCount: menuItems.length,
            itemBuilder: (ctx, i) => _MenuCard(item: menuItems[i]),
          ),
        ],
      ),
    );
  }

  // ─── PORTAL SECTION ────────────────────────────────────────────────────
  Widget _buildPortalSection(bool isWide) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C1810),
            Color(0xFF1A0F09),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Portal Sistem',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Akses sistem manajemen SDM Madju Djaja',
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 48),
          const Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _PortalCard(
                title: 'Portal Pegawai',
                subtitle: 'Absensi, Tugas & Poin Anda',
                icon: Icons.badge_outlined,
                features: [
                  'Absensi Check-in / Check-out',
                  'Submit & Pantau Tugas',
                  'Riwayat Poin Reward',
                ],
                buttonLabel: 'Masuk sebagai Pegawai',
                route: '/employee/login',
                isGold: true,
              ),
              _PortalCard(
                title: 'Portal Manajer',
                subtitle: 'Dashboard & Manajemen Tim',
                icon: Icons.admin_panel_settings_outlined,
                features: [
                  'Executive Dashboard 4 Cabang',
                  'Review & Approve Tugas',
                  'Kelola Poin & SP Pegawai',
                ],
                buttonLabel: 'Masuk sebagai Manajer',
                route: '/manager/login',
                isGold: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── GALLERY SECTION ───────────────────────────────────────────────────
  // Data for Instagram grid
  final List<Map<String, dynamic>> _galleryData = [
    {
      'title': 'Spot Jendela Madju Djaja',
      'subtitle': 'Sudut terindah dengan pencahayaan hangat alami.',
      'image': 'assets/images/cafe_interior.png',
      'category': 'Spot Estetik',
      'likes': 1248,
      'commentsCount': 45,
      'time': '2 jam yang lalu',
      'caption':
          'Nugas seharian di spot jendela Madju Djaja emang ga pernah gagal! Kursi ergonomis, Wi-Fi kenceng, plus Es Kopi Susu Aren andalan. Siapa nih yang spot favoritnya di sini juga? 🙋‍♂️✨\n\n#madjudjaja #coffeeshop #trenggalekhitz #workfromcafe',
      'comments': [
        {
          'user': 'dian_lestari',
          'text': 'Spot favorit aku banget ini buat nugas! 😍'
        },
        {
          'user': 'budi_setiawan',
          'text': 'Es Kopi Susunya emang juara sih, ga manis lebay.'
        },
        {
          'user': 'rizal_adit',
          'text': 'Baristanya ramah, kemarin dipinjemin colokan tambahan.'
        }
      ]
    },
    {
      'title': 'Presisi Seduhan Manual',
      'subtitle': 'Dedikasi barista kami menyeduh kebahagiaan.',
      'image': 'assets/images/barista_art.png',
      'category': 'Barista & Seduhan',
      'likes': 982,
      'commentsCount': 28,
      'time': '5 jam yang lalu',
      'caption':
          'Bagi kami, kopi yang nikmat berawal dari ketulusan hati barista. Setiap tetes diseduh dengan presisi suhu dan rasio terbaik untuk menghasilkan cita rasa sempurna. Sapa barista kami dan temukan rekomendasi beans favoritmu hari ini! ☕️🤝\n\n#baristalife #manualbrew #specialtycoffee #moromoro #ruangluang',
      'comments': [
        {
          'user': 'kopi_enthusiast',
          'text': 'V60 Ethiopianya kemarin dapet note floral bgt! Mantap.'
        },
        {
          'user': 'siti_rahma',
          'text': 'Senyum baristanya bikin kopinya makin manis wkwk'
        },
        {
          'user': 'joko_tri',
          'text': 'Edukasi kopinya oke bgt, dijelasin detail.'
        }
      ]
    },
    {
      'title': 'Keceriaan di Ruang Luang',
      'subtitle': 'Canda tawa hangat pengunjung menikmati sore.',
      'image': 'assets/images/coffee_moment.png',
      'category': 'Keceriaan Pengunjung',
      'likes': 1530,
      'commentsCount': 62,
      'time': '1 hari yang lalu',
      'caption':
          'Momen terbaik adalah saat berkumpul bersama sahabat, berbagi cerita sembari menikmati cangkir kopi favorit. Terima kasih sudah meramaikan Ruang Luang dan menjadikannya saksi bisu tawa ceria kalian! Ditunggu kedatangannya lagi ya! 💛🍰\n\n#coffeeandfriends #cafeaesthetic #trenggalek #ruangluang',
      'comments': [
        {
          'user': 'geng_nugas',
          'text': 'Tempat kumpul paling cozy di Trenggalek sih ini.'
        },
        {
          'user': 'lisa_black',
          'text': 'Kemarin ultah di sini seru bgt dibantuin dekor sama stafnya!'
        },
        {
          'user': 'doni_hermawan',
          'text': 'Croissant-nya juara, anget pas disajiin.'
        }
      ]
    },
    {
      'title': 'Sudut Estetik Ammor Coffe',
      'subtitle': 'Estetika kaca modern bertema industrial minimalis.',
      'image': 'assets/images/cafe_interior.png',
      'category': 'Spot Estetik',
      'likes': 742,
      'commentsCount': 18,
      'time': '2 hari yang lalu',
      'caption':
          'Glasshouse vibes at Ammor Coffe! 🌿 Lokasi pas buat kamu yang cari background estetik buat OOTD atau sekedar cari inspirasi segar di sore hari. Jangan lupa pesan Passion Mocktail biar makin fresh!\n\n#ammorcoffee #industrialdesign #aestheticcafe #exploretrenggalek',
      'comments': [
        {'user': 'ootd_indo', 'text': 'Foto di sini auto estetik feed IG ku!'},
        {
          'user': 'hendra_w',
          'text': 'Mocktail kopinya seger parah pas siang terik.'
        },
        {'user': 'rara_99', 'text': 'Spot ootd andalan cewek-cewek Trenggalek.'}
      ]
    },
    {
      'title': 'Seni Latte Art Swan',
      'subtitle': 'Sentuhan estetika di setiap cangkir cappuccino.',
      'image': 'assets/images/barista_art.png',
      'category': 'Barista & Seduhan',
      'likes': 896,
      'commentsCount': 34,
      'time': '3 hari yang lalu',
      'caption':
          'A cup of warm cappuccino to brighten your rainy afternoon. Barista kami melukis setiap cangkir dengan penuh cinta. Yang mana pattern favoritmu? Swan atau Tulip? 🦢🌷\n\n#latteart #cappuccino #coffeegram #baristaart',
      'comments': [
        {
          'user': 'latte_art_lover',
          'text': 'Swannya rapi bgt! Ga tega diminum haha.'
        },
        {'user': 'toni_p', 'text': 'Cappuccinonya bold tapi creamy, pas bgt.'},
        {
          'user': 'nita_cantik',
          'text': 'Selalu request pattern kucing kalo kesini haha.'
        }
      ]
    },
    {
      'title': 'Malam Akrab Moro-Moro',
      'subtitle': 'Kehangatan obrolan warkop 24 jam nonstop.',
      'image': 'assets/images/coffee_moment.png',
      'category': 'Keceriaan Pengunjung',
      'likes': 1120,
      'commentsCount': 41,
      'time': '4 hari yang lalu',
      'caption':
          'Malam makin larut, obrolan makin hangat di Moro-Moro. Tempat terbaik buat nobar, mabar, atau sekadar melepas penat setelah seharian beraktivitas dengan kopi tubruk legendaris dan aneka jajanan gorengan hangat. 🌙🍟\n\n#warkop24jam #moromoro #kopitubruk #angkringan #trenggalekmalam',
      'comments': [
        {
          'user': 'mabar_terus',
          'text': 'Tempat nggame sampe subuh paling aman wkwk.'
        },
        {
          'user': 'tempe_mendoan',
          'text': 'Gorengan anget sama sambel kecapnya juara!'
        },
        {
          'user': 'wahyu_eko',
          'text': 'Kopi tubruknya mantep bikin melek semalaman.'
        }
      ]
    }
  ];

  // Data for Café branches
  final List<Map<String, dynamic>> _branchesData = [
    {
      'name': 'Madju Djaja',
      'type': 'Cabang Utama / Roastery',
      'address':
          'Jl. Diponegoro, Krajan, Surodakan, Kec. Trenggalek, Kabupaten Trenggalek, Jawa Timur 66316',
      'hours': 'Setiap Hari: 08:00 - 23:00 WIB',
      'phone': '+62 812-3456-7890',
      'instagram': '@madju.djaja',
      'desc':
          'Pusat roastery premium kami dengan seduhan manual slow-bar terlengkap dan biji kopi pilihan nusantara.',
      'mapOffset': const Offset(0, 0),
      'color': const Color(0xFF2C1810),
    },
    {
      'name': 'Warkop Moro-Moro',
      'type': 'Cabang Selatan / Warkop Modern',
      'address':
          'Jl. DR. Sutomo, Dobangsan, Ngantru, Kec. Trenggalek, Kabupaten Trenggalek, Jawa Timur 66311',
      'hours': 'Setiap Hari: 24 Jam Nonstop',
      'phone': '+62 821-4455-6677',
      'instagram': '@warkop.moromoro',
      'desc':
          'Cita rasa kopi warkop tradisional khas nusantara yang ramah kantong, jajanan pasar hangat, dan suasana akrab.',
      'mapOffset': const Offset(-45, 35),
      'color': const Color(0xFF4A2C1E),
    },
    {
      'name': 'Ruang Luang',
      'type': 'Cabang Timur / Co-working Space',
      'address':
          'Depan Nasi goreng Atmo, Jl. Panglima Sudirman . RT/RW 01/01 ds.Ngantru, Dobangsan, Belakang Indomart, Kec. Trenggalek, Kabupaten Trenggalek, Jawa Timur 66311',
      'hours': 'Setiap Hari: 09:00 - 22:00 WIB',
      'phone': '+62 857-9988-1122',
      'instagram': '@ruangluang.space',
      'desc':
          'Tempat tenang & kolaboratif terbaik untuk kerja (Work from Cafe), diskusi santai, dan dilengkapi ruang AC tenang.',
      'mapOffset': const Offset(55, -25),
      'color': const Color(0xFF3D2010),
    },
    {
      'name': 'Ammor Coffe',
      'type': 'Cabang Barat / Mocktail Bar',
      'address':
          'Ngrandu, Kendalrejo, Kec. Durenan, Kabupaten Trenggalek, Jawa Timur 66311',
      'hours': 'Setiap Hari: 10:00 - 24:00 WIB',
      'phone': '+62 813-2233-4455',
      'instagram': '@ammor.coffe',
      'desc':
          'Menghadirkan mocktails kopi artisan segar bernuansa industrial modern dengan alunan musik santai.',
      'mapOffset': const Offset(-35, -45),
      'color': const Color(0xFF1E0F08),
    },
  ];

  Widget _buildGallerySection(bool isWide) {
    final categories = [
      'Semua',
      'Spot Estetik',
      'Barista & Seduhan',
      'Keceriaan Pengunjung'
    ];
    final filteredItems = _selectedGalleryCategory == 'Semua'
        ? _galleryData
        : _galleryData
            .where((item) => item['category'] == _selectedGalleryCategory)
            .toList();

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          // Header
          Text(
            '📸 Galeri Suasana & Instagram',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intip sudut Instagramable terindah, dedikasi barista, dan keceriaan pengunjung di 4 cabang kami',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 2,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 32),

          // Filters / Categories Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categories.map((cat) {
                final isSelected = _selectedGalleryCategory == cat;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedGalleryCategory = cat),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.border,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.secondary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 40),

          // Collage Grid of Gallery Cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide
                  ? 3
                  : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 0.9,
            ),
            itemCount: filteredItems.length,
            itemBuilder: (ctx, i) {
              final item = filteredItems[i];
              return _GalleryCard(
                item: item,
                onTap: () => _showInstagramDialog(item),
              );
            },
          ),
          const SizedBox(height: 56),

          // Double Banner: Career & Social Media
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2C1810), Color(0xFF1E0F08)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: isWide ? 3 : 0,
                  child: Column(
                    crossAxisAlignment: isWide
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: isWide
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.work_outline_rounded,
                              color: AppColors.secondary, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Tertarik Menjadi Bagian dari Madju Djaja Group?',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign:
                                isWide ? TextAlign.left : TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kami selalu mencari Barista bertalenta, Staf Dapur kreatif, dan Kasir yang ramah untuk berkembang bersama di 4 cabang kami. Mulai karir kuliner profesionalmu hari ini!',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.5,
                        ),
                        textAlign: isWide ? TextAlign.left : TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (isWide)
                  const SizedBox(width: 48)
                else
                  const SizedBox(height: 24),
                _GoldButton(
                  label: 'Gabung Tim Kami (Lamar)',
                  icon: Icons.assignment_ind_outlined,
                  onTap: () => _showCareerDialog(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── INSTAGRAM DETAIL DIALOG (LIGHTBOX) ─────────────────────────────────
  void _showInstagramDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _InstagramDetailDialog(item: item);
      },
    );
  }

  // ─── CAREER APPLICATION DIALOG ──────────────────────────────────────────
  void _showCareerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const _CareerDialog();
      },
    );
  }

  // ─── LOCATION & CONTACT SECTION ────────────────────────────────────────
  Widget _buildLocationSection(bool isWide) {
    final activeBranch = _branchesData[_selectedBranchIndex];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          // Section Header
          Text(
            '📍 Kontak & Lokasi Cabang',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih salah satu dari 4 cabang kami di Trenggalek untuk melihat info lengkap dan peta arah',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 2,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 36),

          // Interactive Café Branch Selector Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_branchesData.length, (index) {
                final b = _branchesData[index];
                final isSelected = _selectedBranchIndex == index;
                IconData branchIcon;
                switch (index) {
                  case 0:
                    branchIcon = Icons.coffee_rounded;
                    break;
                  case 1:
                    branchIcon = Icons.storefront_rounded;
                    break;
                  case 2:
                    branchIcon = Icons.weekend_rounded;
                    break;
                  default:
                    branchIcon = Icons.auto_awesome_rounded;
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedBranchIndex = index),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.border,
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            branchIcon,
                            color: isSelected
                                ? AppColors.secondary
                                : AppColors.primaryLight,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            b['name'],
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 48),

          // Details + Integrated Map Grid
          IntrinsicHeight(
            child: Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info block of selected branch
                Expanded(
                  flex: isWide ? 1 : 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Branch Badge & Pitch
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: AppColors.secondary.withOpacity(0.4)),
                        ),
                        child: Text(
                          activeBranch['type'],
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        activeBranch['name'],
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activeBranch['desc'],
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Core Info list
                      _buildInfoTile(
                        icon: Icons.location_on_outlined,
                        title: 'Alamat Cabang',
                        subtitle: activeBranch['address'],
                        actionLabel: 'Salin Alamat',
                        onActionTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Alamat cabang berhasil disalin ke clipboard!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildInfoTile(
                        icon: Icons.access_time_outlined,
                        title: 'Jam Operasional',
                        subtitle: activeBranch['hours'],
                      ),
                      const SizedBox(height: 20),
                      _buildInfoTile(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'Sosial Media & Kontak',
                        subtitle:
                            'WhatsApp: ${activeBranch['phone']}\nInstagram: ${activeBranch['instagram']}',
                        actionLabel: 'Kirim WhatsApp',
                        onActionTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Membuka chat WhatsApp ke ${activeBranch['phone']}...'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (isWide)
                  const VerticalDivider(
                      width: 64, thickness: 1, color: AppColors.divider),
                if (!isWide) const SizedBox(height: 48),

                // Simulated Integrated Maps Container
                Expanded(
                  flex: isWide ? 1 : 0,
                  child: Container(
                    height: 380,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Map vector look
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CustomPaint(
                              painter: _InteractiveMapPainter(
                                selectedIndex: _selectedBranchIndex,
                                branches: _branchesData,
                              ),
                            ),
                          ),
                        ),

                        // Interactive Map overlays
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.secondary.withOpacity(0.5)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.map_outlined,
                                    color: AppColors.secondary, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Peta Interaktif Trenggalek',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Dynamic Floating Selected Hub info box on Map
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 80,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.12)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: activeBranch['color'],
                                  child: const Icon(Icons.location_pin,
                                      color: AppColors.secondary, size: 16),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        activeBranch['name'],
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        activeBranch['address'],
                                        style: GoogleFonts.outfit(
                                          fontSize: 10,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Float Map controls
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _MapControlButton(
                                icon: Icons.add,
                                onTap: () => _showMapToast(
                                    context, 'Perbesar Peta (Zoom In)'),
                              ),
                              const SizedBox(height: 8),
                              _MapControlButton(
                                icon: Icons.remove,
                                onTap: () => _showMapToast(
                                    context, 'Perkecil Peta (Zoom Out)'),
                              ),
                              const SizedBox(height: 8),
                              _MapControlButton(
                                icon: Icons.my_location,
                                onTap: () => _showMapToast(
                                    context, 'Mencari Lokasi Anda...'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMapToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primarySurface,
          radius: 20,
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              if (actionLabel != null && onActionTap != null) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: onActionTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryDark,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_right_alt,
                          color: AppColors.secondaryDark, size: 14),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

  // ─── FOOTER & SITEMAP ──────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.only(top: 80, left: 32, right: 32, bottom: 40),
      child: Column(
        children: [
          // Grid layout for sitemap columns
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  // Col 1: Brand Info & Pitch
                  SizedBox(
                    width: isWide ? 280 : double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Madju Djaja Group',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Jaringan kafe specialty coffee dan warkop modern terbesar di Trenggalek. Menyajikan kenyamanan, kehangatan, dan cita rasa autentik di setiap cangkir kopi.',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.55),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Social media icons
                        Row(
                          children: [
                            _buildSocialIcon(
                                Icons.camera_alt_outlined, '@madjudjaja.group'),
                            const SizedBox(width: 12),
                            _buildSocialIcon(Icons.chat_bubble_outline_rounded,
                                '+62 812-3456-7890'),
                            const SizedBox(width: 12),
                            _buildSocialIcon(
                                Icons.play_circle_outline, 'Madju Djaja TV'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Col 2: Sitemap Portals
                  SizedBox(
                    width: isWide ? 160 : 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Portal Sistem',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildFooterLink('Portal Pegawai', '/employee/login'),
                        _buildFooterLink(
                            'Portal Manajer & HRIS', '/manager/login'),
                        _buildFooterLink('Landing Page Utama', '/'),
                      ],
                    ),
                  ),

                  // Col 3: Branches
                  SizedBox(
                    width: isWide ? 160 : 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '4 Cabang Kami',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildFooterStaticItem('Madju Djaja Roastery'),
                        _buildFooterStaticItem('Warkop Moro-Moro'),
                        _buildFooterStaticItem('Ruang Luang Space'),
                        _buildFooterStaticItem('Ammor Coffe Mocktails'),
                      ],
                    ),
                  ),

                  // Col 4: Careers & Inquiries
                  SizedBox(
                    width: isWide ? 200 : double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hubungi Kami',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Kantor Manajemen Pusat:\nJl. Diponegoro, Krajan, Surodakan, Kec. Trenggalek\nKabupaten Trenggalek, Jawa Timur 66316\nEmail: hrd@madjudjajagroup.com\nTelp: (0351) 789101',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.55),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 60),

          // Bottom Bar
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.08),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '© 2026 Madju Djaja Group. Semua Hak Dilindungi. Dibuat dengan Bangga di Trenggalek.',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.35),
                  ),
                ),
              ),
              Text(
                'v1.2.0-Production',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Membuka tautan sosial $tooltip...'),
              backgroundColor: AppColors.primary,
            ),
          );
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.12)),
            color: Colors.white.withOpacity(0.03),
          ),
          child: Icon(icon, color: Colors.white.withOpacity(0.7), size: 18),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String label, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go(route),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterStaticItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 13,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}

// ─── HELPER WIDGETS & PAINTERS ──────────────────────────────────────────────

class _GoldButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GoldButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  State<_GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<_GoldButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: _hovering ? AppColors.secondaryLight : AppColors.secondary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: _hovering
                ? [
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: AppColors.primaryDark, size: 18),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlineButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color:
                _hovering ? Colors.white.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrollIndicator extends StatefulWidget {
  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: 0.4 + (_anim.value * 0.4),
        child: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class _MenuItem {
  final String name, desc, price;
  final IconData icon;
  final Color color;
  const _MenuItem({
    required this.name,
    required this.desc,
    required this.price,
    required this.icon,
    required this.color,
  });
}

class _MenuCard extends StatefulWidget {
  final _MenuItem item;
  const _MenuCard({required this.item});

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: _hovering
            ? (Matrix4.identity()..translate(0.0, -6.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.item.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: widget.item.color.withOpacity(0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.item.icon,
                size: 38,
                color: AppColors.secondary,
              ),
              const Spacer(),
              Text(
                widget.item.name,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.item.desc,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.65),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                widget.item.price,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Updated _GalleryCard using dynamic Map, support zoom tap, hover checkmark
class _GalleryCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;
  const _GalleryCard({required this.item, required this.onTap});

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: _hovering
                ? (Matrix4.identity()..scale(1.025))
                : Matrix4.identity(),
            decoration: BoxDecoration(
              border: Border.all(
                color: _hovering ? AppColors.secondary : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Image
                Positioned.fill(
                  child: Image.asset(
                    widget.item['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      IconData icon;
                      switch (widget.item['category']) {
                        case 'Spot Estetik':
                          icon = Icons.camera_alt_rounded;
                          break;
                        case 'Barista & Seduhan':
                          icon = Icons.coffee_maker_rounded;
                          break;
                        default:
                          icon = Icons.groups_rounded;
                      }
                      return Container(
                        color: const Color(0xFF1E0F08),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.secondary.withOpacity(0.5), width: 1),
                                  color: Colors.white.withOpacity(0.02),
                                ),
                                child: Icon(
                                  icon,
                                  color: AppColors.secondary,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Visual Café',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white60,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Hover overlay gradient
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(_hovering ? 0.75 : 0.4),
                          Colors.black.withOpacity(_hovering ? 0.35 : 0.05),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                // Gold zoom icon on hover
                if (_hovering)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.secondary, width: 1),
                      ),
                      child: const Icon(
                        Icons.zoom_in_rounded,
                        color: AppColors.secondary,
                        size: 32,
                      ),
                    ),
                  ),
                // Text Content & Likes Counter
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.item['category']!,
                              style: GoogleFonts.outfit(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.favorite,
                                  color: AppColors.secondary, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.item['likes']}',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.item['title']!,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.item['subtitle']!,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PortalCard extends StatefulWidget {
  final String title, subtitle, buttonLabel, route;
  final IconData icon;
  final List<String> features;
  final bool isGold;
  const _PortalCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.features,
    required this.buttonLabel,
    required this.route,
    required this.isGold,
  });

  @override
  State<_PortalCard> createState() => _PortalCardState();
}

class _PortalCardState extends State<_PortalCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 320,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _hovering ? const Color(0xFF3D2416) : const Color(0xFF2C1A0E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isGold
                ? AppColors.secondary.withOpacity(_hovering ? 0.8 : 0.4)
                : Colors.white.withOpacity(_hovering ? 0.2 : 0.08),
            width: 1.5,
          ),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: widget.isGold
                        ? AppColors.secondary.withOpacity(0.15)
                        : Colors.white.withOpacity(0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isGold
                    ? AppColors.secondary.withOpacity(0.15)
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon,
                color: widget.isGold ? AppColors.secondary : Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.white.withOpacity(0.55),
              ),
            ),
            const SizedBox(height: 24),
            ...widget.features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: widget.isGold
                          ? AppColors.secondary
                          : Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        f,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => context.go(widget.route),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: widget.isGold
                        ? AppColors.secondary
                        : Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.buttonLabel,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color:
                          widget.isGold ? AppColors.primaryDark : Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PREMIUM COFFEE GRID PATTERN PAINTER ──────────────────────────────────
class _CoffeePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.015)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 60.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 20, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── DETAILED PREMIUM VECTOR INTERACTIVE MAP PAINTER ───────────────────────
class _InteractiveMapPainter extends CustomPainter {
  final int selectedIndex;
  final List<Map<String, dynamic>> branches;
  const _InteractiveMapPainter(
      {required this.selectedIndex, required this.branches});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw background color (Premium Charcoal Latte)
    final bgPaint = Paint()..color = const Color(0xFF130A06);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw coordinates grids
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 0.8;
    const gridSpacing = 40.0;
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw a flowing blue river (Ngrowo River simulation)
    final riverPaint = Paint()
      ..color = const Color(0xFF42A5F5).withOpacity(0.06)
      ..strokeWidth = 26
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final riverPath = Path();
    riverPath.moveTo(0, size.height * 0.35);
    riverPath.quadraticBezierTo(size.width * 0.3, size.height * 0.2,
        size.width * 0.55, size.height * 0.65);
    riverPath.quadraticBezierTo(
        size.width * 0.75, size.height * 0.95, size.width, size.height * 0.85);
    canvas.drawPath(riverPath, riverPaint);

    // Draw secondary roads
    final streetPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.height * 0.2),
        Offset(size.width, size.height * 0.4), streetPaint);
    canvas.drawLine(Offset(size.width * 0.25, 0),
        Offset(size.width * 0.35, size.height), streetPaint);
    canvas.drawLine(Offset(size.width * 0.75, 0),
        Offset(size.width * 0.65, size.height), streetPaint);

    // Draw main roads (Jl. Diponegoro & Jl. DR. Sutomo primary highway)
    final highwayPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(0, center.dy), Offset(size.width, center.dy), highwayPaint);
    canvas.drawLine(
        Offset(center.dx, 0), Offset(center.dx, size.height), highwayPaint);

    // Draw all branches with gold and white nodes
    for (int i = 0; i < branches.length; i++) {
      final b = branches[i];
      final offset = b['mapOffset'] as Offset;
      final point = center + offset;
      final isSelected = i == selectedIndex;

      // Glow pulse ring
      if (isSelected) {
        final glowPaint = Paint()
          ..color = AppColors.secondary.withOpacity(0.18)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(point, 24, glowPaint);

        final glowRing = Paint()
          ..color = AppColors.secondary.withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawCircle(point, 16, glowRing);
      }

      // Draw branch center point
      final dotPaint = Paint()
        ..color =
            isSelected ? AppColors.secondary : Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, isSelected ? 8 : 5, dotPaint);

      // Inner mask circle
      if (isSelected) {
        canvas.drawCircle(point, 3, Paint()..color = const Color(0xFF130A06));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _InteractiveMapPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MapControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.85),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ─── INSTAGRAM DETAIL POPUP (LIGHTBOX WITH MOCK COMMEENTING) ───────────────
class _InstagramDetailDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  const _InstagramDetailDialog({required this.item});

  @override
  State<_InstagramDetailDialog> createState() => _InstagramDetailDialogState();
}

class _InstagramDetailDialogState extends State<_InstagramDetailDialog> {
  late int _likes;
  late List<Map<String, String>> _comments;
  bool _isLiked = false;
  final TextEditingController _commentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _likes = widget.item['likes'];
    _comments = List<Map<String, String>>.from(widget.item['comments']);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 800;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: isWide ? 550 : size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF24150E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.secondary.withOpacity(0.3), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            children: [
              // Photo Frame
              Expanded(
                flex: isWide ? 6 : 0,
                child: Container(
                  height: isWide ? double.infinity : 260,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          widget.item['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            IconData icon;
                            switch (widget.item['category']) {
                              case 'Spot Estetik':
                                icon = Icons.camera_alt_rounded;
                                break;
                              case 'Barista & Seduhan':
                                icon = Icons.coffee_maker_rounded;
                                break;
                              default:
                                icon = Icons.groups_rounded;
                            }
                            return Container(
                              color: const Color(0xFF1E0F08),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      icon,
                                      color: AppColors.secondary,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Galeri Suasana',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Watermark / Subtitle
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.camera_alt,
                                  color: AppColors.secondary, size: 14),
                              const SizedBox(width: 8),
                              Text(
                                'Instagram Grid',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
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

              // Detail & Comments Pane
              Expanded(
                flex: isWide ? 5 : 1,
                child: Container(
                  color: const Color(0xFF1E110A),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Profile & Handle
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.secondary,
                            child: Icon(Icons.coffee_rounded,
                                color: AppColors.primaryDark, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'madjudjaja.group',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified,
                                        color: Colors.blue, size: 14),
                                  ],
                                ),
                                Text(
                                  'Trenggalek, Jawa Timur',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white60, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 12),

                      // Scrollable description + comments feed
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Post Description / Caption
                              Text(
                                widget.item['caption'],
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.item['time'],
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Komentar Pengunjung:',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Loop existing comments
                              ..._comments.map((c) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.outfit(
                                            fontSize: 12, color: Colors.white),
                                        children: [
                                          TextSpan(
                                            text: '@${c['user']}  ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.secondaryLight,
                                            ),
                                          ),
                                          TextSpan(
                                            text: c['text']!,
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.85)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),

                      // Heart Interactions Row
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isLiked = !_isLiked;
                                _likes = _isLiked ? _likes + 1 : _likes - 1;
                              });
                            },
                            child: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color:
                                  _isLiked ? Colors.red : AppColors.secondary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_likes Suka',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chat_bubble_outline,
                              color: Colors.white54, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${_comments.length} Komentar',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Comment Input Form
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentCtrl,
                              style: GoogleFonts.outfit(
                                  fontSize: 13, color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Tulis komentar estetikmu...',
                                hintStyle:
                                    GoogleFonts.outfit(color: Colors.white38),
                                fillColor: Colors.white.withOpacity(0.05),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              onSubmitted: (_) => _addComment(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send,
                                color: AppColors.secondary, size: 20),
                            onPressed: _addComment,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addComment() {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add({
        'user': 'anda_nongkrong',
        'text': text,
      });
      _commentCtrl.clear();
    });
  }
}

// ─── REKRUTMEN / CAREERS APPLICATION FORM DIALOG ─────────────────────────────
class _CareerDialog extends StatefulWidget {
  const _CareerDialog();

  @override
  State<_CareerDialog> createState() => _CareerDialogState();
}

class _CareerDialogState extends State<_CareerDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPosition = 'Senior Barista';
  String _selectedBranch = 'Madju Djaja Utama';
  String _name = '';
  String _phone = '';
  String _email = '';
  String _motivation = '';
  String _selectedFileName = '';
  bool _isSubmitting = false;
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF24150E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.secondary, width: 1.5),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSuccess ? _buildSuccessState() : _buildFormState(),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return SingleChildScrollView(
      key: const ValueKey('form_state'),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.assignment_ind,
                    color: AppColors.secondary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Lamar Pekerjaan',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white60),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Ayo bergabung dengan ekosistem pelayanan kopi terbaik Madju Djaja Cafe Group di Trenggalek!',
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 20),

            // Nama Lengkap
            _buildLabel('Nama Lengkap kandidat *'),
            TextFormField(
              style: GoogleFonts.outfit(color: Colors.white),
              decoration: _buildInputDec('Masukkan nama lengkap sesuai KTP'),
              validator: (val) => val == null || val.isEmpty
                  ? 'Nama lengkap wajib diisi'
                  : null,
              onSaved: (val) => _name = val ?? '',
            ),
            const SizedBox(height: 16),

            // WA & Email
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Nomor WhatsApp *'),
                      TextFormField(
                        style: GoogleFonts.outfit(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        decoration: _buildInputDec('0812xxxxxx'),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Nomor WA wajib diisi'
                            : null,
                        onSaved: (val) => _phone = val ?? '',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Alamat Email *'),
                      TextFormField(
                        style: GoogleFonts.outfit(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDec('kandidat@email.com'),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Email wajib diisi'
                            : null,
                        onSaved: (val) => _email = val ?? '',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Position & Branch Selection dropdowns
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Posisi Pilihan *'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: const Color(0xFF24150E),
                            value: _selectedPosition,
                            isExpanded: true,
                            items: [
                              'Senior Barista',
                              'Junior Barista',
                              'Cook Helper (Dapur)',
                              'Kasir / Staf Service'
                            ]
                                .map((pos) => DropdownMenuItem(
                                      value: pos,
                                      child: Text(pos,
                                          style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontSize: 13)),
                                    ))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedPosition = val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Penempatan Cabang *'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: const Color(0xFF24150E),
                            value: _selectedBranch,
                            isExpanded: true,
                            items: [
                              'Madju Djaja Utama',
                              'Warkop Moro-Moro',
                              'Ruang Luang',
                              'Ammor Coffe'
                            ]
                                .map((br) => DropdownMenuItem(
                                      value: br,
                                      child: Text(br,
                                          style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontSize: 13)),
                                    ))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedBranch = val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Motivation Letter / Experience
            _buildLabel('Pengalaman Kerja / Alasan Melamar *'),
            TextFormField(
              maxLines: 3,
              style: GoogleFonts.outfit(color: Colors.white),
              decoration: _buildInputDec(
                  'Jelaskan secara singkat mengapa Anda cocok bergabung...'),
              validator: (val) => val == null || val.isEmpty
                  ? 'Alasan melamar wajib diisi'
                  : null,
              onSaved: (val) => _motivation = val ?? '',
            ),
            const SizedBox(height: 20),

            // CV Upload Simulator
            _buildLabel('Unggah berkas CV & Portofolio (Simulasi) *'),
            Row(
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                  label: Text('Pilih Berkas PDF',
                      style: GoogleFonts.outfit(fontSize: 12)),
                  onPressed: () {
                    setState(() {
                      _selectedFileName =
                          'CV_Lengkap_${_name.replaceAll(" ", "_")}_Madju.pdf';
                    });
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedFileName.isEmpty
                        ? 'Belum ada berkas dipilih'
                        : _selectedFileName,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: _selectedFileName.isEmpty
                          ? Colors.white38
                          : AppColors.secondaryLight,
                      fontStyle: _selectedFileName.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: _isSubmitting
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.secondary))
                  : _GoldButton(
                      label: 'Kirim Lamaran Kerja',
                      icon: Icons.send_rounded,
                      onTap: _submitForm,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      key: const ValueKey('success_state'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_outline,
            color: AppColors.secondary, size: 72),
        const SizedBox(height: 24),
        Text(
          'Lamaran Terkirim!',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Terima kasih, $_name!\nLamaran Anda sebagai $_selectedPosition di $_selectedBranch telah kami terima. Tim HRD Madju Djaja Group akan meninjau CV Anda dan segera menghubungi Anda via WhatsApp ($_phone) dalam 2x24 jam untuk jadwal wawancara.',
          style: GoogleFonts.outfit(
            fontSize: 13.5,
            color: Colors.white.withOpacity(0.8),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.primaryDark,
          ),
          onPressed: () => Navigator.pop(context),
          child: Text('Tutup',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_selectedFileName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih berkas CV Anda terlebih dahulu!'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      setState(() => _isSubmitting = true);
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          debugPrint(
              'Lamar: $_name, $_phone, $_email, $_motivation, $_selectedPosition, $_selectedBranch');
          setState(() {
            _isSubmitting = false;
            _isSuccess = true;
          });
        }
      });
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }

  InputDecoration _buildInputDec(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 13),
      fillColor: Colors.white.withOpacity(0.05),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
