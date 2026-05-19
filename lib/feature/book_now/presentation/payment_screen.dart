import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_sliver_appbar_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/step_header_widget.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({
    super.key,
    required this.tourName,
    required this.selectedDate,
    required this.bookingTime,
  });

  final String tourName;
  final DateTime selectedDate;
  final String bookingTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),

        child: CustomScrollView(
          slivers: [
            /// APP BAR
            const CustomSliverAppbarWidget(
              title: 'Payment',
            ),

            SliverToBoxAdapter(
              child: CustomHeightSpacingWidget(height: 16),
            ),

            /// HEADER
            const SliverToBoxAdapter(
              child: StepHeaderWidget(
                currentStep: 3,
              ),
            ),

            SliverToBoxAdapter(
              child: CustomHeightSpacingWidget(height: 30),
            ),

            /// PAYMENT CARD
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16.sp),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(14.r),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// TITLE
                    Text(
                      'Payment Details',
                      style: AppTextStyle.primaryTextW500S17,
                    ),

                    SizedBox(height: 20.h),

                    /// BOOKING SUMMARY
                    Text(
                      'Booking Summary',
                      style: AppTextStyle.primaryTextW500S17,
                    ),

                    SizedBox(height: 20.h),

                    /// TOUR NAME
                    Text(
                      'Tour Name',
                      style: AppTextStyle.grey300W400S16,
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      tourName,
                      style: AppTextStyle.primaryTextW500S17,
                    ),

                    SizedBox(height: 16.h),

                    /// DATE
                    Text(
                      'Tour Date',
                      style: AppTextStyle.grey300W400S16,
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: AppTextStyle.primaryTextW500S17,
                    ),

                    SizedBox(height: 16.h),

                    /// TIME
                    Text(
                      'Time Slot',
                      style: AppTextStyle.grey300W400S16,
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      bookingTime,
                      style: AppTextStyle.primaryTextW500S17,
                    ),

                    SizedBox(height: 30.h),

                    /// PAYMENT METHOD
                    Text(
                      'Select Payment Method',
                      style: AppTextStyle.primaryTextW500S17,
                    ),

                    SizedBox(height: 16.h),

                    Container(
                      padding: EdgeInsets.all(14.sp),

                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),

                        borderRadius: BorderRadius.circular(12.r),
                      ),

                      child: Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            color: AppColors.primaryColor,
                          ),

                          SizedBox(width: 12.w),

                          Text(
                            'Credit/Debit Card',
                            style: AppTextStyle.primaryTextW500S17,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 14.h),

                    /// CARD HOLDER
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Cardholder Name',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    /// CARD NUMBER
                    TextFormField(
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        hintText: 'Card Number',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,

                            decoration: InputDecoration(
                              hintText: 'MM/YY',

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12.w),

                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,

                            decoration: InputDecoration(
                              hintText: 'CVV',

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,

                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),

                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Booking Completed'),
                            ),
                          );
                        },

                        child: const Text(
                          'Confirm Payment',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: CustomHeightSpacingWidget(height: 30),
            ),
          ],
        ),
      ),
    );
  }
}