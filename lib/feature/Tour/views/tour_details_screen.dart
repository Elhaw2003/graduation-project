import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/book_now/data/model/tour_model.dart';

class TourDetailsScreen extends StatelessWidget {
  final TourModel tour;

  const TourDetailsScreen({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// ================= IMAGE HEADER =================
          SliverAppBar(
            expandedHeight: 320.h,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(tour.primaryImage, fit: BoxFit.cover),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 25,
                    left: 16,
                    right: 16,
                    child: Text(
                      tour.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= CONTENT =================
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ================= INFO CARDS =================
                  Row(
                    children: [
                      _infoCard(Icons.timer, "${tour.durationHours}h"),
                      SizedBox(width: 10.w),
                      _infoCard(Icons.people, "${tour.maxGroupSize}"),
                      SizedBox(width: 10.w),
                      _infoCard(Icons.attach_money, "${tour.price}"),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  /// ================= PRICE =================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.15),
                          AppColors.primaryColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Text(
                      "Price: \$${tour.price}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// ================= ABOUT =================
                  Text(
                    "About Tour",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    "This tour gives you an amazing experience with professional guidance, "
                    "beautiful locations and unforgettable memories. "
                    "You can explore historical places, enjoy culture and discover hidden gems.",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= INFO CARD =================
  Widget _infoCard(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            SizedBox(height: 6.h),
            Text(text, style: TextStyle(fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }
}
