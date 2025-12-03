import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'dart:math';
import '../../../core/constants/zego_config.dart';

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;

  const LivePage({super.key, required this.liveID, this.isHost = false});

  @override
  Widget build(BuildContext context) {
    final String userID = Random().nextInt(10000).toString();
    final String userName = 'User_$userID';

    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: ZegoConfig.liveStreamingAppId,
        appSign: ZegoConfig.liveStreamingAppSign,
        userID: userID,
        userName: userName,
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
