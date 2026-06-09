import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/app_main.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spring_animation.dart';
import 'package:smart_guide/feature/aiGuide/presentation/view/ai_guide_screen.dart';
import 'package:smart_guide/feature/all_guides/data/repo/tour_guides_repo_imple.dart';
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_cubit.dart';
import 'package:smart_guide/feature/all_guides/presentation/view/all_guides_screen.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/auth/login/presentation/view/login_screen.dart';
import 'package:smart_guide/feature/auth/new_password/presentation/view/new_password_screen.dart';
import 'package:smart_guide/feature/auth/password_reset_successfully/presentation/view/password_reset_successfully_screen.dart';
import 'package:smart_guide/feature/auth/register/presentation/view/register_screen.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/view/reset_password_screen.dart';
import 'package:smart_guide/feature/auth/select_role/presentation/view/select_role_screen.dart';
import 'package:smart_guide/feature/auth/success_verification/presentation/view/success_verification_screen.dart';
import 'package:smart_guide/feature/book_now/presentation/view/book_now_screen.dart';
import 'package:smart_guide/feature/chat/data/cubit/chat_cubit.dart';
import 'package:smart_guide/feature/details/presentation/view/details_screen.dart';
import 'package:smart_guide/feature/explor/presentation/view/explore_ar_spots_screen.dart';
import 'package:smart_guide/feature/favorite/presentation/view/favorite_screen.dart';
import 'package:smart_guide/feature/guid_app/presentation/view/guide_app.dart';
import 'package:smart_guide/feature/home/presentation/home_screen.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/save_guides/save_guides_repo_imple.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_cubit.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_profile_screen.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/view/verify_otp_screen.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_place_details/get_place_details_cubit.dart';
import 'package:smart_guide/feature/home/data/repo/get_place_detail/get_place_datil_repo_imple.dart';
import 'package:smart_guide/feature/my_trips/data/enum/trip_type_enum.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/screens/my_trips_screen.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/screens/trip_type_screen.dart';
import 'package:smart_guide/feature/onboarding/presentation/view/onboarding_screen.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/popular_places_screen.dart';
import 'package:smart_guide/feature/profile/presentation/view/profile_screen.dart';
import 'package:smart_guide/feature/saved/presentation/view/saved_screen.dart';
import 'package:smart_guide/feature/settings/presentation/view/settings_screen.dart';
import 'package:smart_guide/feature/splash/presentation/view/splash_screen.dart';
import 'package:smart_guide/feature/guide_dashboard/data/repo/guide_dashboard_repo_impl.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/guide_dashboard_screen.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/screens/financial_ledger_screen.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/screens/identity_verification_screen.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/screens/tours_management_screen.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/screens/tour_detail_screen.dart';
import 'package:smart_guide/feature/booking_payment/data/repo/booking_payment_repo_impl.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_cubit.dart';

