import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with TickerProviderStateMixin {
  bool _checkedIn = false;
  bool _isLoading = false;
  String? _checkInTime;
  String? _checkOutTime;
  double _distanceMeters = 45.0; // Dynamic state variable for simulation

  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  void _toggleGpsDistance() {
    setState(() {
      _distanceMeters = _distanceMeters == 45.0 ? 120.0 : 45.0;
    });
  }

  void _doCheckIn() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _checkedIn = true;
        _checkInTime = '08:05';
      });
    }
  }

  void _doCheckOut() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _checkOutTime = '17:00';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // PRD Specific GPS Radius (50 meters)
    final inRadius = _distanceMeters <= 50.0;
    final statusColor = inRadius ? AppColors.success : AppColors.error;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Absensi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ─── GPS Radar Scanner Card ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: inRadius ? AppColors.successSurface : AppColors.errorSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: statusColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  // Animating Radar Scanner View
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _radarController,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(140, 140),
                              painter: _RadarScannerPainter(
                                _radarController.value * 2 * 3.14159,
                                statusColor,
                              ),
                            );
                          },
                        ),
                        // Inner circle status icon
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: statusColor,
                          child: Icon(
                            inRadius ? Icons.location_on : Icons.location_off,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    inRadius ? 'Anda dalam area cafe' : 'Di luar area cafe',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jarak: ${_distanceMeters.toStringAsFixed(1)} meter dari titik cabang',
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Simulation Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      minimumSize: Size.zero,
                    ),
                    onPressed: _toggleGpsDistance,
                    icon: const Icon(Icons.satellite_alt_rounded, size: 16),
                    label: Text(
                      _distanceMeters == 45.0 ? 'Simulasi Berjalan ke Luar Cabang (120m)' : 'Simulasi Masuk Radius Cabang (45m)',
                      style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Status Timeline ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rekap Hari Ini',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  _TimelineItem(
                    title: 'Check-in',
                    time: _checkInTime ?? '–',
                    done: _checkedIn,
                    icon: Icons.login,
                  ),
                  const SizedBox(height: 16),
                  _TimelineItem(
                    title: 'Check-out',
                    time: _checkOutTime ?? '–',
                    done: _checkOutTime != null,
                    icon: Icons.logout,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ─── Action Button ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (!inRadius || _isLoading || _checkOutTime != null)
                    ? null
                    : (_checkedIn ? _doCheckOut : _doCheckIn),
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(_checkedIn ? Icons.logout : Icons.login),
                label: Text(
                  _checkOutTime != null
                      ? 'Selesai untuk hari ini'
                      : (_checkedIn
                          ? 'Check-out Sekarang'
                          : 'Check-in Sekarang'),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor:
                      _checkedIn ? AppColors.error : AppColors.primary,
                  disabledBackgroundColor: AppColors.border,
                ),
              ),
            ),
            if (!inRadius) ...[
              const SizedBox(height: 12),
              Text(
                'Anda harus berada dalam radius 50m dari cafe (PRD Standard)',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title, time;
  final bool done;
  final IconData icon;
  const _TimelineItem({
    required this.title,
    required this.time,
    required this.done,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: done ? AppColors.primarySurface : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: done ? AppColors.primary : AppColors.textMuted,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(time, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        if (done)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Tercatat',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Concentric Radar GPS Painter ──────────────────────────────────────────
class _RadarScannerPainter extends CustomPainter {
  final double angle;
  final Color color;

  _RadarScannerPainter(this.angle, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw subtle concentric circles
    final circlePaint = Paint()
      ..color = color.withOpacity(0.06)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);
    canvas.drawCircle(center, radius * 0.7, circlePaint);
    canvas.drawCircle(center, radius * 0.4, circlePaint);

    final outlinePaint = Paint()
      ..color = color.withOpacity(0.12)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, outlinePaint);
    canvas.drawCircle(center, radius * 0.7, outlinePaint);
    canvas.drawCircle(center, radius * 0.4, outlinePaint);

    // Draw scanning sweep (Arc with gradient shading)
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 3.14159 * 2,
        colors: [color.withOpacity(0.35), color.withOpacity(0)],
        stops: const [0.0, 0.25],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawCircle(Offset.zero, radius, sweepPaint);
    canvas.restore();

    // Draw active scanning blip
    final blipPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    // Static coffee cup or employee coordinates on radar grid
    canvas.drawCircle(Offset(center.dx + radius * 0.35, center.dy - radius * 0.45), 5.5, blipPaint);
    canvas.drawCircle(
      Offset(center.dx + radius * 0.35, center.dy - radius * 0.45),
      12.0,
      Paint()
        ..color = color.withOpacity(0.3)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarScannerPainter oldDelegate) =>
      oldDelegate.angle != angle || oldDelegate.color != color;
}
