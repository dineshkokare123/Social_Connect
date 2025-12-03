class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      bio: json['bio'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Post {
  final String id;
  final String userId;
  final String content;
  final List<String> images;
  final int likes;
  final int comments;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    this.images = const [],
    this.likes = 0,
    this.comments = 0,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'images': images,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String? imageUrl;
  final bool isRead;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.imageUrl,
    this.isRead = false,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? json['_id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'imageUrl': imageUrl,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Reel {
  final String id;
  final String userId;
  final String videoUrl;
  final String description;
  final int likes;
  final int views;
  final DateTime createdAt;

  Reel({
    required this.id,
    required this.userId,
    required this.videoUrl,
    required this.description,
    this.likes = 0,
    this.views = 0,
    required this.createdAt,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      description: json['description'] ?? '',
      likes: json['likes'] ?? 0,
      views: json['views'] ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'videoUrl': videoUrl,
      'description': description,
      'likes': likes,
      'views': views,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
