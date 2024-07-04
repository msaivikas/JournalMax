import "package:shared_preferences/shared_preferences.dart";

class OnboardingService {
  // private unnamed constructor
  OnboardingService._();

  static const String _firstLaunchKey = 'first_launch';
  static Future<bool> isFirstLaunch() async {
    // will return true if it's launching for the first time
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }
}
