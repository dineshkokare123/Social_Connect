import '../config/env_config.dart';

class ApiConstants {
  // Base URL - Now loaded from environment variables
  static String get baseUrl => EnvConfig.apiBaseUrl;

  // Alternative: Use your own backend URL (set in .env file)
  // API_BASE_URL=http://localhost:3000/api

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // User Endpoints
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile/update';
  static const String uploadAvatar = '/users/avatar';

  // Chat Endpoints
  static const String chats = '/chats';
  static const String messages = '/messages';
  static const String sendMessage = '/messages/send';

  // Posts/Feed Endpoints
  static const String posts = '/posts';
  static const String createPost = '/posts/create';
  static const String likePost = '/posts/like';
  static const String commentPost = '/posts/comment';

  // Reels/Moments Endpoints
  static const String reels = '/reels';
  static const String uploadReel = '/reels/upload';

  // Friends Endpoints
  static const String friends = '/friends';
  static const String friendRequests = '/friends/requests';
  static const String sendFriendRequest = '/friends/request';
  static const String acceptFriendRequest = '/friends/accept';

  // Status Endpoints
  static const String status = '/status';
  static const String createStatus = '/status/create';

  // Notifications
  static const String notifications = '/notifications';

  // Zego/Call Endpoints
  static const String createCall = '/calls/create';
  static const String endCall = '/calls/end';
  static const String callHistory = '/calls/history';

  // Live Streaming Endpoints
  static const String createLiveRoom = '/live/create';
  static const String joinLiveRoom = '/live/join';
  static const String leaveLiveRoom = '/live/leave';
  static const String activeLiveRooms = '/live/active';

  // Tutoring Endpoints
  static const String createTutoringSession = '/tutoring/create';
  static const String endTutoringSession = '/tutoring/end';
  static const String tutoringSessions = '/tutoring/sessions';

  // Watch Together Endpoints
  static const String createWatchRoom = '/watch/create';
  static const String joinWatchRoom = '/watch/join';
  static const String leaveWatchRoom = '/watch/leave';

  // Room Management
  static const String roomParticipants = '/rooms';
  static const String reportUser = '/reports/create';

  // API Keys (loaded from environment variables)
  static String get apiKey => EnvConfig.apiKey;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
