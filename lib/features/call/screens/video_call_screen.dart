import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallScreen extends StatelessWidget {
  final String callId;
  final String userName;
  final bool isVideoCall;

  const VideoCallScreen({
    super.key,
    required this.callId,
    required this.userName,
    this.isVideoCall = true,
  });

  @override
  Widget build(BuildContext context) {
    // ZEGOCLOUD credentials configured
    const int appID = 1374101907;
    const String appSign =
        'a3f5b73d2ece2bc4b1955097b152ae5144b8507be1441262a28081f102db1300';

    final String userId = DateTime.now().millisecondsSinceEpoch.toString();
    final String currentUserName = 'User_$userId';

    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: appID,
        appSign: appSign,
        userID: userId,
        userName: currentUserName,
        callID: callId,
        config: isVideoCall
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
      ),
    );
  }
}
