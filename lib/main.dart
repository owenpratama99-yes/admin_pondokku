import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const MadjuDjajaApp());
}

class MadjuDjajaApp extends StatelessWidget {
  const MadjuDjajaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Madju Djaja Cafe - Portal Pegawai & Manajer',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
