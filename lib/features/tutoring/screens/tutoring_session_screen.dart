import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'dart:math';
import '../../../core/constants/zego_config.dart';

class TutoringSessionScreen extends StatelessWidget {
  final String sessionID;
  final bool isTutor;

  const TutoringSessionScreen({
    super.key,
    required this.sessionID,
    this.isTutor = false,
  });

  @override
  Widget build(BuildContext context) {
    final String userID = Random().nextInt(10000).toString();
    final String userName = isTutor ? 'Tutor_$userID' : 'Student_$userID';

    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: ZegoConfig.tutoringAppId,
        appSign: ZegoConfig.tutoringAppSign,
        userID: userID,
        userName: userName,
        conferenceID: sessionID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          turnOnCameraWhenJoining: true,
          turnOnMicrophoneWhenJoining: true,
          useSpeakerWhenJoining: true,
        ),
      ),
    );
  }
}
