import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static bool _initialized = false;
  static bool _envLoaded = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Try to load .env file (works in local development)
      await dotenv.load();
      _envLoaded = true;
      print('✅ Development mode: loaded .env file');
    } catch (e) {
      // .env file not found or couldn't be loaded (production)
      _envLoaded = false;
      print('📦 Production mode: using --dart-define values');
    }
    
    _initialized = true;
  }

    /// Get FLUTTER_WEB environment variable from either .env file or --dart-define
  static String get flutterWeb {
    // First try --dart-define (used in production/Amplify)
    const dartDefineValue = String.fromEnvironment('FLUTTER_WEB');
    if (dartDefineValue.isNotEmpty && dartDefineValue != 'FLUTTER_WEB') {
      return dartDefineValue;
    }
    
    // Then try .env file (used in local development)
    if (_envLoaded) {
      return dotenv.env['FLUTTER_WEB'] ?? 'not set';
    }
    
    return 'not set';
  }

  /// Get specific environment variables (add more as needed)
  static String get apiBaseUrl {
    const dartDefineValue = String.fromEnvironment('API_BASE_URL');
    if (dartDefineValue.isNotEmpty && dartDefineValue != 'API_BASE_URL') {
      return dartDefineValue;
    }
    if (_envLoaded) {
      return dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';
    }
    return 'https://api.example.com';
  }

  /// Check if we're in development mode (has .env file)
  static bool get isDevelopment {
    return _envLoaded;
  }
}
