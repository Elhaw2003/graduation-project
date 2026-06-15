import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/details/presentation/view/widget/details_tour_appbar_widget.dart';
import 'package:smart_guide/feature/details/presentation/view/widget/details_tour_must_see_widget.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_place_details/get_place_details_cubit.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_place_details/get_place_details_state.dart';

class TouristPlaceDetailsScreen extends StatefulWidget {
  const TouristPlaceDetailsScreen({super.key});

  @override
  State<TouristPlaceDetailsScreen> createState() =>
      _TouristPlaceDetailsScreenState();
}

class _TouristPlaceDetailsScreenState extends State<TouristPlaceDetailsScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _contentAnimationController;
  late AnimationController _headerAnimationController;

  late List<Animation<Offset>> _sectionSlideAnimations;
  late List<Animation<double>> _sectionFadeAnimations;

  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _sectionSlideAnimations = [];
    _sectionFadeAnimations = [];

    for (int i = 0; i < 6; i++) {
      double start = (0.1 * i).clamp(0.0, 1.0);
      double end = (start + 0.6).clamp(0.0, 1.0);

      _sectionSlideAnimations.add(
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentAnimationController,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        ),
      );

      _sectionFadeAnimations.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _contentAnimationController,
            curve: Interval(start, end, curve: Curves.easeIn),
          ),
        ),
      );
    }

    _headerAnimationController.forward();
    _contentAnimationController.forward();
  }

  void _onScroll() {
    if (mounted) {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);

    _scrollController.dispose();
    _contentAnimationController.dispose();
    _headerAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPlaceDetailsCubit, GetPlaceDetailsState>(
      builder: (context, state) {
        if (state is GetPlaceDetailsLoading) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }

        if (state is GetPlaceDetailsFailure) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Text(
                state.errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
              ),
            ),
          );
        }

        if (state is GetPlaceDetailsSuccess) {
          final place = state.place;

          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    DetailsTourAppbarWidget(
                      headerAnimationController: _headerAnimationController,
                      scrollOffset: _scrollOffset,
                      imageUrl: place.imageUrl,
                      title: place.name,
                      rating: place.rating,
                      placeId: place.id,
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30.h),

                            /// ABOUT
                            _buildAboutSection(place),

                            SizedBox(height: 24.h),

                            /// HIGHLIGHTS
                            DetailsTourMustSeeWidget(
                              place: place,
                              sectionFadeAnimations: _sectionFadeAnimations,
                              sectionSlideAnimations: _sectionSlideAnimations,
                            ),

                            SizedBox(height: 24.h),

                            /// PLACE INFO
                            _buildPlaceInfoSection(place),

                            SizedBox(height: 24.h),

                            /// LOCATION
                            _buildLocationSection(place),

                            SizedBox(height: 24.h),

                            /// QUICK FACTS
                            _buildQuickFactsSection(place),

                            SizedBox(height: 120.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Positioned(
                //   bottom: 20.h,
                //   left: 40.w,
                //   right: 40.w,
                //   child: _buildBookButton(),
                // ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Center(
            child: Text("No data available", style: TextStyle(fontSize: 16.sp)),
          ),
        );
      },
    );
  }

  Widget _buildBookButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(double.infinity, 56.h),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.travel_explore_rounded, color: Colors.white, size: 18.sp),

          SizedBox(width: 10.w),

          Text(
            "Explore Now",
            style: AppTextStyle.whiteW500S17.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(dynamic place) {
    return SlideTransition(
      position: _sectionSlideAnimations[0],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[0],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About ${place.name}",
                style: AppTextStyle.thirdTextW900S20.copyWith(fontSize: 17.sp),
              ),

              SizedBox(height: 14.h),

              ReadMoreText(
                place.description.isNotEmpty
                    ? place.description
                    : "No description available",
                trimLines: 4,
                colorClickableText: AppColors.primaryColor,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Read More',
                trimExpandedText: ' Read Less',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade700,
                  height: 1.7,
                ),
                moreStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
                lessStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),

              if (place.historicalBackground.isNotEmpty) ...[
                SizedBox(height: 22.h),

                Text(
                  "Historical Background",
                  style: AppTextStyle.thirdTextW900S20.copyWith(
                    fontSize: 15.sp,
                  ),
                ),

                SizedBox(height: 10.h),

                ReadMoreText(
                  place.historicalBackground,
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' Read More',
                  trimExpandedText: ' Read Less',
                  colorClickableText: AppColors.primaryColor,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade700,
                    height: 1.7,
                  ),
                ),
              ],

              if (place.period.isNotEmpty) ...[
                SizedBox(height: 18.h),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_edu_rounded,
                        size: 18.sp,
                        color: AppColors.primaryColor,
                      ),

                      SizedBox(width: 10.w),

                      Expanded(
                        child: Text(
                          place.period,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceInfoSection(dynamic place) {
    return SlideTransition(
      position: _sectionSlideAnimations[2],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[2],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Place Information",
                style: AppTextStyle.thirdTextW900S20.copyWith(fontSize: 17.sp),
              ),

              SizedBox(height: 18.h),

              _buildInfoRow(Icons.category_outlined, "Type", place.type),

              SizedBox(height: 14.h),

              _buildInfoRow(Icons.location_city_outlined, "City", place.city),

              SizedBox(height: 14.h),

              _buildInfoRow(
                Icons.map_outlined,
                "Governorate",
                place.governorate,
              ),

              SizedBox(height: 14.h),

              _buildInfoRow(
                Icons.person_outline_rounded,
                "Created By",
                place.createdBy.isNotEmpty ? place.createdBy : "Unknown",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection(dynamic place) {
    return SlideTransition(
      position: _sectionSlideAnimations[3],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[3],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location",
                style: AppTextStyle.thirdTextW900S20.copyWith(fontSize: 17.sp),
              ),

              SizedBox(height: 16.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.06),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primaryColor,
                      size: 22.sp,
                    ),

                    SizedBox(width: 10.w),

                    Expanded(
                      child: Text(
                        place.location.isNotEmpty
                            ? place.location
                            : "Unknown location",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade700,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFactsSection(dynamic place) {
    return SlideTransition(
      position: _sectionSlideAnimations[4],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[4],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quick Facts",
                style: AppTextStyle.thirdTextW900S20.copyWith(fontSize: 17.sp),
              ),

              SizedBox(height: 18.h),

              Row(
                children: [
                  Expanded(
                    child: _buildFactCard(
                      icon: Icons.star_rounded,
                      title: "Rating",
                      value: place.rating.toString(),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: _buildFactCard(
                      icon: Icons.calendar_month_rounded,
                      title: "Start Year",
                      value: place.startYear?.toString() ?? "Unknown",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFactCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(.06),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 22.sp),

          SizedBox(height: 10.h),

          Text(
            title,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),

          SizedBox(height: 6.h),

          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.sp, color: AppColors.primaryColor),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 5.h),

              Text(
                value.isNotEmpty ? value : "Unknown",
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
