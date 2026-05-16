import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/my_trips/data/enum/trip_type_enum.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/my_trips/trip_card_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class MyTripBody extends StatefulWidget {
  const MyTripBody({super.key});

  @override
  State<MyTripBody> createState() => _MyTripBodyState();
}

class _MyTripBodyState extends State<MyTripBody> {
  TripTypeEnum? selectTripType;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.myTripsDescription.tr(),
            style: AppTextStyle.primary400TextW500S16.copyWith(
              color: AppColors.grey200Color,
            ),
          ),
          CustomHeightSpacingWidget(height: 80),

          // Upcoming trips card
          TripTypeCard(
            title: LocaleKeys.upcoming.tr(),
            icon: Icons.confirmation_number_outlined,
            onTap: () {
              // 1. Update state
              setState(() => selectTripType = TripTypeEnum.upcoming);
              // 2. Navigate to the trips type screen
              if (context.mounted) {
                context.pushNamed(
                  AppRoutes.tripsTypeScreen,
                  pathParameters: {'tripType': TripTypeEnum.upcoming.name},
                );
              }
            },
            height: 200,
            width: 190,
          ),

          CustomHeightSpacingWidget(height: 32),

          // Past trips card
          TripTypeCard(
            title: LocaleKeys.pastTrips.tr(),
            icon: Icons.history,
            height: 200,
            width: 190,
            onTap: () {
              // 1. Update state for Past
              setState(() => selectTripType = TripTypeEnum.past);
              // 2. Navigate
              if (context.mounted) {
                context.pushNamed(
                  AppRoutes.tripsTypeScreen,
                  pathParameters: {'tripType': TripTypeEnum.past.name},
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
