import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  // Keys
  static const String _tokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  // ─── Token Management ──────────────────────────────────────────────

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _tokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // ─── User Data Management ──────────────────────────────────────────

  Future<void> saveUserData({
    required String userId,
    required String role,
    required String name,
    required String email,
  }) async {
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _userRoleKey, value: role);
    await _storage.write(key: _userNameKey, value: name);
    await _storage.write(key: _userEmailKey, value: email);
  }

  Future<Map<String, String?>> getUserData() async {
    return {
      'userId': await _storage.read(key: _userIdKey),
      'role': await _storage.read(key: _userRoleKey),
      'name': await _storage.read(key: _userNameKey),
      'email': await _storage.read(key: _userEmailKey),
    };
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  // ─── Authentication Status ─────────────────────────────────────────

  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> isEmployee() async {
    final role = await getUserRole();
    return role == 'BARISTA' || role == 'EMPLOYEE';
  }

  Future<bool> isManager() async {
    final role = await getUserRole();
    return role == 'MANAGER';
  }

  Future<bool> isOwner() async {
    final role = await getUserRole();
    return role == 'OWNER';
  }

  // ─── Logout ────────────────────────────────────────────────────────

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  // ─── Clear All Data ────────────────────────────────────────────────

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
