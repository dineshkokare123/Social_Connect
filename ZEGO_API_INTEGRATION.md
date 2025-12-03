# ZegoSDK API Integration Guide

## Overview
Complete API integration for all ZegoSDK functionality including calls, live streaming, tutoring, and watch together features.

## Architecture

### Services Created
1. **ZegoApiService** - Handles all API calls for Zego features
2. **ZegoSessionManager** - Manages session lifecycle and tracking

## Features Integrated

### 1. Video/Audio Calls
**API Endpoints:**
- `POST /calls/create` - Create new call session
- `POST /calls/end` - End call session
- `GET /calls/history/:userId` - Get call history

**Usage:**
```dart
import 'package:social_connect/core/services/zego/zego_session_manager.dart';

final sessionManager = ZegoSessionManager();

// Start a call
final sessionId = await sessionManager.startCall(
  callerId: 'user123',
  receiverId: 'user456',
  callType: 'video', // or 'audio'
);

// End the call
await sessionManager.endCall();
```

### 2. Live Streaming
**API Endpoints:**
- `POST /live/create` - Create live room
- `POST /live/join` - Join live room
- `POST /live/leave` - Leave live room
- `GET /live/active` - Get active live rooms

**Usage:**
```dart
// Start live stream (Host)
final room = await sessionManager.startLiveStream(
  hostId: 'user123',
  roomName: 'My Live Stream',
  description: 'Gaming session',
);

// Join live stream (Audience)
await sessionManager.joinLiveStream(
  roomId: 'room123',
  userId: 'user456',
);

// Leave live stream
await sessionManager.leaveLiveStream('user456');
```

### 3. 1-on-1 Tutoring
**API Endpoints:**
- `POST /tutoring/create` - Create tutoring session
- `POST /tutoring/end` - End tutoring session
- `GET /tutoring/sessions/:userId` - Get tutoring sessions

**Usage:**
```dart
// Start tutoring session
final session = await sessionManager.startTutoringSession(
  tutorId: 'tutor123',
  studentId: 'student456',
  subject: 'Mathematics',
);

// End session with notes
await sessionManager.endTutoringSession(
  notes: 'Covered algebra basics',
);
```

### 4. Watch Together
**API Endpoints:**
- `POST /watch/create` - Create watch room
- `POST /watch/join` - Join watch room

**Usage:**
```dart
// Create watch room
final room = await sessionManager.startWatchTogether(
  hostId: 'user123',
  roomName: 'Movie Night',
  videoUrl: 'https://example.com/video.mp4',
);

// Join watch room
await sessionManager.joinWatchTogether(
  roomId: 'room123',
  userId: 'user456',
);
```

## Session Tracking

The `ZegoSessionManager` automatically tracks:
- Current session ID
- Session start time
- Session duration
- Room IDs

**Utility Methods:**
```dart
// Get current session duration
final duration = sessionManager.getSessionDuration();

// Check if in session
if (sessionManager.isInSession) {
  print('Active session: ${sessionManager.currentSessionId}');
}

// Clear session data
sessionManager.clearSession();
```

## Backend API Requirements

Your backend should implement these endpoints:

### Calls
```
POST /calls/create
Body: { callerId, receiverId, callType, timestamp }
Response: { sessionId, ... }

POST /calls/end
Body: { sessionId, duration, endTime }
Response: { success: true }

GET /calls/history/:userId
Response: { calls: [...] }
```

### Live Streaming
```
POST /live/create
Body: { hostId, roomName, description, startTime }
Response: { roomId, ... }

POST /live/join
Body: { roomId, userId, joinTime }
Response: { success: true }

POST /live/leave
Body: { roomId, userId, leaveTime }
Response: { success: true }

GET /live/active
Response: { rooms: [...] }
```

### Tutoring
```
POST /tutoring/create
Body: { tutorId, studentId, subject, startTime }
Response: { sessionId, ... }

POST /tutoring/end
Body: { sessionId, duration, notes, endTime }
Response: { success: true }

GET /tutoring/sessions/:userId
Response: { sessions: [...] }
```

### Watch Together
```
POST /watch/create
Body: { hostId, roomName, videoUrl, startTime }
Response: { roomId, ... }

POST /watch/join
Body: { roomId, userId, joinTime }
Response: { success: true }
```

### Additional Features
```
GET /rooms/:roomId/participants
Response: { participants: [...] }

POST /reports/create
Body: { reporterId, reportedUserId, reason, sessionId }
Response: { success: true }
```

## Integration with Zego UI Components

The API integration works seamlessly with existing Zego UI components:

### Example: Video Call with API Integration
```dart
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:social_connect/core/services/zego/zego_session_manager.dart';

class VideoCallScreen extends StatefulWidget {
  final String callId;
  final String userId;
  final String userName;
  final String receiverId;

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final sessionManager = ZegoSessionManager();
  String? sessionId;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    sessionId = await sessionManager.startCall(
      callerId: widget.userId,
      receiverId: widget.receiverId,
      callType: 'video',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: ZegoConfig.callAppId,
      appSign: ZegoConfig.callAppSign,
      userID: widget.userId,
      userName: widget.userName,
      callID: widget.callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onHangUp = () {
          sessionManager.endCall();
          Navigator.pop(context);
        },
    );
  }

  @override
  void dispose() {
    sessionManager.endCall();
    super.dispose();
  }
}
```

## Analytics & Reporting

Track important metrics:
- Call duration
- Live stream viewers
- Tutoring session completion
- User engagement

All automatically logged through the API integration.

## Error Handling

All methods return:
- `null` or `false` on error
- Errors are logged with `debugPrint`
- Safe to use without try-catch

```dart
final result = await sessionManager.startCall(...);
if (result == null) {
  // Handle error - show message to user
  print('Failed to start call');
}
```

## Security

- All API calls use authenticated requests (Bearer token)
- Session IDs are server-generated
- User validation on backend
- Rate limiting recommended

## Testing

Test with mock backend or use provided endpoints:
```dart
// In .env file
API_BASE_URL=http://localhost:3000/api
```

## Next Steps

1. Implement backend API endpoints
2. Test each feature
3. Add analytics dashboard
4. Implement push notifications for calls
5. Add call quality metrics

Your Zego integration is now fully connected to your backend API! 🚀
