import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  // Initialize Google Sign In with appropriate client IDs based on platform
  // A key difference is the serverClientId which is needed to get an ID token
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Web specific configuration
    clientId: kIsWeb ? '1092374278977-4sm3k4kb2u6iaeerjq7bjieau82jnuri.apps.googleusercontent.com' : null,
    // Server client ID is necessary for getting ID tokens
    serverClientId: '1092374278977-uf41bp3tqhrd45738gcb5n9dhuhlm889.apps.googleusercontent.com',
  );

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: userData,
    );
  }  // Sign in with Google
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      // Start the Google sign-in process with specific authentication
      // We need to request the serverAuthCode to get an ID token
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }
      
      // Get auth details from Google, specifically requesting ID token
      // The serverClientId configured in GoogleSignIn is essential for this to work
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Debug the available tokens
      print('Google Auth accessToken: ${googleAuth.accessToken != null ? "present" : "null"}');
      print('Google Auth idToken: ${googleAuth.idToken != null ? "present" : "null"}');
      
      // Check if ID token is available, which is required by Supabase
      if (googleAuth.idToken == null) {
        throw Exception("Failed to get ID token from Google. Please ensure you have the correct OAuth configuration with serverClientId.");
      }

      // Use the idToken to sign in with Supabase
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );
      
      return response;
    } catch (e) {
      print('Google Sign-In Error: ${e.toString()}');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
  }

  // Get auth state stream
  Stream<AuthState> get authStateStream => _supabase.auth.onAuthStateChange;
}

// Create a singleton instance of AuthService
final authService = AuthService();
