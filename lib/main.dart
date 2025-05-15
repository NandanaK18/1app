import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://ebppsqrlvjyiybsrjuzf.supabase.co', // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVicHBzcXJsdmp5aXlic3JqdXpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDU2MDksImV4cCI6MjA2MjgyMTYwOX0.bb7koAVkMTAegOKUiCmPEWqX8L8ECcxKNyTE8C45E5s', // Replace with your Supabase anon key
  );
  
  runApp(const NutritionTrackerApp());
}

class NutritionTrackerApp extends StatefulWidget {
  const NutritionTrackerApp({super.key});

  @override
  State<NutritionTrackerApp> createState() => _NutritionTrackerAppState();
}

class _NutritionTrackerAppState extends State<NutritionTrackerApp> {
  late final Stream<AuthState> _authStateStream;
  
  @override
  void initState() {
    super.initState();
    _authStateStream = Supabase.instance.client.auth.onAuthStateChange;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition Tracking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.black,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),      ),
      home: StreamBuilder<AuthState>(
        stream: _authStateStream,
        builder: (context, snapshot) {
          // Show loading indicator while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          // Check if user is authenticated
          final session = snapshot.data?.session;
          
          if (session != null) {
            // User is logged in, navigate to onboarding or home screen
            return const OnboardingScreen();
          } else {
            // User is not logged in, show login screen
            return const LoginScreen();
          }
        },
      ),
    );
  }
}

