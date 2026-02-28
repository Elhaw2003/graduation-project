import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/app_main.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spring_animation.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/login_screen.dart';
import 'package:smart_guide/feature/auth/new_password/presentation/view/new_password_screen.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/register_screen.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/view/reset_password_screen.dart';
import 'package:smart_guide/feature/auth/select_role/presentation/view/select_role_screen.dart';
import 'package:smart_guide/feature/auth/success_verification/presentation/view/success_verification_screen.dart';
import 'package:smart_guide/feature/auth/verify_email/presentation/view/verify_email_screen.dart';
import 'package:smart_guide/feature/auth/verify_phone_number/presentation/view/verify_phone_number_screen.dart';
import 'package:smart_guide/feature/guides/presentation/view/choose_guides_screen.dart';
import 'package:smart_guide/feature/home/presentation/home_screen.dart';
import 'package:smart_guide/feature/onboarding/presentation/view/onboarding_screen.dart';
import 'package:smart_guide/feature/splash/presentation/view/splash_screen.dart';

class RoutingGenerationConfig {
  static GoRouter routerGeneratorConfig = GoRouter(
    initialLocation: AppRoutes.newPasswordScreen,
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
        pageBuilder: (context, state) {
          final UserTypeEnum userTypeEnum = state.extra as UserTypeEnum;
          return CustomSpringPage(
            child: LoginScreen(userTypeEnum: userTypeEnum),
          );
        },
      ),

      /// Register Screen
      GoRoute(
        path: AppRoutes.registerScreen,
        name: AppRoutes.registerScreen,
        pageBuilder: (context, state) {
          final UserTypeEnum userTypeEnum = state.extra as UserTypeEnum;
          return CustomSpringPage(
            child: RegisterScreen(userTypeEnum: userTypeEnum),
          );
        },
      ),

      /// Reset Password Screen
      GoRoute(
        path: AppRoutes.resetPasswordScreen,
        name: AppRoutes.resetPasswordScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: ResetPasswordScreen());
        },
      ),

      /// Verify Phone Screen
      GoRoute(
        path: AppRoutes.verifyPhoneNumberScreen,
        name: AppRoutes.verifyPhoneNumberScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: VerifyPhoneNumberScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.homeScreen,
        name: AppRoutes.homeScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: HomeScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.appMain,
        name: AppRoutes.appMain,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: AppMain());
        },
      ),
      GoRoute(
        path: AppRoutes.chooseGuidesScreen,
        name: AppRoutes.chooseGuidesScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: ChooseGuidesScreen());
        },
      ),

      /// Success Verification Screen
      GoRoute(
        path: AppRoutes.successVerificationScreen,
        name: AppRoutes.successVerificationScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: SuccessVerificationScreen());
        },
      ),

      /// Verify Email Screen
      GoRoute(
        path: AppRoutes.verifyEmailScreen,
        name: AppRoutes.verifyEmailScreen,
        pageBuilder: (context, state) {
          final String email = state.extra as String;
          return CustomSpringPage(child: VerifyEmailScreen(email: email));
        },
      ),

      /// New Password Screen
      GoRoute(
        path: AppRoutes.newPasswordScreen,
        name: AppRoutes.newPasswordScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: NewPasswordScreen());
        },
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
