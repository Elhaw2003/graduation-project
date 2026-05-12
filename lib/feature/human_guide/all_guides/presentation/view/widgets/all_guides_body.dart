// AllGuidesBody.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guides/data/tour_guides/tour_guides_cubit.dart';
import 'package:smart_guide/feature/guides/data/tour_guides/tour_guides_state.dart';
import 'package:smart_guide/feature/human_guide/all_guides/presentation/view/widgets/all_guides_appbar.dart';
import 'package:smart_guide/feature/human_guide/all_guides/presentation/view/widgets/custom_container_info_guides.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class AllGuidesBody extends StatefulWidget {
  const AllGuidesBody({super.key, required this.animationController});

  final AnimationController animationController;

  @override
  State<AllGuidesBody> createState() => _AllGuidesBodyState();
}

class _AllGuidesBodyState extends State<AllGuidesBody> {
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeAnimations = List.generate(
      10,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: widget.animationController,
          curve: Interval(
            (index * 0.08).clamp(0.0, 1.0),
            ((index * 0.08) + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _slideAnimations = List.generate(
      10,
      (index) => Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(
          parent: widget.animationController,
          curve: Interval(
            (index * 0.08).clamp(0.0, 1.0),
            ((index * 0.08) + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // physics: const BouncingScrollPhysics(),
      slivers: [
        /// ================= CREATIVE SLIVER APP BAR =================
        AllGuidesAppbar(
          fadeAnimations: _fadeAnimations,
          slideAnimations: _slideAnimations,
        ),

        /// ================= SEARCH & FILTER SECTION =================
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: FadeTransition(
              opacity: _fadeAnimations.length > 1
                  ? _fadeAnimations[1]
                  : AlwaysStoppedAnimation(1.0),
              child: SlideTransition(
                position: _slideAnimations.length > 1
                    ? _slideAnimations[1]
                    : AlwaysStoppedAnimation(Offset.zero),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldWidget(
                        width: double.infinity,
                        hintTextStyle: AppTextStyle.primaryW400S15.copyWith(
                          color: AppColors.secondaryTextColor,
                        ),
                        hintText: LocaleKeys.searchDestinationsAndGuides.tr(),
                        prefixIcon: Icons.search,
                        prefixColor: AppColors.secondaryTextColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      height: 45.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 12.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.filter_alt_outlined,
                        color: AppColors.whiteColor,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        /// ================= GUIDES LIST WITH ANIMATIONS =================
        BlocBuilder<TourGuidesCubit, TourGuidesState>(
          builder: (context, state) {
            /// Loading State with Shimmer
            if (state is TourGuidesLoading) {
              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _buildShimmerLoader(),
                    ),
                    childCount: 5,
                  ),
                ),
              );
            }

            /// Error State
            if (state is TourGuidesError) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        state.message,
                        style: AppTextStyle.primaryTextW500S17,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            /// Success State with Staggered Animations
            if (state is TourGuidesSuccess) {
              final guides = state.guides;
              if (guides.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "No guides found",
                      style: AppTextStyle.primaryTextW500S17,
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final guide = guides[index];
                    final animationIndex = index % 10;

                    return FadeTransition(
                      opacity:
                          _fadeAnimations.isNotEmpty &&
                              animationIndex < _fadeAnimations.length
                          ? _fadeAnimations[animationIndex]
                          : AlwaysStoppedAnimation(1.0),
                      child: SlideTransition(
                        position:
                            _slideAnimations.isNotEmpty &&
                                animationIndex < _slideAnimations.length
                            ? _slideAnimations[animationIndex]
                            : AlwaysStoppedAnimation(Offset.zero),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: CustomContainerInfoGuides(
                            userID: guide.userId,
                            firstName: guide.firstName,
                            lastName: guide.lastName,
                            imageUrl:
                                guide.profilePicture ??
                                "https://via.placeholder.com/100",
                            rating: guide.rating,
                            price: 0,
                          ),
                        ),
                      ),
                    );
                  }, childCount: guides.length),
                ),
              );
            }

            return SliverToBoxAdapter(child: SizedBox(height: 100.h));
          },
        ),

        /// Bottom Spacing
        SliverToBoxAdapter(child: SizedBox(height: 40.h)),
      ],
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: AppColors.grey100Color,
      highlightColor: AppColors.whiteColor,
      child: Container(
        height: 160.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          child: Row(
            children: [
              /// Profile Picture Skeleton
              Container(
                height: 100.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: AppColors.grey200Color,
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              SizedBox(width: 16.w),

              /// Content Skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 16.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: AppColors.grey200Color,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Container(
                      height: 14.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        color: AppColors.grey200Color,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Container(
                      height: 14.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: AppColors.grey200Color,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Container(
                      height: 28.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: AppColors.grey200Color,
                        borderRadius: BorderRadius.circular(4.r),
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
}
