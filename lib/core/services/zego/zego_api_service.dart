import 'package:flutter/foundation.dart';
import '../api_service.dart';

class ZegoApiService {
  final ApiService _apiService = ApiService();

  // Create a call session
  Future<Map<String, dynamic>?> createCallSession({
    required String callerId,
    required String receiverId,
    required String callType, // 'audio' or 'video'
  }) async {
    try {
      final response = await _apiService.post(
        '/calls/create',
        data: {
          'callerId': callerId,
          'receiverId': receiverId,
          'callType': callType,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating call session: $e');
      return null;
    }
  }

  // End call session
  Future<bool> endCallSession({
    required String sessionId,
    required int duration,
  }) async {
    try {
      final response = await _apiService.post(
        '/calls/end',
        data: {
          'sessionId': sessionId,
          'duration': duration,
          'endTime': DateTime.now().toIso8601String(),
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error ending call session: $e');
      return false;
    }
  }

  // Create live streaming room
  Future<Map<String, dynamic>?> createLiveRoom({
    required String hostId,
    required String roomName,
    String? description,
  }) async {
    try {
      final response = await _apiService.post(
        '/live/create',
        data: {
          'hostId': hostId,
          'roomName': roomName,
          'description': description,
          'startTime': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating live room: $e');
      return null;
    }
  }

  // Join live room
  Future<bool> joinLiveRoom({
    required String roomId,
    required String userId,
  }) async {
    try {
      final response = await _apiService.post(
        '/live/join',
        data: {
          'roomId': roomId,
          'userId': userId,
          'joinTime': DateTime.now().toIso8601String(),
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error joining live room: $e');
      return false;
    }
  }

  // Leave live room
  Future<bool> leaveLiveRoom({
    required String roomId,
    required String userId,
  }) async {
    try {
      final response = await _apiService.post(
        '/live/leave',
        data: {
          'roomId': roomId,
          'userId': userId,
          'leaveTime': DateTime.now().toIso8601String(),
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error leaving live room: $e');
      return false;
    }
  }

  // Get active live rooms
  Future<List<dynamic>> getActiveLiveRooms() async {
    try {
      final response = await _apiService.get('/live/active');
      if (response.statusCode == 200) {
        return response.data['rooms'] ?? response.data;
      }
      return [];
    } catch (e) {
      debugPrint('Error getting active live rooms: $e');
      return [];
    }
  }

  // Create tutoring session
  Future<Map<String, dynamic>?> createTutoringSession({
    required String tutorId,
    required String studentId,
    required String subject,
  }) async {
    try {
      final response = await _apiService.post(
        '/tutoring/create',
        data: {
          'tutorId': tutorId,
          'studentId': studentId,
          'subject': subject,
          'startTime': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating tutoring session: $e');
      return null;
    }
  }

  // End tutoring session
  Future<bool> endTutoringSession({
    required String sessionId,
    required int duration,
    String? notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/tutoring/end',
        data: {
          'sessionId': sessionId,
          'duration': duration,
          'notes': notes,
          'endTime': DateTime.now().toIso8601String(),
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error ending tutoring session: $e');
      return false;
    }
  }

  // Create watch together room
  Future<Map<String, dynamic>?> createWatchRoom({
    required String hostId,
    required String roomName,
    String? videoUrl,
  }) async {
    try {
      final response = await _apiService.post(
        '/watch/create',
        data: {
          'hostId': hostId,
          'roomName': roomName,
          'videoUrl': videoUrl,
          'startTime': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating watch room: $e');
      return null;
    }
  }

  // Join watch room
  Future<bool> joinWatchRoom({
    required String roomId,
    required String userId,
  }) async {
    try {
      final response = await _apiService.post(
        '/watch/join',
        data: {
          'roomId': roomId,
          'userId': userId,
          'joinTime': DateTime.now().toIso8601String(),
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error joining watch room: $e');
      return false;
    }
  }

  // Get call history
  Future<List<dynamic>> getCallHistory(String userId) async {
    try {
      final response = await _apiService.get('/calls/history/$userId');
      if (response.statusCode == 200) {
        return response.data['calls'] ?? response.data;
      }
      return [];
    } catch (e) {
      debugPrint('Error getting call history: $e');
      return [];
    }
  }

  // Get tutoring sessions
  Future<List<dynamic>> getTutoringSessions(String userId) async {
    try {
      final response = await _apiService.get('/tutoring/sessions/$userId');
      if (response.statusCode == 200) {
        return response.data['sessions'] ?? response.data;
      }
      return [];
    } catch (e) {
      debugPrint('Error getting tutoring sessions: $e');
      return [];
    }
  }

  // Report user in call/room
  Future<bool> reportUser({
    required String reporterId,
    required String reportedUserId,
    required String reason,
    String? sessionId,
  }) async {
    try {
      final response = await _apiService.post(
        '/reports/create',
        data: {
          'reporterId': reporterId,
          'reportedUserId': reportedUserId,
          'reason': reason,
          'sessionId': sessionId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint('Error reporting user: $e');
      return false;
    }
  }

  // Get room participants
  Future<List<dynamic>> getRoomParticipants(String roomId) async {
    try {
      final response = await _apiService.get('/rooms/$roomId/participants');
      if (response.statusCode == 200) {
        return response.data['participants'] ?? response.data;
      }
      return [];
    } catch (e) {
      debugPrint('Error getting room participants: $e');
      return [];
    }
  }
}
