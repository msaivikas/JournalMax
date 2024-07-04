import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import '../screens/onboarding_service.dart';
import '../screens/onboarding_screen.dart';
import './auth_helper_local.dart';
import '../screens/home_screen.dart';
import '../main.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isLoading = true;
  bool? isFirstLaunch;

  @override
  void initState() {
    super.initState();
    checkFirstLaunch();
  }

  Future<void> checkFirstLaunch() async {
    isFirstLaunch = await OnboardingService.isFirstLaunch();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (isFirstLaunch == true) {
      return const OnboardingScreen();
    }

    // custom theme for sign-in & register page
    final ThemeData customTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.yellow, // where is it??
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.black,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // where the fuck is this part????
          backgroundColor: Colors.yellow, // Button background color
          foregroundColor: Colors.green, // Button text color
        ),
      ),
    );

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        }

        if (!snapshot.hasData) {
          return Theme(
            data: customTheme,
            child: SignInScreen(
              providers: [
                EmailAuthProvider(),
                GoogleProvider(clientId: clientId),
              ],
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('assets/journal_max_logo_no_bg.png'),
                  ),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: action == AuthAction.signIn
                      ? const Text(
                          'Welcome to JournalMax, please sign in!',
                        )
                      : const Text('Welcome to JournalMax, please sign up!'),
                );
              },
              footerBuilder: (context, action) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'No user data is collected by us. It all stays locally on your device\nJournal entries are individually sent to OpenAI services for list generation only if you choose',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) async {
                  User? user = state.user;
                  if (user != null) {
                    await AuthHelperLocal.setUserEmail(user.email!);
                  }
                }),
              ],
            ),
          );
        }

        return const HomeScreen();
      },
    );
  }
}
