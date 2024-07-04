import 'package:flutter/material.dart';
import '../authentication/auth_gate.dart';
import './onboarding_service.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double bodyTextSize = 20;
    const double titleTextSize = 30;
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "hello Minimalist!",
          body:
              'The point of this app is to work as a digital journal - NOTHING MORE, NOTHING LESS\n',
          image: Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Center(
              child: Image.asset('assets/journal_max_logo_no_bg.png'),
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.black,
            titleTextStyle: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: titleTextSize,
            ),
            bodyTextStyle:
                TextStyle(color: Colors.white, fontSize: bodyTextSize),
          ),
        ),
        PageViewModel(
          title: "Good to know",
          body:
              "Your personal journal entries are only stored locally. They are not collected or stored by us for any purpose.\n\nYour entry will be sent to OpenAI services to provide you with actionable items if you specifically choose to. As per OpenAI TOS, they won't access/use your data.",
          image: Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Center(
              child: Image.asset('assets/journal_max_logo_no_bg.png'),
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.black,
            titleTextStyle: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: titleTextSize,
            ),
            bodyTextStyle:
                TextStyle(color: Colors.white, fontSize: bodyTextSize),
          ),
        ),
        PageViewModel(
          title: "Get Started",
          body:
              "You get a list of actionable items ONLY ONCE PER DAY. So, write all you want till the day ends and use the 'AI Actionables' wisely.\n\nDon't complicate life. Be minimalistic sometimes.",
          image: Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Center(
              child: Image.asset('assets/journal_max_logo_no_bg.png'),
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.black,
            titleTextStyle: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: titleTextSize,
            ),
            bodyTextStyle:
                TextStyle(color: Colors.white, fontSize: bodyTextSize),
          ),
        ),
        PageViewModel(
          title: "Get Started",
          body:
              "Future updates are on the way. Users will have full control on what features to opt in.\n\nThis app won't deceive you and steal personal data and it will stay like this forever.",
          image: Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Center(
              child: Image.asset('assets/journal_max_logo_no_bg.png'),
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.black,
            titleTextStyle: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: titleTextSize,
            ),
            bodyTextStyle:
                TextStyle(color: Colors.white, fontSize: bodyTextSize),
          ),
        ),
      ],
      onDone: () async {
        await OnboardingService.completeOnboarding();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const AuthGate(),
          ),
        );
      },
      onSkip: () async {
        await OnboardingService.completeOnboarding();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const AuthGate(),
          ),
        );
      },
      skip: const Text('Skip'),
      next: const Text('Next'),
      done: const Text(
        'Done',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
