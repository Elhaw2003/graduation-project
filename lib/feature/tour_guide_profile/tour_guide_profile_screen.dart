import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/all_guides/data/model/tour_guide_model.dart';
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_cubit.dart';
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_states.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/book_now/data/booknow/book_now_service.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_cubit.dart';
import 'package:smart_guide/feature/book_now/presentation/view/book_now_screen.dart';
import 'package:smart_guide/feature/booking_payment/data/repo/booking_payment_repo_impl.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_cubit.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/feature/tour_guide_profile/action_row_in_tour_guide_screen.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_profile_body.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class TourGuideProfileScreen extends StatefulWidget {
  const TourGuideProfileScreen({super.key});

  @override
  State<TourGuideProfileScreen> createState() => _TourGuideProfileScreenState();
}

class _TourGuideProfileScreenState extends State<TourGuideProfileScreen> {
  bool _isGuide = false;
  bool _isOwnProfile = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _checkUserType();
  }

  Future<void> _checkUserType() async {
    final userType = await SecureStorageHelper.instance.getUserTypeEnum();
    final userId = await SecureStorageHelper.instance.getUserId();
    if (!mounted) return;
    setState(() {
      _isGuide = userType == UserTypeEnum.TourGuide;
      _currentUserId = userId;
    });
  }

  void _refreshProfile(String guideId) {
    context.read<TourGuidesCubit>().fetchTourGuideProfile(guideId);
  }

  Future<void> _openEditProfile(TourGuideModel guide) async {
    final result = await context.pushNamed(
      AppRoutes.editGuideProfileScreen,
      pathParameters: {'guideId': guide.userId},
      extra: guide,
    );

    if (result != null && mounted) {
      _refreshProfile(guide.userId);
    }
  }

  Widget _pinnedActionBar({
    required String guideId,
    TourGuideModel? guide,
    VoidCallback? onProfileUpdated,
  }) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ActionRowInTourGuideScreen(
        guideId: guideId,
        guideProfile: guide,
        onProfileUpdated: onProfileUpdated,
      ),
    );
  }

  Widget _pinnedBackBar() {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: TourGuideProfilePinnedBackBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      body: BlocBuilder<TourGuidesCubit, TourGuidesState>(
        builder: (context, state) {
          if (state is TourGuidesLoading) {
            return Stack(
              children: [
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
                _pinnedBackBar(),
              ],
            );
          }

          if (state is TourGuidesFailure) {
            return Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.errorMessage,
                      style: AppTextStyle.primaryTextW500S17,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                _pinnedBackBar(),
              ],
            );
          }

          if (state is GuideDetailsSuccess) {
            final guide = state.tourGuide;
            final isOwnProfile = _currentUserId == guide.userId;
            if (_isOwnProfile != isOwnProfile) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _isOwnProfile = isOwnProfile);
              });
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: TourGuideProfileBody(
                    name: guide.firstName,
                    lastName: guide.lastName,
                    aboutGuide: guide.bio,
                    imageUrl: guide.profilePicture,
                    rating: guide.rating.toString(),
                    price: "\$${guide.pricePerDay.toInt()}/Day",
                    cities: guide.cities,
                    languages: guide.languages,
                    gallery: guide.gallery,
                    guidedId: guide.userId,
                  ),
                ),
                _pinnedActionBar(
                  guideId: guide.userId,
                  guide: guide,
                  onProfileUpdated: () => _refreshProfile(guide.userId),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<TourGuidesCubit, TourGuidesState>(
        builder: (context, state) {
          if (state is GuideDetailsSuccess) {
            final guide = state.tourGuide;
            final showEditButton = _isGuide && _isOwnProfile;

            return Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isGuide) ...[
                    if (showEditButton) ...[
                      CustomButtonWidget(
                        onPressed: () => _openEditProfile(guide),
                        prefixIcon: Icons.edit_outlined,
                        prefixIconColor: Colors.white,
                        title: LocaleKeys.editProfile.tr(),
                        titleStyle: AppTextStyle.backgroundW500S17,
                        buttonColor: AppColors.primaryColor,
                        buttonWidth: double.infinity,
                      ),
                      SizedBox(height: 10.h),
                    ],
                    CustomButtonWidget(
                      onPressed: () {
                        context.pushNamed(AppRoutes.guideDashboardScreen);
                      },
                      prefixIcon: Icons.dashboard_outlined,
                      prefixIconColor: Colors.white,
                      title: LocaleKeys.guideDashboard.tr(),
                      titleStyle: AppTextStyle.backgroundW500S17,
                      buttonColor: AppColors.secondaryColor,
                      buttonWidth: double.infinity,
                    ),
                    SizedBox(height: 10.h),
                  ],
                  if (!_isGuide)
                    CustomButtonWidget(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (_) =>
                                      BookNowCubit(BookNowService(Dio())),
                                ),
                                BlocProvider(
                                  create: (_) => BookingAndPaymentCubit(
                                    bookingPaymentRepo:
                                        BookingPaymentRepoImpl(
                                      apiConsumer: DioConsumer(dio: Dio()),
                                    ),
                                  ),
                                ),
                              ],
                              child: BookNowScreen(guideId: guide.userId),
                            ),
                          ),
                        );
                      },
                      borderSideColor: AppColors.greenColor,
                      title: 'Book Now',
                      titleStyle: AppTextStyle.secondaryTextW400S17,
                      buttonColor: Colors.transparent,
                      buttonWidth: double.infinity,
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
