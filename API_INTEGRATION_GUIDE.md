# API Integration Guide

## Overview
This app now includes a complete API integration layer that can connect to any REST API backend.

## Setup Instructions

### 1. Configure Your API Base URL
Edit `lib/core/constants/api_constants.dart` and update the `baseUrl`:

```dart
static const String baseUrl = 'https://your-api-domain.com/api/v1';
```

For local development:
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

### 2. API Structure

The API integration includes:

#### **Services**
- `ApiService`: Core HTTP client using Dio
- `AuthRepository`: Authentication operations
- `UserRepository`: User profile management
- `PostRepository`: Social posts/feed
- `ChatRepository`: Messaging
- `ReelRepository`: Video reels/moments

#### **Models**
- `User`: User data model
- `Post`: Social post model
- `Message`: Chat message model
- `Reel`: Video reel model

### 3. Usage Examples

#### Authentication
```dart
import 'package:social_connect/core/services/auth_repository.dart';

final authRepo = AuthRepository();

// Login
final result = await authRepo.login('email@example.com', 'password');
if (result != null) {
  print('Logged in: ${result['user']}');
}

// Register
final registerResult = await authRepo.register('John Doe', 'email@example.com', 'password');
```

#### Get Posts
```dart
import 'package:social_connect/core/services/repositories.dart';

final postRepo = PostRepository();
final posts = await postRepo.getPosts(page: 1, limit: 20);
```

#### Send Message
```dart
import 'package:social_connect/core/services/repositories.dart';

final chatRepo = ChatRepository();
final message = await chatRepo.sendMessage('receiverId', 'Hello!');
```

#### Upload Reel
```dart
import 'package:social_connect/core/services/repositories.dart';

final reelRepo = ReelRepository();
final reel = await reelRepo.uploadReel('/path/to/video.mp4', 'My awesome reel!');
```

### 4. Expected API Response Format

Your backend should return JSON responses in this format:

#### Success Response
```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful"
}
```

#### Error Response
```json
{
  "success": false,
  "error": "Error message",
  "code": 400
}
```

### 5. Authentication Flow

1. User logs in → Receives JWT token
2. Token is automatically added to all subsequent requests
3. Token is stored in `ApiService`
4. On logout, token is cleared

### 6. Backend Requirements

Your API should support these endpoints:

**Authentication**
- POST `/auth/login` - Login
- POST `/auth/register` - Register
- POST `/auth/logout` - Logout
- POST `/auth/refresh` - Refresh token

**Users**
- GET `/users` - Get all users
- GET `/users/profile` - Get current user profile
- PUT `/users/profile/update` - Update profile
- POST `/users/avatar` - Upload avatar

**Posts**
- GET `/posts` - Get posts (with pagination)
- POST `/posts/create` - Create post
- POST `/posts/like/:id` - Like post

**Messages**
- GET `/messages/:userId` - Get messages with user
- POST `/messages/send` - Send message
- GET `/chats` - Get all chats

**Reels**
- GET `/reels` - Get reels (with pagination)
- POST `/reels/upload` - Upload reel

### 7. Testing Without Backend

For testing, you can use:
- **Mock API**: [JSONPlaceholder](https://jsonplaceholder.typicode.com/)
- **Firebase**: Already integrated in the app
- **Local Server**: Set up Node.js/Express backend

### 8. Error Handling

All repository methods include try-catch blocks and return:
- `null` for single items on error
- Empty list `[]` for collections on error
- `false` for boolean operations on error

### 9. Next Steps

1. Set up your backend API
2. Update `ApiConstants.baseUrl`
3. Test authentication flow
4. Integrate repositories into your UI screens
5. Add loading states and error handling in UI

## Notes

- All API calls are asynchronous
- Authentication token is managed automatically
- Dio interceptors log all requests/responses
- File uploads use multipart/form-data
- Supports pagination for lists
