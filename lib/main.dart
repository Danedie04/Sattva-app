import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/habit_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_shell.dart';

void main() async {
  // Required before any async calls in main
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase — needs google-services.json / GoogleService-Info.plist
  await Firebase.initializeApp();

  runApp(const SattvaApp());
}

class SattvaApp extends StatelessWidget {
  const SattvaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitProvider(),
      child: MaterialApp(
        title: 'Sattva',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthGate(),
      ),
    );
  }
}

/// Listens to Firebase Auth state.
/// Shows AuthScreen when logged out, HomeShell when logged in.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still waiting for auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent),
            ),
          );
        }

        // User is signed in
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeShell();
        }

        // Not signed in — show login screen
        return const AuthScreen();
      },
    );
  }
}
