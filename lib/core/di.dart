import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/services/ai_chat_service.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/services/chat_hub_service.dart';
import 'package:smart_guide/core/services/google_auth_service.dart';
import 'package:smart_guide/feature/aiGuide/presentation/cubit/ai_guide_cubit.dart';
import 'package:smart_guide/feature/all_guides/data/repo/tour_guides_repo.dart';
import 'package:smart_guide/feature/all_guides/data/repo/tour_guides_repo_imple.dart';
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_cubit.dart';
import 'package:smart_guide/feature/auth/login/data/repo/login_remote_imple_repo.dart';
import 'package:smart_guide/feature/auth/login/data/repo/login_repo.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_email/login_with_email_cubit.dart';
import 'package:smart_guide/feature/auth/login/presentation/cubit/login_with_google/login_with_google_cubit.dart';
import 'package:smart_guide/feature/auth/new_password/data/repo/new_password_imple_repo.dart';
import 'package:smart_guide/feature/auth/new_password/data/repo/new_password_repo.dart';
import 'package:smart_guide/feature/auth/new_password/presentation/cubit/new_password_cubit.dart';
import 'package:smart_guide/feature/auth/register/data/repo/register_remote_imple_repo.dart';
import 'package:smart_guide/feature/auth/register/data/repo/register_repo.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_cubit.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/register/register_cubit.dart';
import 'package:smart_guide/feature/auth/reset_password/data/repo/reset_password_imple_repo.dart';
import 'package:smart_guide/feature/auth/reset_password/data/repo/reset_password_repo.dart';
import 'package:smart_guide/feature/auth/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:smart_guide/feature/auth/verify_otp/data/repo/resend_otp/resend_otp_imple_repo.dart';
import 'package:smart_guide/feature/auth/verify_otp/data/repo/resend_otp/resend_otp_repo.dart';
import 'package:smart_guide/feature/auth/verify_otp/data/repo/verify_otp/verify_otp_imple_repo.dart';
import 'package:smart_guide/feature/auth/verify_otp/data/repo/verify_otp/verify_otp_repo.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/cubit/resend_otp/resend_otp_cubit.dart';
import 'package:smart_guide/feature/auth/verify_otp/presentation/cubit/verify_otp/verify_otp_cubit.dart';
import 'package:smart_guide/feature/book_now/data/booknow/book_now_service.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_cubit.dart';
import 'package:smart_guide/feature/booking_payment/data/repo/booking_payment_repo.dart';
import 'package:smart_guide/feature/booking_payment/data/repo/booking_payment_repo_impl.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_cubit.dart';
import 'package:smart_guide/feature/chat/data/repo/chat_repo.dart';
import 'package:smart_guide/feature/chat/data/repo/chat_repo_impl.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_inbox/chat_inbox_cubit.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_room/chat_room_cubit.dart';
import 'package:smart_guide/feature/guide_dashboard/data/repo/guide_dashboard_repo.dart';
import 'package:smart_guide/feature/guide_dashboard/data/repo/guide_dashboard_repo_impl.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:smart_guide/feature/guid_app/presentation/cubit/guide_session/guide_session_cubit.dart';
import 'package:smart_guide/feature/home/data/repo/get_place_detail/get_place_datail_repo.dart';
import 'package:smart_guide/feature/home/data/repo/get_place_detail/get_place_datil_repo_imple.dart';
import 'package:smart_guide/feature/home/data/repo/get_places/get_places_repo.dart';
import 'package:smart_guide/feature/home/data/repo/get_places/get_places_repo_imple.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_place_details/get_place_details_cubit.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_cubit.dart';
import 'package:smart_guide/feature/home/presentation/cubit/search_places/search_places_cubit.dart';
import 'package:smart_guide/feature/profile/data/repo/tourist_profile_repo.dart';
import 'package:smart_guide/feature/profile/data/repo/tourist_profile_repo_impl.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_profile_cubit.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_session/tourist_session_cubit.dart';
import 'package:smart_guide/feature/saved/data/repo/saved_places_repo.dart';
import 'package:smart_guide/feature/saved/data/repo/saved_places_repo_imple.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_cubit.dart';
import 'package:smart_guide/feature/settings/data/repo/log_out/log_out_repo.dart';
import 'package:smart_guide/feature/settings/data/repo/log_out/log_out_repo_imple.dart';
import 'package:smart_guide/feature/settings/presentation/cubit/log_out/cubit/log_out_cubit.dart';
import 'package:smart_guide/feature/Tour/data/tours/tours_cubit.dart';
import 'package:smart_guide/feature/Tour/data/tours/tours_repository.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/edit_guide_profile/edit_guide_profile_repo.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/edit_guide_profile/edit_guide_profile_repo_impl.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/save_guides/save_guides_repo.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/save_guides/save_guides_repo_imple.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/edit_guide_profile/edit_guide_profile_cubit.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ── External ──────────────────────────────────────────────────────────────

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper.instance,
  );

  sl.registerLazySingleton<Dio>(() => Dio());

  // ── Core ──────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<ConnectivityGuard>(() => ConnectivityGuard());
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));

  // ── Services ──────────────────────────────────────────────────────────────

  sl.registerLazySingleton<GoogleAuthService>(() => GoogleAuthService());
  sl.registerLazySingleton<AiChatService>(() => AiChatService());
  sl.registerLazySingleton<ChatHubService>(() => ChatHubService.instance);
  sl.registerLazySingleton<BookNowService>(() => BookNowService(sl()));

  // ── Repositories ──────────────────────────────────────────────────────────

  // Auth
  sl.registerLazySingleton<LoginRepo>(
    () => LoginRemoteImpleRepo(apiConsumer: sl(), storage: sl()),
  );
  sl.registerLazySingleton<RegisterRepo>(
    () => RegisterRemoteImpleRepo(apiConsumer: sl()),
  );
  sl.registerLazySingleton<NewPasswordRepo>(
    () => NewPasswordImpleRepo(apiConsumer: sl()),
  );
  sl.registerLazySingleton<ResetPasswordRepo>(
    () => ResetPasswordImpleRepo(apiConsumer: sl()),
  );
  sl.registerLazySingleton<VerifyOtpRepo>(
    () => VerifyOtpImpleRepo(apiConsumer: sl()),
  );
  sl.registerLazySingleton<ResendOtpRepo>(
    () => ResendOtpImpleRepo(apiConsumer: sl()),
  );

  // Settings
  sl.registerLazySingleton<LogOutRepo>(
    () => LogOutRepoImple(apiConsumer: sl()),
  );

  // Places / Home
  sl.registerLazySingleton<GetPlacesRepo>(
    () => GetPlacesRepoImple(apiConsumer: sl()),
  );
  sl.registerLazySingleton<GetPlaceDatailRepo>(
    () => GetPlaceDetailRepoImple(apiConsumer: sl()),
  );

  // Saved places
  sl.registerLazySingleton<SavedPlacesRepo>(
    () => SavedPlacesRepoImpl(apiConsumer: sl()),
  );

  // All guides
  sl.registerLazySingleton<TourGuidesRepository>(
    () => TourGuidesRepositoryImpl(apiConsumer: sl()),
  );

  // Saved guides / Tour guide profile
  sl.registerLazySingleton<SavedGuidesRepository>(
    () => SavedGuidesRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<EditGuideProfileRepo>(
    () => EditGuideProfileRepoImpl(apiConsumer: sl()),
  );

  // Profile
  sl.registerLazySingleton<TouristProfileRepo>(
    () => TouristProfileRepoImpl(apiConsumer: sl()),
  );

  // Booking & Payment
  sl.registerLazySingleton<BookingPaymentRepo>(
    () => BookingPaymentRepoImpl(apiConsumer: sl()),
  );

  // Guide Dashboard
  sl.registerLazySingleton<GuideDashboardRepo>(
    () => GuideDashboardRepoImpl(apiConsumer: sl()),
  );

  // Tours (home featured tours — uses http directly, no ApiConsumer)
  sl.registerLazySingleton<ToursRepository>(() => ToursRepository());

  // Chat
  sl.registerLazySingleton<ChatRepo>(() => ChatRepoImpl(apiConsumer: sl()));

  // ── Cubits / Blocs ────────────────────────────────────────────────────────

  // Auth cubits
  sl.registerFactory<LoginCubit>(() => LoginCubit(loginRepo: sl()));
  sl.registerFactory<LoginWithGoogleCubit>(
    () => LoginWithGoogleCubit(loginRepo: sl()),
  );
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(registerRepo: sl()));
  sl.registerFactory<NewPasswordCubit>(
    () => NewPasswordCubit(newPasswordRepo: sl()),
  );
  sl.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(resetPasswordRepo: sl()),
  );
  sl.registerFactory<VerifyOtpCubit>(
    () => VerifyOtpCubit(verifyOtpRepo: sl()),
  );
  sl.registerFactory<ResendOtpCubit>(
    () => ResendOtpCubit(resendOtpRepo: sl()),
  );
  sl.registerFactory<PickImageCubit>(() => PickImageCubit());

  // Settings
  sl.registerFactory<LogOutCubit>(() => LogOutCubit(logOutRepo: sl()));

  // Profile / Session
  sl.registerFactory<TouristProfileCubit>(
    () => TouristProfileCubit(touristProfileRepo: sl()),
  );
  sl.registerFactory<TouristSessionCubit>(() => TouristSessionCubit());
  sl.registerFactory<GuideSessionCubit>(() => GuideSessionCubit());

  // Places / Home
  sl.registerFactory<PlacesCubit>(() => PlacesCubit(getPlacesRepo: sl()));
  sl.registerFactory<GetPlaceDetailsCubit>(
    () => GetPlaceDetailsCubit(getPlaceDetailsRepo: sl()),
  );
  sl.registerFactory<SearchPlacesCubit>(
    () => SearchPlacesCubit(getPlacesRepo: sl()),
  );

  // Saved
  sl.registerFactory<SavedPlacesCubit>(
    () => SavedPlacesCubit(savedPlacesRepo: sl()),
  );

  // All guides
  sl.registerFactory<TourGuidesCubit>(
    () => TourGuidesCubit(repository: sl()),
  );

  // Saved guides / Tour guide profile
  sl.registerFactory<SavedGuidesCubit>(
    () => SavedGuidesCubit(savedGuidesRepository: sl()),
  );
  sl.registerFactory<EditGuideProfileCubit>(
    () => EditGuideProfileCubit(repository: sl()),
  );

  // Booking & Payment
  sl.registerFactory<BookingAndPaymentCubit>(
    () => BookingAndPaymentCubit(bookingPaymentRepo: sl()),
  );
  sl.registerFactory<BookNowCubit>(() => BookNowCubit(sl()));

  // Guide Dashboard
  sl.registerFactory<GuideDashboardCubit>(
    () => GuideDashboardCubit(repository: sl()),
  );

  // Tours
  sl.registerFactory<ToursCubit>(() => ToursCubit(sl()));

  // AI Guide
  sl.registerFactory<AiGuideCubit>(() => AiGuideCubit(service: sl()));

  // Chat
  sl.registerFactory<ChatInboxCubit>(() => ChatInboxCubit(chatRepo: sl()));
  sl.registerFactory<ChatRoomCubit>(() => ChatRoomCubit(chatRepo: sl()));
}
