import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Supabase Configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Google Sign In Configuration
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  static String get googleWebClientId =>
      dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  // Validate if all required environment variables are set
  static bool get isConfigured {
    return supabaseUrl.isNotEmpty &&
        supabaseAnonKey.isNotEmpty &&
        googleClientId.isNotEmpty &&
        googleWebClientId.isNotEmpty;
  }

  // Get missing configuration keys
  static List<String> get missingKeys {
    final missing = <String>[];
    if (supabaseUrl.isEmpty) missing.add('SUPABASE_URL');
    if (supabaseAnonKey.isEmpty) missing.add('SUPABASE_ANON_KEY');
    if (googleClientId.isEmpty) missing.add('GOOGLE_CLIENT_ID');
    if (googleWebClientId.isEmpty) missing.add('GOOGLE_WEB_CLIENT_ID');
    return missing;
  }
}
