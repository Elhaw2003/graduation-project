import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/my_trips/data/model/my_trip_model.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/build_icon_context.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/image_card_widget.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/status_header_widget.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/trip_button_widget.dart';

class PastTripCardWidget extends StatelessWidget {
  const PastTripCardWidget({super.key, required this.trip});
  final MyTripModel trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.yellowLightColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ImageCardWidget(image: trip.image, title: trip.title),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusHeaderWidget(
                      date: trip.date,
                      status: "Completed",
                      statusColor: AppColors.brownColor,
                    ),
                    CustomHeightSpacingWidget(height: 8),
                    BuildIconContext(
                      icon: Icons.person_outline,
                      title: "Guide: ${trip.guideName}",
                    ),
                    CustomHeightSpacingWidget(height: 8),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < (trip.rating ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          color: AppColors.starColore,
                          size: 25.sp,
                        ),
                      ),
                    ),
                    CustomHeightSpacingWidget(height: 8),
                    BuildIconContext(
                      icon: Icons.payments_outlined,
                      title: "Total: \$${trip.totalPrice}",
                    ),
                    CustomHeightSpacingWidget(height: 20),
                    Row(
                      children: [
                        TripButtonWidget(
                          title: "Details",
                          colorButton: AppColors.primaryColor,
                        ),
                        SizedBox(width: 8.w),
                        TripButtonWidget(
                          title: "Rebook",
                          colorButton: AppColors.brownColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
