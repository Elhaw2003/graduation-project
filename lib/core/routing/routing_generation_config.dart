import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/login_screen.dart';
import 'package:smart_guide/feature/auth/select_role/presentation/view/select_role_screen.dart';
import 'package:smart_guide/feature/onboarding/presentation/view/onboarding_screen.dart';
import 'package:smart_guide/feature/splash/presentation/view/splash_screen.dart';

class RoutingGenerationConfig {
  static GoRouter routerGeneratorConfig = GoRouter(
    initialLocation: AppRoutes.selectRoleScreen,
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
        path: AppRoutes.selectRoleScreen,
        name: AppRoutes.selectRoleScreen,
        builder: (context, state) => SelectRoleScreen(),
      ),

      /// Select Role Screen
      GoRoute(
        path: AppRoutes.spalshScreen,
        name: AppRoutes.spalshScreen,
        builder: (context, state) => SplashScreen(),
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
