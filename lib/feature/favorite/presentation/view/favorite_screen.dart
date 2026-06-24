import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/favorite/presentation/view/widget/favorite_places_appbar.dart';
import 'package:smart_guide/feature/favorite/presentation/view/widget/saved_guided_card_widget.dart';
import 'package:smart_guide/core/methods/save_place_feedback.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_cubit.dart';
import 'package:smart_guide/feature/favorite/data/model/saved_guided_model.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_states.dart';

class GuidesSavedScreen extends StatefulWidget {
  const GuidesSavedScreen({super.key});

  @override
  State<GuidesSavedScreen> createState() => _GuidesSavedScreenState();
}

class _GuidesSavedScreenState extends State<GuidesSavedScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch saved guides after frame is rendered for proper context access
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedGuidesCubit>().getSavedGuides();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocListener<SavedGuidesCubit, SavedGuidesState>(
        listener: (context, state) {
          if (state is RemoveGuideSuccess) {
            SaveFeedback.removedGuide(context);
          }
        },
        child: BlocBuilder<SavedGuidesCubit, SavedGuidesState>(
          builder: (context, state) {
            // Loading state with shimmer skeleton effect for better UX
            if (state is SavedGuidesLoading) {
              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [const FavoriteSliverAppBar(), _buildListShimmer()],
              );
            }

            // Extract guides list safely from any state type without type casting
            List<SavedGuideModel> savedGuidesList = [];
            if (state is SavedGuidesSuccess) {
              savedGuidesList = state.guides;
            } else if (state is SaveGuideSuccess ||
                state is RemoveGuideSuccess) {
              // After success actions, try to preserve guides from current cubit state
              savedGuidesList = const [];
            }

            // Empty state when no guides are saved
            if (savedGuidesList.isEmpty) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const FavoriteSliverAppBar(),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border_sharp,
                            size: 48.sp,
                            color: AppColors.grey300Color,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "No saved guides yet",
                            style: AppTextStyle.primaryTextW400S14.copyWith(
                              color: AppColors.grey300Color,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            // Main view with saved guides list
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const FavoriteSliverAppBar(),

                /// Section title for saved guides
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 20.h,
                      bottom: 8.h,
                    ),
                    child: Text(
                      "Saved Tour Guides",
                      style: AppTextStyle.primaryTextW600S22.copyWith(
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),

                /// Vertical list of saved guide cards
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: SavedGuideCardWidget(
                          guide: savedGuidesList[index],
                        ),
                      );
                    }, childCount: savedGuidesList.length),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Shimmer skeleton effect for loading state
  Widget _buildListShimmer() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Shimmer.fromColors(
              baseColor: AppColors.grey100Color,
              highlightColor: AppColors.whiteColor,
              child: Container(
                height: 90.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          childCount: 4,
        ),
      ),
    );
  }
}
