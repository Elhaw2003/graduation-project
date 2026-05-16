import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/my_trips/my_trip_appbar.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/my_trips/my_trip_body.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          /// App Bar
          const MyTripAppbar(),
          // Body cards
          MyTripBody(),
        ],
      ),
    );
  }
}
