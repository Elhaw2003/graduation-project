import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class TouristProfileLoadingSkeleton extends StatelessWidget {
  const TouristProfileLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 264.h,
          pinned: true,
          backgroundColor: AppColors.secondaryColor,
          leading: const BackButton(color: Colors.white),
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.white24,
                    highlightColor: Colors.white54,
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Shimmer.fromColors(
                    baseColor: Colors.white24,
                    highlightColor: Colors.white54,
                    child: Container(
                      width: 150.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(17.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: List.generate(
                  4,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Container(
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
