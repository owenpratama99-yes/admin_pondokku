import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';

class EmployeeLoginScreen extends StatefulWidget {
  const EmployeeLoginScreen({super.key});

  @override
  State<EmployeeLoginScreen> createState() => _EmployeeLoginScreenState();
}

class _EmployeeLoginScreenState extends State<EmployeeLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    try {
      // TODO: integrate ApiClient().post('/auth/login')
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulate successful login - save tokens
      final authService = AuthService();
      await authService.saveTokens(
        accessToken: 'dummy_access_token',
        refreshToken: 'dummy_refresh_token',
      );
      await authService.saveUserData(
        userId: 'EMP001',
        role: 'BARISTA',
        name: 'Rudi Pratama',
        email: _emailCtrl.text,
      );
      
      if (mounted) {
        context.go('/employee/dashboard');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login gagal: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 800;

    return Scaffold(
      body: Row(
        children: [
          // Left panel (decorative) - only on wide screens
          if (isWide)
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A0F09),
                      Color(0xFF2C1810),
                      Color(0xFF3D2010),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DiagonalLinePainter(),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.secondary.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.coffee,
                              size: 56,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Madju Djaja',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Portal Pegawai',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              color: AppColors.secondary,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Right panel (form)
          Expanded(
            flex: isWide ? 4 : 10,
            child: Container(
              color: AppColors.background,
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Back to landing
                            TextButton.icon(
                              onPressed: () => context.go('/'),
                              icon: const Icon(Icons.arrow_back, size: 16),
                              label: Text('Beranda',
                                  style: GoogleFonts.outfit(fontSize: 13)),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textMuted,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            const SizedBox(height: 32),

                            Text(
                              'Selamat Datang',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Masuk ke akun pegawai Anda',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Email
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email / ID Pegawai',
                                prefixIcon:
                                    Icon(Icons.person_outline, size: 20),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Email/ID wajib diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscurePass,
                              decoration: InputDecoration(
                                labelText: 'Kata Sandi',
                                prefixIcon:
                                    const Icon(Icons.lock_outline, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePass
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscurePass = !_obscurePass),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Kata sandi wajib diisi';
                                }
                                if (v.length < 4) {
                                  return 'Kata sandi minimal 4 karakter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _doLogin,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Masuk',
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Forgot password link
                            Center(
                              child: TextButton(
                                onPressed: () => context.go('/employee/forgot-password'),
                                child: Text(
                                  'Lupa Password?',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Manager portal link
                            Center(
                              child: TextButton(
                                onPressed: () => context.go('/manager/login'),
                                child: Text(
                                  'Login sebagai Manajer →',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;
    for (double i = -size.height; i < size.width + size.height; i += 40) {
      canvas.drawLine(
          Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
