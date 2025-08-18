class GoogleConfig {
  // ===== PRODUCTION CONFIGURATION =====
  // Real Google OAuth client IDs (replace with your actual IDs)
  static const String androidClientId = '175593111177-fovahbv3acldkbhftacomlqlmf185c4u.apps.googleusercontent.com';
  static const String webClientId = '175593111177-kv0ckiuviimavm52e3rn8kaa75kgu2qr.apps.googleusercontent.com';
  static const String iosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com'; // Add when you have iOS

  // SHA-1 fingerprint for Android (debug keystore)
  static const String debugSha1 = 'E1:64:E4:B8:C9:58:1E:C7:47:59:37:DA:D1:36:68:0A:FA:8E:FC:1B';
  static const String debugSha256 = 'YOUR_DEBUG_SHA256'; // Optional: add when you have it

  // OAuth scopes
  static const List<String> scopes = [
    'email',
    'profile',
    'openid',
  ];

  // ===== DEVELOPMENT CONFIGURATION =====
  // Set this to false when you have real Google OAuth client IDs
  static const bool useDevelopmentConfig = false;

  // Development client IDs (these are examples - replace with real ones)
  // For now, using a realistic format that will allow the app to run
  static const String devAndroidClientId = '123456789012-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com';
  static const String devWebClientId = '123456789012-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com';
  
  // ===== CONFIGURATION METHODS =====
  // Get the appropriate client ID based on configuration
  static String getClientId() {
    if (useDevelopmentConfig) {
      return devAndroidClientId;
    }
    return androidClientId;
  }
  
  // Get web client ID
  static String getWebClientId() {
    if (useDevelopmentConfig) {
      return devWebClientId;
    }
    return webClientId;
  }
  
  // Check if Google Sign-In is properly configured
  static bool get isConfigured {
    if (useDevelopmentConfig) {
      return devAndroidClientId != '123456789012-abcdefghijklmnopqrstuvwxyz.apps.googleusercontent.com' &&
             devAndroidClientId.isNotEmpty;
    }
    return androidClientId != 'YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com' &&
           androidClientId.isNotEmpty;
  }
  
  // Google Sign-In configuration
  static const Map<String, dynamic> signInConfig = {
    'scopes': scopes,
    'hostedDomain': '', // Leave empty for any domain
    'signInOption': 'standard', // 'standard' or 'games'
  };
}
