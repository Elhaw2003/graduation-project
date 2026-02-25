import 'package:flutter/material.dart';
import 'package:smart_guide/generated/assets.dart';

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.imagesPngThirdSplashScreen,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      opacity: const AlwaysStoppedAnimation(.4),
    );
  }
}
