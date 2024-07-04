import 'package:flutter/material.dart';
import '../screens/onboarding_screen.dart';
import 'auth_gate.dart';

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  const MyApp({required this.isFirstLaunch, super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JournalMax demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: isFirstLaunch ? const OnboardingScreen() : const AuthGate(),
    );
  }
}
