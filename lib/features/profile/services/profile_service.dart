import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/api_models.dart' as models;

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Stream of user profile data
  Stream<models.User?> getUserStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value(null);

    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return models.User.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    });
  }

  // Stream of user stats (posts, friends, calls)
  Stream<Map<String, String>> getUserStatsStream() {
    final uid = currentUserId;
    if (uid == null) {
      return Stream.value({'friends': '0', 'posts': '0', 'calls': '0'});
    }

    // Combine streams or just listen to a stats subcollection/document
    // For simplicity, we'll assume stats are stored in the user document or calculated
    // Here we'll try to count from collections if possible, or fallback to user doc fields

    return _firestore.collection('users').doc(uid).snapshots().asyncMap((
      userDoc,
    ) async {
      int friendsCount = 0;
      int postsCount = 0;
      int callsCount = 0;

      if (userDoc.exists) {
        final data = userDoc.data();
        // If stats are pre-calculated in user doc
        if (data != null) {
          friendsCount = data['friendsCount'] ?? 0;
          postsCount = data['postsCount'] ?? 0;
          callsCount = data['callsCount'] ?? 0;
        }
      }

      // Alternatively, count documents (more expensive, but "real-time" accurate)
      // For now, let's assume we want to read from the user document for efficiency
      // If you want to count real documents:
      // final postsQuery = await _firestore.collection('posts').where('userId', isEqualTo: uid).count().get();
      // postsCount = postsQuery.count;

      return {
        'friends': friendsCount.toString(),
        'posts': postsCount.toString(),
        'calls': callsCount.toString(),
      };
    });
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? bio,
    String? avatarUrl,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;

    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (bio != null) data['bio'] = bio;
    if (avatarUrl != null) data['avatar'] = avatarUrl;

    await _firestore
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true));

    // Also update FirebaseAuth profile
    if (name != null || avatarUrl != null) {
      if (name != null) await _auth.currentUser?.updateDisplayName(name);
      if (avatarUrl != null) await _auth.currentUser?.updatePhotoURL(avatarUrl);
    }
  }

  // Create initial profile after signup
  Future<void> createProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    final user = models.User(
      id: uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(uid).set({
      ...user.toJson(),
      'friendsCount': 0,
      'postsCount': 0,
      'callsCount': 0,
    });
  }
}
