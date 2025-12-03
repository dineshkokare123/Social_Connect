import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'dart:math';
import '../../../core/constants/zego_config.dart';

class WatchRoomScreen extends StatelessWidget {
  final String roomID;
  final String? videoUrl;
  final bool isHost;

  const WatchRoomScreen({
    super.key,
    required this.roomID,
    this.videoUrl,
    this.isHost = false,
  });

  @override
  Widget build(BuildContext context) {
    final String userID = Random().nextInt(10000).toString();
    final String userName = 'User_$userID';

    return Scaffold(
      appBar: AppBar(
        title: Text('Watch Room: $roomID'),
        backgroundColor: const Color(0xFF121212),
      ),
      body: Column(
        children: [
          // Video Conference Area (for video chat while watching)
          Expanded(
            flex: 2,
            child: SafeArea(
              child: ZegoUIKitPrebuiltVideoConference(
                appID: ZegoConfig.watchTogetherAppId,
                appSign: ZegoConfig.watchTogetherAppSign,
                userID: userID,
                userName: userName,
                conferenceID: roomID,
                config: ZegoUIKitPrebuiltVideoConferenceConfig(
                  turnOnCameraWhenJoining: true,
                  turnOnMicrophoneWhenJoining: true,
                  useSpeakerWhenJoining: true,
                ),
              ),
            ),
          ),
          // Video Player Area (placeholder for synchronized video playback)
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_outline,
                      size: 80,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      videoUrl != null && videoUrl!.isNotEmpty
                          ? 'Video Player\n$videoUrl'
                          : 'No video selected',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isHost ? 'You are the host' : 'Waiting for host',
                      style: TextStyle(
                        color: isHost
                            ? const Color(0xFF6C63FF)
                            : const Color(0xFF03DAC6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Note: Video player integration requires additional packages like video_player or youtube_player_flutter for full functionality.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
