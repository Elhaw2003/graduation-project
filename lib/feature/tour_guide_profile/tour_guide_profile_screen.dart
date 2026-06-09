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
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_cubit.dart';
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_states.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/book_now/data/booknow/book_now_service.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_cubit.dart';
import 'package:smart_guide/feature/book_now/presentation/view/book_now_screen.dart';
import 'package:smart_guide/feature/booking_payment/data/repo/booking_payment_repo_impl.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_cubit.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/feature/tour_guide_profile/tour_guide_profile_body.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class TourGuideProfileScreen extends StatefulWidget {
  const TourGuideProfileScreen({super.key});

  @override
  State<TourGuideProfileScreen> createState() => _TourGuideProfileScreenState();
}

class _TourGuideProfileScreenState extends State<TourGuideProfileScreen> {
  bool _isGuide = false;

  @override
  void initState() {
    super.initState();
    _checkUserType();
  }

  Future<void> _checkUserType() async {
    final userType = await SecureStorageHelper.instance.getUserTypeEnum();
    if (!mounted) return;
    setState(() {
      _isGuide = userType == UserTypeEnum.TourGuide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<TourGuidesCubit, TourGuidesState>(
        builder: (context, state) {
          if (state is TourGuidesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is TourGuidesFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.errorMessage,
                  style: AppTextStyle.primaryTextW500S17,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is GuideDetailsSuccess) {
            final guide = state.tourGuide;

            return SingleChildScrollView(
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
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<TourGuidesCubit, TourGuidesState>(
        builder: (context, state) {
          if (state is GuideDetailsSuccess) {
            final guide = state.tourGuide;

            return Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Guide Dashboard button — only visible for TourGuide users
                  if (_isGuide) ...[
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

                  // Book Now button
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
