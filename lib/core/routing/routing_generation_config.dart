import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/app_main.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spring_animation.dart';
import 'package:smart_guide/feature/aiGuide/presentation/view/ai_guide_screen.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/login_screen.dart';
import 'package:smart_guide/feature/auth/new_password/presentation/view/new_password_screen.dart';
import 'package:smart_guide/feature/auth/password_reset_successfully/presentation/view/password_reset_successfully_screen.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/register_screen.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/view/reset_password_screen.dart';
import 'package:smart_guide/feature/auth/select_role/presentation/view/select_role_screen.dart';
import 'package:smart_guide/feature/auth/success_verification/presentation/view/success_verification_screen.dart';
import 'package:smart_guide/feature/explor/presentation/view/explore_ar_spots_screen.dart';
import 'package:smart_guide/feature/favorite/presentation/view/favorite_screen.dart';
import 'package:smart_guide/feature/guides/tour_guide_profile_screen.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/view/verify_otp_screen.dart';
import 'package:smart_guide/feature/home/presentation/home_screen.dart';
import 'package:smart_guide/feature/my_trips/data/enum/trip_type_enum.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/screens/my_trips_screen.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/screens/trip_type_screen.dart';
import 'package:smart_guide/feature/onboarding/presentation/view/onboarding_screen.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/popular_places_screen.dart';
import 'package:smart_guide/feature/profile/presentation/view/profile_screen.dart';
import 'package:smart_guide/feature/settings/presentation/view/settings_screen.dart';
import 'package:smart_guide/feature/splash/presentation/view/splash_screen.dart';

class RoutingGenerationConfig {
  static GoRouter routerGeneratorConfig = GoRouter(
    initialLocation: AppRoutes.appMain,
    errorBuilder: (context, state) => errorBuilder(),
    routes: [
      /// Splash, Onboarding & Select Role
      GoRoute(
        path: AppRoutes.spalshScreen,
        name: AppRoutes.spalshScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingScreen,
        name: AppRoutes.onboardingScreen,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.selectRoleScreen,
        name: AppRoutes.selectRoleScreen,
        builder: (context, state) => const SelectRoleScreen(),
      ),

      /// Login Screen (General - No Params)
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),

      /// Register Screen (The only one with Path Parameter)
      GoRoute(
        path: '${AppRoutes.registerScreen}/:userType',
        name: AppRoutes.registerScreen,
        pageBuilder: (context, state) {
          final typeString = state.pathParameters['userType'];
          final userType = UserTypeEnum.values.firstWhere(
            (e) => e.name == typeString,
            orElse: () => UserTypeEnum.Tourist,
          );
          return CustomSpringPage(
            child: RegisterScreen(userTypeEnum: userType),
          );
        },
      ),

      /// Forgot Password Flow (General - Use 'extra' for data)
      GoRoute(
        path: AppRoutes.resetPasswordScreen,
        name: AppRoutes.resetPasswordScreen,
        pageBuilder: (context, state) {
          final String email = state.extra as String? ?? "";
          return CustomSpringPage(child: ResetPasswordScreen(email: email));
        },
      ),

      GoRoute(
        path: AppRoutes.verifyOtpScreen,
        name: AppRoutes.verifyOtpScreen,
        pageBuilder: (context, state) {
          final String email = state.extra as String? ?? "";
          return CustomSpringPage(child: VerifyOtpScreen(email: email));
        },
      ),

      GoRoute(
        path: AppRoutes.newPasswordScreen,
        name: AppRoutes.newPasswordScreen,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return CustomSpringPage(
            child: NewPasswordScreen(
              email: data['email'] ?? "",
              otp: data['otp'] ?? "",
            ),
          );
        },
      ),

      /// Success Screens (General)
      GoRoute(
        path: AppRoutes.successVerificationScreen,
        name: AppRoutes.successVerificationScreen,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: SuccessVerificationScreen()),
      ),

      GoRoute(
        path: AppRoutes.passwordResetSuccessfullyScreen,
        name: AppRoutes.passwordResetSuccessfullyScreen,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: PasswordResetSuccessfullyScreen()),
      ),

      /// Home & App Core
      GoRoute(
        path: AppRoutes.homeScreen,
        name: AppRoutes.homeScreen,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: const HomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.appMain,
        name: AppRoutes.appMain,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: const AppMain()),
      ),

      /// Settings
      GoRoute(
        path: AppRoutes.settingsScreen,
        name: AppRoutes.settingsScreen,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: const SettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.tourGuideProfileScreen,
        name: AppRoutes.tourGuideProfileScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: TourGuideProfileScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.exploreArSpotsScreen,
        name: AppRoutes.exploreArSpotsScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: ExploreArSpotsScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.aiGuideScreen,
        name: AppRoutes.aiGuideScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: AiGuideScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.popularPlacesScreen,
        name: AppRoutes.popularPlacesScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: PopularPlacesScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.profileScreen,
        name: AppRoutes.profileScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: ProfileScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.myTripsScreen,
        name: AppRoutes.myTripsScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(child: MyTripsScreen());
        },
      ),
      GoRoute(
        path: '${AppRoutes.tripsTypeScreen}/:tripType',
        name: AppRoutes.tripsTypeScreen,
        pageBuilder: (context, state) {
          final typeString = state.pathParameters['tripType'];
          final tripType = TripTypeEnum.values.firstWhere(
            (e) => e.name == typeString,
            orElse: () => TripTypeEnum.upcoming,
          );
          return CustomSpringPage(child: TripTypeScreen(tripType: tripType));
        },
      ),
      GoRoute(
        path: AppRoutes.favoritePlacesScreen,
        name: AppRoutes.favoritePlacesScreen,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: const FavoritePlacesScreen()),
      ),
    ],
  );
}

Widget errorBuilder() {
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      backgroundColor: Colors.red,
      title: const Text("Error Screen"),
    ),
    body: const Center(child: Text("No Page Found")),
  );
}