class RoutingGenerationConfig {
  static GoRouter routerGeneratorConfig = GoRouter(
    initialLocation: AppRoutes.spalshScreen,
    errorBuilder: (context, state) => errorBuilder(),
    routes: [
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
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
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
      GoRoute(
        path: AppRoutes.homeScreen,
        name: AppRoutes.homeScreen,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: const HomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.touristApp,
        name: AppRoutes.touristApp,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: const TouristApp()),
      ),
      GoRoute(
        path: AppRoutes.guideApp,
        name: AppRoutes.guideApp,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: const GuideApp()),
      ),
      GoRoute(
        path: AppRoutes.settingsScreen,
        name: AppRoutes.settingsScreen,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: const SettingsScreen()),
      ),
      GoRoute(
        path: '/tourGuideProfileScreen/:userId',
        name: AppRoutes.tourGuideProfileScreen,
        pageBuilder: (context, state) {
          final userId = state.pathParameters['userId']!;

          return CustomSpringPage(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => TourGuidesCubit(
                    repository: TourGuidesRepositoryImpl(
                      apiConsumer: DioConsumer(dio: Dio()),
                    ),
                  )..fetchTourGuideProfile(userId),
                ),

                BlocProvider(create: (context) => ChatCubit()),
              ],
              child: const TourGuideProfileScreen(),
            ),
          );
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
          return CustomSpringPage(
            child: BlocProvider(
              create: (context) => BookingAndPaymentCubit(
                bookingPaymentRepo: BookingPaymentRepoImpl(
                  apiConsumer: DioConsumer(dio: Dio()),
                ),
              ),
              child: TripTypeScreen(tripType: tripType),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.guidesSavedScreen,
        name: AppRoutes.guidesSavedScreen,
        pageBuilder: (context, state) =>
            CustomSpringPage(child: const GuidesSavedScreen()),
      ),
      // GoRoute(
      //   path: AppRoutes.bookNowScreen,
      //   name: AppRoutes.bookNowScreen,
      //   pageBuilder: (context, state) {
      //     return CustomSpringPage(child: BookNowScreen());
      //   },
      // ),
      GoRoute(
        path: AppRoutes.savedScreen,
        name: AppRoutes.savedScreen,
        builder: (context, state) => const SavedScreen(),
      ),
      GoRoute(
        path: AppRoutes.allGuidesScreen,
        name: AppRoutes.allGuidesScreen,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TourGuidesCubit(
                repository: TourGuidesRepositoryImpl(
                  apiConsumer: DioConsumer(dio: Dio()),
                ),
              ),
            ),
          ],
          child: const AllGuidesScreen(),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.detailsScreen}/:placeId',
        name: AppRoutes.detailsScreen,
        pageBuilder: (context, state) {
          final placeId = state.pathParameters['placeId']!;
          return CustomSpringPage(
            child: BlocProvider(
              create: (context) => GetPlaceDetailsCubit(
                getPlaceDetailsRepo: GetPlaceDetailRepoImple(
                  apiConsumer: DioConsumer(dio: Dio()),
                ),
              )..getPlaceDetails(placeId: placeId),
              child: const TouristPlaceDetailsScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.guideDashboardScreen,
        name: AppRoutes.guideDashboardScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(
            child: BlocProvider(
              create: (context) => GuideDashboardCubit(
                repository: GuideDashboardRepoImpl(
                  apiConsumer: DioConsumer(dio: Dio()),
                ),
              ),
              child: const GuideDashboardScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.financialLedgerScreen,
        name: AppRoutes.financialLedgerScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(
            child: BlocProvider(
              create: (context) => GuideDashboardCubit(
                repository: GuideDashboardRepoImpl(
                  apiConsumer: DioConsumer(dio: Dio()),
                ),
              ),
              child: const FinancialLedgerScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.identityVerificationScreen,
        name: AppRoutes.identityVerificationScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(
            child: BlocProvider(
              create: (context) => GuideDashboardCubit(
                repository: GuideDashboardRepoImpl(
                  apiConsumer: DioConsumer(dio: Dio()),
                ),
              ),
              child: const IdentityVerificationScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.toursManagementScreen,
        name: AppRoutes.toursManagementScreen,
        pageBuilder: (context, state) {
          return CustomSpringPage(
            child: BlocProvider(
              create: (context) => GuideDashboardCubit(
                repository: GuideDashboardRepoImpl(
                  apiConsumer: DioConsumer(dio: Dio()),
                ),
              ),
              child: const ToursManagementScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.tourDetailScreen}/:tourId',
        name: AppRoutes.tourDetailScreen,
        pageBuilder: (context, state) {
          final tourId = state.pathParameters['tourId'] ?? '';
          return CustomSpringPage(
            child: BlocProvider(
              create: (context) => GuideDashboardCubit(
                repository: GuideDashboardRepoImpl(
                  apiConsumer: DioConsumer(dio: Dio()),
                ),
              ),
              child: TourDetailScreen(tourId: tourId),
            ),
          );
        },
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
