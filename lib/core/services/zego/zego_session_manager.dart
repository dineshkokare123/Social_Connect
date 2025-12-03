import 'package:flutter/foundation.dart';
import 'zego_api_service.dart';

class ZegoSessionManager {
  final ZegoApiService _apiService = ZegoApiService();

  // Current session tracking
  String? _currentSessionId;
  DateTime? _sessionStartTime;
  String? _currentRoomId;

  // Call session management
  Future<String?> startCall({
    required String callerId,
    required String receiverId,
    required String callType,
  }) async {
    try {
      final result = await _apiService.createCallSession(
        callerId: callerId,
        receiverId: receiverId,
        callType: callType,
      );

      if (result != null) {
        _currentSessionId = result['sessionId'] ?? result['id'];
        _sessionStartTime = DateTime.now();
        debugPrint('Call session started: $_currentSessionId');
        return _currentSessionId;
      }
      return null;
    } catch (e) {
      debugPrint('Error starting call: $e');
      return null;
    }
  }

  Future<bool> endCall() async {
    if (_currentSessionId == null || _sessionStartTime == null) {
      return false;
    }

    try {
      final duration = DateTime.now().difference(_sessionStartTime!).inSeconds;
      final success = await _apiService.endCallSession(
        sessionId: _currentSessionId!,
        duration: duration,
      );

      if (success) {
        debugPrint('Call ended. Duration: $duration seconds');
        _currentSessionId = null;
        _sessionStartTime = null;
      }
      return success;
    } catch (e) {
      debugPrint('Error ending call: $e');
      return false;
    }
  }

  // Live streaming session management
  Future<Map<String, dynamic>?> startLiveStream({
    required String hostId,
    required String roomName,
    String? description,
  }) async {
    try {
      final result = await _apiService.createLiveRoom(
        hostId: hostId,
        roomName: roomName,
        description: description,
      );

      if (result != null) {
        _currentRoomId = result['roomId'] ?? result['id'];
        _sessionStartTime = DateTime.now();
        debugPrint('Live stream started: $_currentRoomId');
        return result;
      }
      return null;
    } catch (e) {
      debugPrint('Error starting live stream: $e');
      return null;
    }
  }

  Future<bool> joinLiveStream({
    required String roomId,
    required String userId,
  }) async {
    try {
      final success = await _apiService.joinLiveRoom(
        roomId: roomId,
        userId: userId,
      );

      if (success) {
        _currentRoomId = roomId;
        debugPrint('Joined live stream: $roomId');
      }
      return success;
    } catch (e) {
      debugPrint('Error joining live stream: $e');
      return false;
    }
  }

  Future<bool> leaveLiveStream(String userId) async {
    if (_currentRoomId == null) return false;

    try {
      final success = await _apiService.leaveLiveRoom(
        roomId: _currentRoomId!,
        userId: userId,
      );

      if (success) {
        debugPrint('Left live stream: $_currentRoomId');
        _currentRoomId = null;
        _sessionStartTime = null;
      }
      return success;
    } catch (e) {
      debugPrint('Error leaving live stream: $e');
      return false;
    }
  }

  // Tutoring session management
  Future<Map<String, dynamic>?> startTutoringSession({
    required String tutorId,
    required String studentId,
    required String subject,
  }) async {
    try {
      final result = await _apiService.createTutoringSession(
        tutorId: tutorId,
        studentId: studentId,
        subject: subject,
      );

      if (result != null) {
        _currentSessionId = result['sessionId'] ?? result['id'];
        _sessionStartTime = DateTime.now();
        debugPrint('Tutoring session started: $_currentSessionId');
        return result;
      }
      return null;
    } catch (e) {
      debugPrint('Error starting tutoring session: $e');
      return null;
    }
  }

  Future<bool> endTutoringSession({String? notes}) async {
    if (_currentSessionId == null || _sessionStartTime == null) {
      return false;
    }

    try {
      final duration = DateTime.now().difference(_sessionStartTime!).inSeconds;
      final success = await _apiService.endTutoringSession(
        sessionId: _currentSessionId!,
        duration: duration,
        notes: notes,
      );

      if (success) {
        debugPrint('Tutoring session ended. Duration: $duration seconds');
        _currentSessionId = null;
        _sessionStartTime = null;
      }
      return success;
    } catch (e) {
      debugPrint('Error ending tutoring session: $e');
      return false;
    }
  }

  // Watch together session management
  Future<Map<String, dynamic>?> startWatchTogether({
    required String hostId,
    required String roomName,
    String? videoUrl,
  }) async {
    try {
      final result = await _apiService.createWatchRoom(
        hostId: hostId,
        roomName: roomName,
        videoUrl: videoUrl,
      );

      if (result != null) {
        _currentRoomId = result['roomId'] ?? result['id'];
        _sessionStartTime = DateTime.now();
        debugPrint('Watch together room created: $_currentRoomId');
        return result;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating watch together room: $e');
      return null;
    }
  }

  Future<bool> joinWatchTogether({
    required String roomId,
    required String userId,
  }) async {
    try {
      final success = await _apiService.joinWatchRoom(
        roomId: roomId,
        userId: userId,
      );

      if (success) {
        _currentRoomId = roomId;
        debugPrint('Joined watch together room: $roomId');
      }
      return success;
    } catch (e) {
      debugPrint('Error joining watch together room: $e');
      return false;
    }
  }

  // Utility methods
  int? getSessionDuration() {
    if (_sessionStartTime == null) return null;
    return DateTime.now().difference(_sessionStartTime!).inSeconds;
  }

  String? get currentSessionId => _currentSessionId;
  String? get currentRoomId => _currentRoomId;
  bool get isInSession => _currentSessionId != null || _currentRoomId != null;

  void clearSession() {
    _currentSessionId = null;
    _currentRoomId = null;
    _sessionStartTime = null;
  }
}
