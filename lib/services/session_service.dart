import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyUsername = 'logged_in_username';

  // Simpan username ke SharedPreferences saat login
  Future<void> saveSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
  }

  // Ambil username yang tersimpan (kalau null = belum login)
  Future<String?> getSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Hapus session saat logout
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
  }
}