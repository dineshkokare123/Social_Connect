import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // API Configuration
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.socialconnect.com/v1';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  // Google Services
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // Zego Cloud - Live Streaming
  static int get zegoLiveAppId =>
      int.tryParse(dotenv.env['ZEGO_LIVE_APP_ID'] ?? '0') ?? 0;
  static String get zegoLiveAppSign => dotenv.env['ZEGO_LIVE_APP_SIGN'] ?? '';

  // Zego Cloud - Tutoring
  static int get zegoTutoringAppId =>
      int.tryParse(dotenv.env['ZEGO_TUTORING_APP_ID'] ?? '0') ?? 0;
  static String get zegoTutoringAppSign =>
      dotenv.env['ZEGO_TUTORING_APP_SIGN'] ?? '';

  // Zego Cloud - Watch Together
  static int get zegoWatchAppId =>
      int.tryParse(dotenv.env['ZEGO_WATCH_APP_ID'] ?? '0') ?? 0;
  static String get zegoWatchAppSign => dotenv.env['ZEGO_WATCH_APP_SIGN'] ?? '';

  // Validate that all required keys are present
  static bool validateConfig() {
    final missingKeys = <String>[];

    if (apiBaseUrl.isEmpty) missingKeys.add('API_BASE_URL');
    if (googleMapsApiKey.isEmpty) missingKeys.add('GOOGLE_MAPS_API_KEY');
    if (geminiApiKey.isEmpty) missingKeys.add('GEMINI_API_KEY');
    if (zegoLiveAppId == 0) missingKeys.add('ZEGO_LIVE_APP_ID');
    if (zegoLiveAppSign.isEmpty) missingKeys.add('ZEGO_LIVE_APP_SIGN');
    if (zegoTutoringAppId == 0) missingKeys.add('ZEGO_TUTORING_APP_ID');
    if (zegoTutoringAppSign.isEmpty) missingKeys.add('ZEGO_TUTORING_APP_SIGN');
    if (zegoWatchAppId == 0) missingKeys.add('ZEGO_WATCH_APP_ID');
    if (zegoWatchAppSign.isEmpty) missingKeys.add('ZEGO_WATCH_APP_SIGN');

    if (missingKeys.isNotEmpty) {
      throw Exception(
        'Missing required environment variables: ${missingKeys.join(', ')}',
      );
    }

    return true;
  }
}
