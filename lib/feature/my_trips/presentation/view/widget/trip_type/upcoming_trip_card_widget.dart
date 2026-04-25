import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/my_trips/data/model/my_trip_model.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/build_icon_context.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/image_card_widget.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/status_header_widget.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/trip_button_widget.dart';

class UpcomingTripCardWidget extends StatelessWidget {
  const UpcomingTripCardWidget({super.key, required this.trip});
  final MyTripModel trip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
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
                        status: "Upcoming",
                        statusColor: AppColors.brownColor,
                      ),
                      CustomHeightSpacingWidget(height: 8),
                      BuildIconContext(
                        icon: Icons.person_outline,
                        title: "Guide: ${trip.guideName}",
                      ),
                      CustomHeightSpacingWidget(height: 8),
                      BuildIconContext(
                        icon: Icons.location_on_outlined,
                        title: "Point: ${trip.startingPoint ?? 'N/A'}",
                      ),
                      CustomHeightSpacingWidget(height: 8),
                      BuildIconContext(
                        icon: Icons.payments_outlined,
                        title: "Total: \$${trip.totalPrice}",
                      ),
                      CustomHeightSpacingWidget(height: 8),
                      BuildIconContext(
                        icon: Icons.access_time,
                        title: "Pickup: ${trip.pickupTime ?? 'N/A'}",
                      ),
                      CustomHeightSpacingWidget(height: 20),
                      Row(
                        children: [
                          TripButtonWidget(
                            title: "Ticket",
                            colorButton: AppColors.primaryColor,
                          ),
                          SizedBox(width: 8.w),
                          TripButtonWidget(
                            title: "Contact",
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
      ),
    );
  }
}
