import 'package:shared_preferences/shared_preferences.dart';

class ProfileLocalStorage {
  static const String _profileImagePathKey = 'day30_profile_image_path';

  static Future<void> saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImagePathKey, path);
  }

  static Future<String?> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImagePathKey);
  }

  static Future<void> clearProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileImagePathKey);
  }
}
