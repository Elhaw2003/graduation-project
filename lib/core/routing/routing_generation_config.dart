import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/feature/auth/choosingIdentity/presentation/view/choosing_identity_screen.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/login_screen.dart';
import 'package:smart_guide/feature/onboarding/presentation/view/onboarding_screen.dart';
import 'package:smart_guide/feature/splash/presentation/view/splash_screen.dart';

class RoutingGenerationConfig {
  static GoRouter routerGeneratorConfig = GoRouter(
    initialLocation: AppRoutes.spalshScreen,
    errorBuilder: (context, state) {
      return errorBuilder();
    },
    routes: [
      /// Onboarding Screen
      GoRoute(
        path: AppRoutes.onboardingScreen,
        name: AppRoutes.onboardingScreen,
        builder: (context, state) => OnboardingScreen(),
      ),

      /// Splash Screen
      GoRoute(
        path: AppRoutes.spalshScreen,
        name: AppRoutes.spalshScreen,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.choosingIdentityScreen,
        name: AppRoutes.choosingIdentityScreen,
        builder: (context, state) => const choosingIdentityScreen(),
      ),

      /// Login Screen
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        builder: (context, state) => LoginScreen(),
      ),
    ],
  );
}

/// Error Screen
Widget errorBuilder() {
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      backgroundColor: Colors.red,
      title: Text("Error Screen"),
    ),
    body: Center(child: Text("No Page Found")),
  );
}
