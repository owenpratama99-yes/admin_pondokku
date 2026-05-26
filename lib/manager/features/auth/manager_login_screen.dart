import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants.dart';
import '../../../core/services/auth_service.dart';

class ManagerLoginScreen extends StatefulWidget {
  const ManagerLoginScreen({super.key});

  @override
  State<ManagerLoginScreen> createState() => _ManagerLoginScreenState();
}

class _ManagerLoginScreenState extends State<ManagerLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;
  String _selectedRole = 'Manajemen';
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
      
      // Save selected role to current session
      CurrentSession.role = _selectedRole;
      
      // Simulate successful login - save tokens
      final authService = AuthService();
      await authService.saveTokens(
        accessToken: 'dummy_manager_access_token',
        refreshToken: 'dummy_manager_refresh_token',
      );
      await authService.saveUserData(
        userId: 'MGR001',
        role: 'MANAGER',
        name: 'Manager Demo',
        email: _emailCtrl.text,
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/manager/dashboard');
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
                      Color(0xFF0F0805), // Darker than employee
                      Color(0xFF1E0F08),
                      Color(0xFF2C1810),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _PatternPainter(),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.secondary.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.admin_panel_settings,
                              size: 56,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Madju Djaja Group',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Portal Manajer',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.6),
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
                              'Akses Eksekutif',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sistem manajemen operasional & SDM',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Hak Akses Role Dropdown
                            DropdownButtonFormField<String>(
                              initialValue: _selectedRole,
                              decoration: const InputDecoration(
                                labelText: 'Hak Akses Portal',
                                prefixIcon: Icon(
                                    Icons.admin_panel_settings_outlined,
                                    size: 20),
                              ),
                              dropdownColor: AppColors.surfaceCard,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Manajemen',
                                  child: Text('Manajemen (Manager/HR)'),
                                ),
                                DropdownMenuItem(
                                  value: 'Owner',
                                  child: Text('Owner (SuperAdmin)'),
                                ),
                                DropdownMenuItem(
                                  value: 'Investor',
                                  child: Text('Investor (Read Only)'),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  _selectedRole = val ?? 'Manajemen';
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email Operasional',
                                prefixIcon:
                                    Icon(Icons.shield_outlined, size: 20),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Email wajib diisi';
                                }
                                if (!v.contains('@') || !v.contains('.')) {
                                  return 'Format email tidak valid';
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
                                if (v.length < 6) {
                                  return 'Kata sandi minimal 6 karakter';
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
                                  backgroundColor: AppColors.primaryDark,
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
                                        'Login',
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Employee portal link
                            Center(
                              child: TextButton(
                                onPressed: () => context.go('/employee/login'),
                                child: Text(
                                  '← Login sebagai Pegawai',
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

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Grid pattern for manager app
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
