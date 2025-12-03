# Social Connect - Flutter Social App

A feature-rich social messaging app built with Flutter that includes:

## Features

✅ **Authentication** - User login/signup
✅ **Real-time Messaging** - Send text messages
✅ **Image Sharing** - Share photos from gallery
✅ **Audio Recording** - Record and send voice messages
✅ **Video/Audio Calls** - Make video and voice calls
✅ **Live Location** - Share and view real-time location on map
✅ **Group Chat** - Create groups with multiple members
✅ **Modern UI** - Dark theme with glassmorphism effects

## Tech Stack

- **Flutter** - Cross-platform framework
- **Provider** - State management
- **Google Maps** - Live location tracking
- **ZEGOCLOUD** - Video/audio calling
- **Firebase** (Ready to integrate) - Backend services
- **Google Fonts** - Beautiful typography

## Setup Instructions

### 1. Install Dependencies

```bash
cd social_connect
flutter pub get
```

### 2. Configure Google Maps API

#### Android
1. Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Open `android/app/src/main/AndroidManifest.xml`
3. Add your API key:

```xml
<application>
    <!-- Add this inside application tag -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
</application>
```

#### iOS
1. Open `ios/Runner/AppDelegate.swift`
2. Add at the top:

```swift
import GoogleMaps
```

3. In the `application` function, add:

```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

### 3. Configure ZEGOCLOUD for Video Calls

1. Sign up at [ZEGOCLOUD Console](https://console.zegocloud.com/)
2. Create a new project and get your App ID and App Sign
3. Open `lib/features/call/screens/video_call_screen.dart`
4. Replace the placeholder values:

```dart
const int appID = YOUR_APP_ID; // Replace with your App ID
const String appSign = 'YOUR_APP_SIGN'; // Replace with your App Sign
```

### 4. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   └── theme/
│       └── app_theme.dart
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   │   └── login_screen.dart
│   │   └── services/
│   │       └── auth_service.dart
│   ├── chat/
│   │   └── screens/
│   │       ├── chat_list_screen.dart
│   │       └── chat_detail_screen.dart
│   ├── call/
│   │   └── screens/
│   │       ├── call_history_screen.dart
│   │       └── video_call_screen.dart
│   ├── map/
│   │   └── screens/
│   │       └── map_screen.dart
│   ├── group/
│   │   └── screens/
│   │       └── create_group_screen.dart
│   └── home/
│       └── screens/
│           └── home_screen.dart
└── main.dart
```

## Permissions

The app requires the following permissions:

### Android
- Internet
- Location (Fine & Coarse)
- Camera
- Microphone
- Storage (Read/Write)

### iOS
- Location When In Use
- Camera
- Microphone
- Photo Library

All permissions are already configured in the manifest files.

## Features Breakdown

### 1. Messaging
- Real-time text messaging
- Image sharing from gallery
- Voice message recording
- Message bubbles with timestamps

### 2. Calls
- Video calling
- Audio calling
- Call history
- ZEGOCLOUD integration for high-quality calls

### 3. Live Location
- Real-time location tracking
- Google Maps integration
- Location sharing with friends
- Auto-updating markers

### 4. Groups
- Create groups
- Add multiple members
- Group messaging (ready to implement)

## Next Steps

To make this a production-ready app, consider:

1. **Firebase Integration**
   - Set up Firebase Authentication
   - Use Firestore for real-time messaging
   - Store user data and chat history

2. **Push Notifications**
   - Add Firebase Cloud Messaging
   - Notify users of new messages

3. **Profile Management**
   - User profiles with avatars
   - Status updates
   - Settings page

4. **Enhanced Features**
   - Message reactions
   - Read receipts
   - Typing indicators
   - File sharing

## Testing

For testing without full setup:
- Login screen accepts any email/password
- Mock data is used for chat lists
- Location requires actual device permissions

## Troubleshooting

**Issue: Google Maps not showing**
- Ensure you've added a valid API key
- Enable Maps SDK for Android/iOS in Google Cloud Console
- Check that billing is enabled

**Issue: Video calls not working**
- Verify ZEGOCLOUD credentials
- Check camera/microphone permissions
- Test on physical device (not emulator)

**Issue: Location not updating**
- Grant location permissions
- Test on physical device
- Check GPS is enabled

## License

MIT License - Feel free to use this project for learning or commercial purposes.

## Support

For issues or questions, please create an issue in the repository.
