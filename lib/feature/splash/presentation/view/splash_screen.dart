import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/splash/presentation/view/widget/splash_body.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _checkAuthStatus() async {
    // 1. Wait for logo display
    await Future.delayed(const Duration(seconds: 5));

    // Ensure the widget is still in the tree
    if (!mounted) return;

    // 2. Check onboarding status (handle null)
    final bool isOnBoardingViewSeen = CacheHelper.getBool(
      CacheHelper.kIsOnBoardingViewSeen,
    );

    if (!isOnBoardingViewSeen) {
      context.go(AppRoutes.onboardingScreen);
      return;
    }

    // 3. Check Remember Me preference
    final bool isRememberMe = CacheHelper.getBool(CacheHelper.kIsRememberMe);

    if (!isRememberMe) {
      // Not enabled — clear tokens and redirect to login
      await SecureStorageHelper().clearTokens();
      if (mounted) context.go(AppRoutes.loginScreen);
    } else {
      // Enabled — validate token
      final bool isLoggedIn = await SecureStorageHelper().isLoggedIn();
      if (mounted) {
        if (isLoggedIn) {
          context.go(AppRoutes.appMain);
        } else {
          await SecureStorageHelper().clearTokens();
          context.go(AppRoutes.loginScreen);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Run after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashBody());
  }
}
