import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/splash/presentation/view/widget/splash_body.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _checkAuthStatus() async {
    final bool isOnBoardingViewSeen = CacheHelper.getBool(
      CacheHelper.kIsOnBoardingViewSeen,
    );

    if (!isOnBoardingViewSeen) {
      if (context.mounted) context.go(AppRoutes.onboardingScreen);
      return;
    }

    final storage = SecureStorageHelper();
    String? token = await storage.getAccessToken();
    await Future.delayed(const Duration(seconds: 5));

    if (context.mounted) {
      if (token != null && token.isNotEmpty) {
        context.go(AppRoutes.homeScreen);
      } else {
        context.go(AppRoutes.loginScreen);
      }
    }
  }

  @override
  void initState() {
    _checkAuthStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SplashBody(),
    );
  }
}
