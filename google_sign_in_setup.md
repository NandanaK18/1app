# Google Sign-In Setup Guide

This guide explains how to set up Google Sign-In for your app across different platforms.

## 1. Create a Google Cloud Project

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project or select an existing one.
3. Navigate to **APIs & Services** > **OAuth consent screen**.
4. Configure the OAuth consent screen with your app information.
5. Navigate to **APIs & Services** > **Credentials**.

## 2. Create OAuth Client IDs

### Web Client ID

1. Click **Create Credentials** > **OAuth client ID**.
2. Select **Web application** as the application type.
3. Add your authorized JavaScript origins (e.g., `https://yourdomain.com`).
4. For development, add `http://localhost` and `http://localhost:port`.
5. Click **Create**.
6. Copy the generated client ID and replace it in the `auth_service.dart` file:

```dart
clientId: kIsWeb ? 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com' : null,
```

### Android Client ID

1. Click **Create Credentials** > **OAuth client ID**.
2. Select **Android** as the application type.
3. Enter your app's package name from your `AndroidManifest.xml`.
4. Provide a SHA-1 certificate fingerprint.
   - For development, you can generate it using:
     ```
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```
5. Click **Create**.
6. Copy the generated client ID and replace it in the `strings.xml` file:

```xml
<string name="server_client_id">YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com</string>
```

### iOS Client ID

1. Click **Create Credentials** > **OAuth client ID**.
2. Select **iOS** as the application type.
3. Enter your app's bundle ID from your Xcode project.
4. Click **Create**.
5. Copy the generated client ID.
6. For the reversed client ID (needed in Info.plist), take your client ID, e.g., `com.googleusercontent.apps.123456789-abcdefg`, and reverse it to: `com.googleusercontent.apps.YOUR_IOS_CLIENT_ID`.
7. Replace it in the `Info.plist` file:

```xml
<string>com.googleusercontent.apps.YOUR_IOS_CLIENT_ID</string>
```

## 3. Enable Google Sign-In API

1. In the Google Cloud Console, go to **APIs & Services** > **Library**.
2. Search for "Google Sign-In API" and enable it.

## 4. Testing

After you've configured all platforms, test the Google Sign-In functionality on each platform to ensure it works correctly.

## Troubleshooting

- **401 Error**: Ensure you've enabled the Google Sign-In API in your project.
- **iOS Sign-In Issues**: Check that your bundle ID matches exactly what you registered in the Google Cloud Console.
- **Android Sign-In Issues**: Verify that your SHA-1 fingerprint and package name are correct.
