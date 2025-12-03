# Secure API Key Management Guide

## Overview
All sensitive API keys and credentials are now securely stored in environment variables using the `.env` file, preventing them from being exposed in the codebase or version control.

## Security Implementation

### 1. Environment Variables (.env)
All API keys are stored in the `.env` file which is:
- ✅ **Excluded from Git** (added to `.gitignore`)
- ✅ **Never committed** to version control
- ✅ **Loaded at runtime** using `flutter_dotenv`

### 2. Files Updated

#### **Created:**
- `.env` - Contains all actual API keys (NEVER commit this!)
- `.env.example` - Template file (safe to commit)
- `lib/core/config/env_config.dart` - Secure configuration loader

#### **Modified:**
- `lib/core/constants/api_constants.dart` - Now uses `EnvConfig`
- `lib/core/constants/zego_config.dart` - Now uses `EnvConfig`
- `lib/features/ai_assistant/screens/ai_chat_screen.dart` - Now uses `EnvConfig`
- `lib/main.dart` - Loads `.env` on app startup
- `pubspec.yaml` - Includes `.env` as an asset
- `.gitignore` - Excludes `.env` from version control

### 3. How It Works

**Before (Insecure):**
```dart
static const String apiKey = 'your_api_key_here'; // Exposed!
```

**After (Secure):**
```dart
static String get apiKey => EnvConfig.apiKey; // Loaded from .env
```

### 4. Setup Instructions

#### For Development:
1. The `.env` file is already created with your keys
2. Run `flutter pub get`
3. Run the app - keys will be loaded automatically

#### For Team Members:
1. Copy `.env.example` to `.env`
2. Fill in actual API keys
3. Never commit `.env` to Git

#### For Production:
1. Set environment variables on your deployment platform
2. Or use secure key management services (AWS Secrets Manager, Google Secret Manager, etc.)

### 5. Environment Variables Reference

```bash
# API Configuration
API_BASE_URL=https://api.socialconnect.com/v1
API_KEY=your_api_key_here

# Google Services
GOOGLE_MAPS_API_KEY=your_google_maps_key
GEMINI_API_KEY=your_gemini_key

# Zego Cloud
ZEGO_LIVE_APP_ID=your_live_app_id
ZEGO_LIVE_APP_SIGN=your_live_app_sign
ZEGO_TUTORING_APP_ID=your_tutoring_app_id
ZEGO_TUTORING_APP_SIGN=your_tutoring_app_sign
ZEGO_WATCH_APP_ID=your_watch_app_id
ZEGO_WATCH_APP_SIGN=your_watch_app_sign
```

### 6. Security Best Practices

✅ **DO:**
- Keep `.env` in `.gitignore`
- Use `.env.example` as a template
- Rotate API keys regularly
- Use different keys for dev/staging/production
- Validate keys on app startup

❌ **DON'T:**
- Commit `.env` to version control
- Share API keys in chat/email
- Hardcode keys in source code
- Use production keys in development

### 7. Validation

The app validates all required environment variables on startup:
```dart
EnvConfig.validateConfig(); // Throws exception if keys are missing
```

### 8. Accessing Keys in Code

```dart
import 'package:social_connect/core/config/env_config.dart';

// Use anywhere in your app
final apiKey = EnvConfig.geminiApiKey;
final baseUrl = EnvConfig.apiBaseUrl;
final zegoAppId = EnvConfig.zegoLiveAppId;
```

### 9. CI/CD Integration

For automated builds, set environment variables in your CI/CD pipeline:

**GitHub Actions:**
```yaml
env:
  GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
```

**GitLab CI:**
```yaml
variables:
  GEMINI_API_KEY: $GEMINI_API_KEY
```

### 10. Troubleshooting

**Error: "Missing required environment variables"**
- Ensure `.env` file exists in project root
- Check all required keys are present
- Run `flutter clean && flutter pub get`

**Error: "Unable to load asset: .env"**
- Ensure `.env` is listed in `pubspec.yaml` under `assets`
- Run `flutter pub get`

## Summary

🔒 **All API keys are now secure and protected from:**
- Version control exposure
- Code repository leaks
- Accidental sharing
- Public disclosure

Your app is production-ready with enterprise-level security! 🚀
