import 'package:flutter/material.dart';
import 'package:smart_guide/feature/splash/presentation/view/widget/splash_body.dart';

class SpalshScreen extends StatelessWidget {
  const SpalshScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBody(),
    );
  }
}