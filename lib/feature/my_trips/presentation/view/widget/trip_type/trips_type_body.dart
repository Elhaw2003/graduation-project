import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/my_trips/data/enum/trip_type_enum.dart';
import 'package:smart_guide/feature/my_trips/data/model/my_trip_model.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/my_trips/my_trip_appbar.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/past_trip_card_widget.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/tab_item_widget.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/upcoming_trip_card_widget.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class TripsTypeBody extends StatefulWidget {
  final TripTypeEnum tripType; // القيمة المستلمة من الـ Router
  const TripsTypeBody({super.key, required this.tripType});

  @override
  State<TripsTypeBody> createState() => _TripsTypeBodyState();
}

class _TripsTypeBodyState extends State<TripsTypeBody> {
  late TripTypeEnum currentType;

  @override
  void initState() {
    super.initState();
    // تهيئة النوع المختار بناءً على ما تم تمريره من الصفحة السابقة
    currentType = widget.tripType;
  }

  @override
  Widget build(BuildContext context) {
    // تحديد قائمة البيانات بناءً على النوع الحالي
    final List<MyTripModel> trips = currentType == TripTypeEnum.upcoming
        ? upcomingTripsStatic
        : pastTripsStatic;

    return CustomScrollView(
      slivers: [
        // 1. الـ App Bar
        MyTripAppbar(),
        // 2. الـ Tabs للتبديل بين Upcoming و Past
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TabItemWidget(
                  icon: Icons.confirmation_number_outlined,
                  title: LocaleKeys.upcoming.tr(),
                  isSelected: currentType == TripTypeEnum.upcoming,
                  onTap: () {
                    setState(() {
                      currentType = TripTypeEnum.upcoming;
                    });
                  },
                ),
                CustomWidthSpacingWidget(width: 12),
                TabItemWidget(
                  icon: Icons.history,
                  title: LocaleKeys.pastTrips.tr(),
                  isSelected: currentType == TripTypeEnum.past,
                  onTap: () {
                    setState(() {
                      currentType = TripTypeEnum.past;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 24)),
        // 3. عرض القائمة بناءً على الطول الفعلي للبيانات
        trips.isEmpty
            ? SliverFillRemaining(child: emptyTripsWidget())
            : SliverList.separated(
                separatorBuilder: (context, index) =>
                    CustomHeightSpacingWidget(height: 20),
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  return currentType == TripTypeEnum.upcoming
                      ? UpcomingTripCardWidget(trip: trips[index])
                      : PastTripCardWidget(trip: trips[index]);
                },
              ),
      ],
    );
  }
}

Widget emptyTripsWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Assets.imagesSvgTravelEmpty,
          width: 350.w,
          height: 350.h,
        ),
        CustomHeightSpacingWidget(height: 20),
        Text(
          LocaleKeys.travelEmpty.tr(),
          style: AppTextStyle.grey300W400S16,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
