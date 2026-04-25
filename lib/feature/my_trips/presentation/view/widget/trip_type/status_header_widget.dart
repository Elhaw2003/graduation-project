import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/build_icon_context.dart';

class StatusHeaderWidget extends StatelessWidget {
  const StatusHeaderWidget({
    super.key,
    required this.date,
    required this.status,
    required this.statusColor,
  });
  final String date;
  final String status;
  final Color statusColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BuildIconContext(icon: Icons.calendar_month_outlined, title: date),
        Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
