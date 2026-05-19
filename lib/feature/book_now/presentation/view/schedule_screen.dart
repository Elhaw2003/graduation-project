import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_sliver_appbar_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_cubit.dart';
import 'package:smart_guide/feature/book_now/presentation/payment_screen.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/step_header_widget.dart';

class ScheduleStepWidget extends StatefulWidget {
  const ScheduleStepWidget({super.key});

  @override
  State<ScheduleStepWidget> createState() => _ScheduleStepWidgetState();
}

class _ScheduleStepWidgetState extends State<ScheduleStepWidget> {
  DateTime? selectedDate;

  String? selectedTime;

  final List<String> times = [
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',

    '11:00 AM',
    '12:00 PM',
    '01:00 PM',

    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(14.sp),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(14.r),

          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8.r),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// TITLE
            Center(
              child: Text(
                'Choose Your Slot',

                style: AppTextStyle.black1F2937W500S20,
              ),
            ),

            SizedBox(height: 20.h),

            /// DATE
            Text('Tour Date', style: AppTextStyle.primaryTextW500S17),

            SizedBox(height: 8.h),

            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,

                  firstDate: DateTime.now(),

                  lastDate: DateTime.now().add(const Duration(days: 365)),

                  initialDate: DateTime.now(),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },

              child: Container(
                width: double.infinity,

                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(10.r),

                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      selectedDate == null
                          ? 'Select Date'
                          : '${selectedDate!.day} / ${selectedDate!.month} / ${selectedDate!.year}',

                      style: AppTextStyle.primaryTextW500S17,
                    ),

                    Icon(Icons.calendar_month, color: AppColors.primaryColor),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            /// TIME SLOTS
            Text(
              'Available Time Slots',

              style: AppTextStyle.primaryTextW500S17,
            ),

            SizedBox(height: 12.h),

            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,

              children: times.map((time) {
                final isSelected = selectedTime == time;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTime = time;
                    });
                  },

                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),

                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.grey.shade400,

                      borderRadius: BorderRadius.circular(6.r),
                    ),

                    child: Text(
                      time,

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 30.h),

            /// NEXT BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,

                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),

                onPressed: () {
                  if (selectedDate == null || selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Select date and time')),
                    );

                    return;
                  }

                  context.read<BookNowCubit>().goToPaymentStep(
                    selectedDate!,
                    selectedTime!,
                  );
                },

                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
