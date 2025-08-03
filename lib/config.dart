import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static Future<void> initialize() async {
    try {
      // Try to load .env file (for local development)
      await dotenv.load(fileName: ".env");
    } catch (e) {
      // .env file not found or couldn't be loaded (likely in production)
      print('No .env file found, using --dart-define values');
    }
  }

  /// Get environment variable from either .env file or --dart-define
  static String get flutterWeb {
    // First try --dart-define (used in production/Amplify)
    const dartDefineValue = String.fromEnvironment('FLUTTER_WEB');
    if (dartDefineValue.isNotEmpty) {
      return dartDefineValue;
    }
    
    // Then try .env file (used in local development)
    return dotenv.env['FLUTTER_WEB'] ?? 'not set';
  }

  /// Get any environment variable by key
  static String getEnv(String key, {String defaultValue = 'not set'}) {
    // First try --dart-define
    const dartDefineValue = String.fromEnvironment(key);
    if (dartDefineValue.isNotEmpty) {
      return dartDefineValue;
    }
    
    // Then try .env file
    return dotenv.env[key] ?? defaultValue;
  }

  /// Check if we're in development mode (has .env file)
  static bool get isDevelopment {
    return dotenv.env.isNotEmpty;
  }
}