import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_models.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  // Get user profile
  Future<User?> getUserProfile() async {
    try {
      final response = await _apiService.get(ApiConstants.userProfile);
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(
        ApiConstants.updateProfile,
        data: data,
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  // Upload avatar
  Future<String?> uploadAvatar(String filePath) async {
    try {
      final response = await _apiService.uploadFile(
        ApiConstants.uploadAvatar,
        filePath,
      );
      if (response.statusCode == 200) {
        return response.data['avatarUrl'];
      }
      return null;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      return null;
    }
  }

  // Get all users
  Future<List<User>> getUsers() async {
    try {
      final response = await _apiService.get(ApiConstants.users);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['users'] ?? response.data;
        return data.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting users: $e');
      return [];
    }
  }
}

class PostRepository {
  final ApiService _apiService = ApiService();

  // Get all posts
  Future<List<Post>> getPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiService.get(
        ApiConstants.posts,
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['posts'] ?? response.data;
        return data.map((json) => Post.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting posts: $e');
      return [];
    }
  }

  // Create post
  Future<Post?> createPost(String content, {List<String>? images}) async {
    try {
      final response = await _apiService.post(
        ApiConstants.createPost,
        data: {'content': content, 'images': images ?? []},
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Post.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error creating post: $e');
      return null;
    }
  }

  // Like post
  Future<bool> likePost(String postId) async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.likePost}/$postId',
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error liking post: $e');
      return false;
    }
  }
}

class ChatRepository {
  final ApiService _apiService = ApiService();

  // Get messages
  Future<List<Message>> getMessages(String userId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.messages}/$userId',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['messages'] ?? response.data;
        return data.map((json) => Message.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return [];
    }
  }

  // Send message
  Future<Message?> sendMessage(
    String receiverId,
    String content, {
    String? imageUrl,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.sendMessage,
        data: {
          'receiverId': receiverId,
          'content': content,
          'imageUrl': imageUrl,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Message.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return null;
    }
  }

  // Get chats
  Future<List<dynamic>> getChats() async {
    try {
      final response = await _apiService.get(ApiConstants.chats);
      if (response.statusCode == 200) {
        return response.data['chats'] ?? response.data;
      }
      return [];
    } catch (e) {
      debugPrint('Error getting chats: $e');
      return [];
    }
  }
}

class ReelRepository {
  final ApiService _apiService = ApiService();

  // Get reels
  Future<List<Reel>> getReels({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiService.get(
        ApiConstants.reels,
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['reels'] ?? response.data;
        return data.map((json) => Reel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting reels: $e');
      return [];
    }
  }

  // Upload reel
  Future<Reel?> uploadReel(String videoPath, String description) async {
    try {
      final response = await _apiService.uploadFile(
        ApiConstants.uploadReel,
        videoPath,
        additionalData: {'description': description},
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Reel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error uploading reel: $e');
      return null;
    }
  }
}
