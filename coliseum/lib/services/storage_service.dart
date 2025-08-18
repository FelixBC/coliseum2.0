import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coliseum/models/user_model.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _authTokenKey = 'auth_token';
  static const String _lastLoginKey = 'last_login';
  static const String _isAuthenticatedKey = 'is_authenticated';
  static const String _authProviderKey = 'auth_provider';
  static const String _settingsKey = 'user_settings';
  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';

  static late SharedPreferences _prefs;
  static bool _initialized = false;

  // Initialize the storage service
  static Future<void> initialize() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Check if storage is initialized
  static bool get isInitialized => _initialized;

  // User data persistence
  static Future<bool> saveUser(User user) async {
    await _ensureInitialized();
    try {
      final userJson = user.toJson();
      final success = await _prefs.setString(_userKey, jsonEncode(userJson));
      
      if (success) {
        // Also save authentication state
        await _prefs.setBool(_isAuthenticatedKey, true);
        await _prefs.setString(_authProviderKey, user.authProvider ?? 'email');
        await _prefs.setString(_lastLoginKey, DateTime.now().toIso8601String());
      }
      
      return success;
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  static Future<User?> getUser() async {
    await _ensureInitialized();
    try {
      final userJson = _prefs.getString(_userKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  static Future<bool> updateUser(User user) async {
    return await saveUser(user);
  }

  static Future<bool> deleteUser() async {
    await _ensureInitialized();
    try {
      final success = await _prefs.remove(_userKey);
      if (success) {
        await _prefs.setBool(_isAuthenticatedKey, false);
        await _prefs.remove(_authProviderKey);
        await _prefs.remove(_lastLoginKey);
      }
      return success;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // Authentication state persistence
  static Future<bool> saveAuthToken(String token) async {
    await _ensureInitialized();
    try {
      return await _prefs.setString(_authTokenKey, token);
    } catch (e) {
      print('Error saving auth token: $e');
      return false;
    }
  }

  static Future<String?> getAuthToken() async {
    await _ensureInitialized();
    try {
      return _prefs.getString(_authTokenKey);
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }

  static Future<bool> deleteAuthToken() async {
    await _ensureInitialized();
    try {
      return await _prefs.remove(_authTokenKey);
    } catch (e) {
      print('Error deleting auth token: $e');
      return false;
    }
  }

  static Future<bool> isAuthenticated() async {
    await _ensureInitialized();
    try {
      return _prefs.getBool(_isAuthenticatedKey) ?? false;
    } catch (e) {
      print('Error checking authentication status: $e');
      return false;
    }
  }

  static Future<String?> getAuthProvider() async {
    await _ensureInitialized();
    try {
      return _prefs.getString(_authProviderKey);
    } catch (e) {
      print('Error getting auth provider: $e');
      return null;
    }
  }

  static Future<DateTime?> getLastLogin() async {
    await _ensureInitialized();
    try {
      final lastLoginString = _prefs.getString(_lastLoginKey);
      if (lastLoginString != null) {
        return DateTime.parse(lastLoginString);
      }
      return null;
    } catch (e) {
      print('Error getting last login: $e');
      return null;
    }
  }

  // App settings persistence
  static Future<bool> saveSettings(Map<String, dynamic> settings) async {
    await _ensureInitialized();
    try {
      final settingsJson = jsonEncode(settings);
      return await _prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      print('Error saving settings: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> getSettings() async {
    await _ensureInitialized();
    try {
      final settingsJson = _prefs.getString(_settingsKey);
      if (settingsJson != null) {
        return jsonDecode(settingsJson) as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      print('Error getting settings: $e');
      return {};
    }
  }

  static Future<bool> saveTheme(String theme) async {
    await _ensureInitialized();
    try {
      return await _prefs.setString(_themeKey, theme);
    } catch (e) {
      print('Error saving theme: $e');
      return false;
    }
  }

  static Future<String?> getTheme() async {
    await _ensureInitialized();
    try {
      return _prefs.getString(_themeKey);
    } catch (e) {
      print('Error getting theme: $e');
      return null;
    }
  }

  static Future<bool> saveLanguage(String language) async {
    await _ensureInitialized();
    try {
      return await _prefs.setString(_languageKey, language);
    } catch (e) {
      print('Error saving language: $e');
      return false;
    }
  }

  static Future<String?> getLanguage() async {
    await _ensureInitialized();
    try {
      return _prefs.getString(_languageKey);
    } catch (e) {
      print('Error getting language: $e');
      return null;
    }
  }

  // Clear all data (logout)
  static Future<bool> clearAllData() async {
    await _ensureInitialized();
    try {
      return await _prefs.clear();
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }

  // Check if user data exists and is valid
  static Future<bool> hasValidUserData() async {
    await _ensureInitialized();
    try {
      final user = await getUser();
      if (user == null) return false;
      
      // Check if user has required fields
      if (user.id.isEmpty || user.email.isEmpty) return false;
      
      // Check if last login was within reasonable time (e.g., 30 days)
      final lastLogin = await getLastLogin();
      if (lastLogin != null) {
        final daysSinceLogin = DateTime.now().difference(lastLogin).inDays;
        if (daysSinceLogin > 30) {
          // Data is too old, clear it
          await clearAllData();
          return false;
        }
      }
      
      return true;
    } catch (e) {
      print('Error checking valid user data: $e');
      return false;
    }
  }

  // Get storage statistics
  static Future<Map<String, dynamic>> getStorageStats() async {
    await _ensureInitialized();
    try {
      final keys = _prefs.getKeys();
      final stats = <String, dynamic>{
        'total_keys': keys.length,
        'user_data_exists': await getUser() != null,
        'auth_token_exists': await getAuthToken() != null,
        'is_authenticated': await isAuthenticated(),
        'auth_provider': await getAuthProvider(),
        'last_login': await getLastLogin(),
        'settings_count': (await getSettings()).length,
        'theme': await getTheme(),
        'language': await getLanguage(),
      };
      return stats;
    } catch (e) {
      print('Error getting storage stats: $e');
      return {};
    }
  }

  // Ensure storage is initialized
  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }
}
