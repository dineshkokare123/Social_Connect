# Implementation Plan - CI/CD & Secrets

## Completed Tasks
- [x] **Profile Service & Screens**: Real-time data integration, `StreamBuilder`, `ProfileService` with `createProfile`.
- [x] **Authentication**: Fixed `Firebase.initializeApp`, switched to real `FirebaseAuth`, updated `LoginScreen` and `SignUpScreen`.
- [x] **CI/CD**: Updated `flutter_ci.yml` to handle secure files (`.env`, `google-services.json`) using GitHub Secrets.

## Action Required: Set up GitHub Secrets
To make the CI pipeline pass, you must add the following secrets to your GitHub repository settings (Settings > Secrets and variables > Actions):

1.  **`ENV_FILE`**:
    -   Copy the content of your local `.env` file.
    -   Paste it as the value for this secret.

2.  **`GOOGLE_SERVICES_JSON`**:
    -   Locate your `android/app/google-services.json` file.
    -   Convert it to Base64. You can do this in your terminal:
        ```bash
        base64 -i android/app/google-services.json | pbcopy
        ```
        (On macOS, `pbcopy` copies it to clipboard. On Linux use `xclip` or just print it).
    -   Paste the Base64 string as the value for this secret.

## Next Steps
1.  **Edit Profile**: Implement the "Edit Profile" screen.
2.  **Stats Logic**: Implement logic to update user stats.
3.  **Social Login**: Implement Google/Apple Sign-In.
