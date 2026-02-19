import 'package:flutter/material.dart';
import 'package:smart_guide/feature/onboarding/presentation/view/widget/onboarding_body.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(top: true, child: OnboardingBody()));
  }
}
