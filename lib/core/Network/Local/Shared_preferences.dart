import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  // Singleton pattern to ensure only one instance of SharedPreferences is used
  static final PreferencesHelper _instance = PreferencesHelper._internal();
  factory PreferencesHelper() => _instance;
  PreferencesHelper._internal();

  // SharedPreferences instance
  late SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save a String value
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Get a String value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Save an Integer value
  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  // Get an Integer value
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Save a Boolean value
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  // Get a Boolean value
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Remove a value
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Clear all values
  Future<void> clear() async {
    await _prefs.clear();
  }
}
