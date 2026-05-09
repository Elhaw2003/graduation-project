import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/details/presentation/view/widget/details_tour_about_title.dart';
import 'package:smart_guide/feature/details/presentation/view/widget/details_tour_appbar_widget.dart';
import 'package:smart_guide/feature/details/presentation/view/widget/details_tour_must_see_widget.dart';

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
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),

                      /// About Section
                      DetailsTourAboutTitle(
                        sectionFadeAnimations: _sectionFadeAnimations,
                        sectionSlideAnimations: _sectionSlideAnimations,
                      ),

                      SizedBox(height: 30.h),

                      /// Must See
                      DetailsTourMustSeeWidget(
                        sectionFadeAnimations: _sectionFadeAnimations,
                        sectionSlideAnimations: _sectionSlideAnimations,
                      ),

                      SizedBox(height: 30.h),

                      /// Plan Your Visit
                      _buildPlanYourVisitSection(),

                      SizedBox(height: 20.h),

                      /// Reviews
                      _buildExperienceSection(),

                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// Bottom Button
          Positioned(
            bottom: 20.h,
            left: 50.w,
            right: 50.w,
            child: _buildBookButton(),
          ),
        ],
      ),
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
          Icon(Icons.calendar_today_rounded, color: Colors.white, size: 18.sp),

          SizedBox(width: 10.w),

          Text(
            "Book a Tour",
            style: AppTextStyle.whiteW500S17.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanYourVisitSection() {
    return SlideTransition(
      position: _sectionSlideAnimations[2],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[2],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Plan Your Visit",
                style: AppTextStyle.thirdTextW900S20.copyWith(fontSize: 17.sp),
              ),

              SizedBox(height: 16.h),

              /// Open now
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 18.sp,
                    color: AppColors.primaryColor,
                  ),

                  SizedBox(width: 10.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 7.w,
                            height: 7.h,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),

                          SizedBox(width: 6.w),

                          Text(
                            "Open now",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        "07:00 Am - 06:00 Pm",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 14.h),

              /// Tickets
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 18.sp,
                    color: AppColors.primaryColor,
                  ),

                  SizedBox(width: 10.w),

                  Text(
                    "Tickets from 300 EGP",
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ],
              ),

              SizedBox(height: 18.h),

              /// Services
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.chair_alt_outlined,
                    size: 18.sp,
                    color: AppColors.primaryColor,
                  ),

                  SizedBox(width: 10.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Services",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        "Electric Train\nRestrooms\nVisitor Center\nParking\nAccessibility",
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 13.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 18.h),

              /// Essentials
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome, size: 18.sp, color: Colors.green),

                  SizedBox(width: 10.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Essentials",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        "Shoes\nSunscreen\nWater",
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 13.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return SlideTransition(
      position: _sectionSlideAnimations[3],
      child: FadeTransition(
        opacity: _sectionFadeAnimations[3],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Experience & Reviews",
                style: AppTextStyle.thirdTextW900S20.copyWith(fontSize: 17.sp),
              ),

              SizedBox(height: 16.h),

              _buildReviewItem(
                name: "John D.",
                review: "Breathtaking! Must-see for vibrant colors",
                image: "https://i.pravatar.cc/150?img=11",
              ),

              SizedBox(height: 16.h),

              _buildReviewItem(
                name: "Sarah M",
                review: "Stunning. Tutankhamun's tomb is worth it",
                image: "https://i.pravatar.cc/150?img=32",
              ),

              SizedBox(height: 16.h),

              _buildReviewItem(
                name: "Ahmed K",
                review: "Incredible! Arrive early, bring water",
                image: "https://i.pravatar.cc/150?img=15",
              ),

              SizedBox(height: 18.h),

              // ClipRRect(
              //   borderRadius: BorderRadius.circular(12.r),
              //   child: Image.asset(
              //     "assets/images/map.png",
              //     height: 110.h,
              //     width: double.infinity,
              //     fit: BoxFit.cover,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem({
    required String image,
    required String name,
    required String review,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 18.r, backgroundImage: NetworkImage(image)),

        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),

                  SizedBox(width: 4.w),

                  const Text("🇺🇸"),
                ],
              ),

              SizedBox(height: 2.h),

              Text(review, style: TextStyle(fontSize: 12.sp)),

              SizedBox(height: 4.h),

              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color: AppColors.starColore,
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
