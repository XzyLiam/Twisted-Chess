import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _keySound = 'sound_enabled';
  static const _keyDarkMode = 'dark_mode';
  static const _keyPuzzleStreak = 'puzzle_streak';
  static const _keyLastPuzzleDate = 'last_puzzle_date';

  Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySound) ?? true;
  }

  Future<void> setSoundEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySound, value);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }

  Future<int> getPuzzleStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyPuzzleStreak) ?? 0;
  }

  Future<void> setPuzzleStreak(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPuzzleStreak, value);
  }

  Future<String?> getLastPuzzleDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastPuzzleDate);
  }

  Future<void> setLastPuzzleDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastPuzzleDate, date);
  }
}