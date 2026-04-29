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
    // 1. الانتظار لرؤية اللوجو
    await Future.delayed(const Duration(seconds: 5));

    // تأكد إن الصفحة لسه موجودة في الـ Widget Tree
    if (!mounted) return;

    // 2. التحقق من الـ Onboarding (مع التعامل مع الـ null)
    final bool isOnBoardingViewSeen = CacheHelper.getBool(
      CacheHelper.kIsOnBoardingViewSeen,
    );

    if (!isOnBoardingViewSeen) {
      context.go(AppRoutes.onboardingScreen);
      return;
    }

    // 3. التحقق من الـ Remember Me
    final bool isRememberMe = CacheHelper.getBool(CacheHelper.kIsRememberMe);

    if (!isRememberMe) {
      // لو مش مفعلها، نمسح التوكنز ونوديه يسجل دخول
      await SecureStorageHelper().clearTokens();
      if (mounted) context.go(AppRoutes.loginScreen);
    } else {
      // لو مفعلها، نشيك على التوكن
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
    // تنفيذ الكود بعد رسم أول Frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashBody());
  }
}
