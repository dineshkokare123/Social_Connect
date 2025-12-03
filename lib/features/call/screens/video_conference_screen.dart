import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class VideoConferenceScreen extends StatelessWidget {
  final String conferenceId;
  final String userId;
  final String userName;

  const VideoConferenceScreen({
    super.key,
    required this.conferenceId,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    // ZEGOCLOUD Video Conference Credentials
    const int appID = 302161761;
    const String appSign =
        'ac8fe100e0e3f63552066e0ec4298ef787a552edf1467d53ea88101562336975';

    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: appID,
        appSign: appSign,
        userID: userId,
        userName: userName,
        conferenceID: conferenceId,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}
