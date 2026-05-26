// ─── App Constants ─────────────────────────────────────────────────────
class AppConstants {
  // API
  static const String apiBaseUrl = 'https://api.madjudjadja.com';
  static const String apiVersion = '/v1';
  static const String fullApiUrl = '$apiBaseUrl$apiVersion';

  // Auth
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userRoleKey = 'user_role';

  // GPS / Attendance
  static const double gpsRadiusMeters = 100.0; // max check-in radius

  // Points
  static const int spThreshold1 = 80;   // SP1 threshold
  static const int spThreshold2 = 60;   // SP2 threshold
  static const int spThreshold3 = 40;   // SP3 / termination threshold

  // Branches
  static const List<String> branches = [
    'Cabang Utama',
    'Cabang Selatan',
    'Cabang Timur',
    'Cabang Barat',
  ];

  // App Name
  static const String appName = 'Madju Djaja';
  static const String employeePortalUrl = 'https://user.madjudjadja.com';
  static const String managerPortalUrl = 'https://hris.madjudjadja.com';
}

class CurrentSession {
  static String role = 'Manajemen'; // 'Manajemen', 'Owner', 'Investor'
  static bool get isReadOnly => role == 'Investor';
  static bool get isOwner => role == 'Owner';
}
