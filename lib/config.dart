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

  /// Get FLUTTER_WEB environment variable from either .env file or --dart-define
  static String get flutterWeb {
    // First try --dart-define (used in production/Amplify)
    const dartDefineValue = String.fromEnvironment('FLUTTER_WEB');
    if (dartDefineValue.isNotEmpty && dartDefineValue != 'FLUTTER_WEB') {
      return dartDefineValue;
    }
    
    // Then try .env file (used in local development)
    return dotenv.env['FLUTTER_WEB'] ?? 'not set';
  }

  /// Get specific environment variables (add more as needed)
  static String get apiBaseUrl {
    const dartDefineValue = String.fromEnvironment('API_BASE_URL');
    if (dartDefineValue.isNotEmpty && dartDefineValue != 'API_BASE_URL') {
      return dartDefineValue;
    }
    return dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';
  }

  /// Check if we're in development mode (has .env file)
  static bool get isDevelopment {
    return dotenv.env.isNotEmpty;
  }
}