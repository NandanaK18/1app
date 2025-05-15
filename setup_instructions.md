# Supabase Google Authentication Setup Instructions

To complete the setup for Google Authentication with Supabase, you need to follow these steps:

## 1. Supabase Setup

1. **Create a Project in Supabase**:
   - Go to [Supabase Dashboard](https://supabase.com/)
   - Create a new project if you haven't already

2. **Configure Authentication**:
   - In your Supabase project, go to Authentication > Providers
   - Enable Google auth provider
   - You'll need to configure Google OAuth credentials (see next section)

## 2. Google OAuth Setup

1. **Create OAuth Credentials**:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or use an existing one
   - Navigate to APIs & Services > Credentials
   - Create OAuth client ID credentials (select "Web application" type)
   - Add authorized redirect URI: `https://YOUR_PROJECT_ID.supabase.co/auth/v1/callback`

2. **Add Configuration to Supabase**:
   - Copy the Client ID and Client Secret from Google Cloud Console
   - Paste them into the Google provider settings in Supabase Authentication section

## 3. Update Your Flutter Project

1. **Update `main.dart`**:
   - Replace the placeholder URL and anon key with your actual Supabase credentials:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

2. **Configure Android Platform**:
   - Create a new file at `android/app/src/main/res/values/strings.xml` with the following content:
   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <resources>
       <string name="app_name">Your App Name</string>
       <string name="server_client_id">YOUR_GOOGLE_CLIENT_ID</string>
   </resources>
   ```
   
   - Update `AndroidManifest.xml` to add necessary permissions:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   ```

3. **Configure iOS Platform** (if needed):
   - Update `ios/Runner/Info.plist` to add the following:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleTypeRole</key>
           <string>Editor</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
           </array>
       </dict>
   </array>
   ```

## 4. Testing

1. Run your app and test the Google Sign-In functionality
2. Check the Supabase Authentication dashboard to verify users are being created

## Troubleshooting

- Make sure your OAuth consent screen is properly configured in Google Cloud Console
- Verify that the redirect URI in Google Cloud Console matches your Supabase project
- Check for any errors in the Flutter console during sign-in attempts
