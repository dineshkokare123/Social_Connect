import '../config/env_config.dart';

class ZegoConfig {
  // Live Streaming credentials (loaded from .env)
  static int get liveStreamingAppId => EnvConfig.zegoLiveAppId;
  static String get liveStreamingAppSign => EnvConfig.zegoLiveAppSign;

  // 1-on-1 Tutoring credentials (loaded from .env)
  static int get tutoringAppId => EnvConfig.zegoTutoringAppId;
  static String get tutoringAppSign => EnvConfig.zegoTutoringAppSign;

  // Watch Together credentials (loaded from .env)
  static int get watchTogetherAppId => EnvConfig.zegoWatchAppId;
  static String get watchTogetherAppSign => EnvConfig.zegoWatchAppSign;
}
