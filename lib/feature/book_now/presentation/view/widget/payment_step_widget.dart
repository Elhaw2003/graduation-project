import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class PaymentStepWidget extends StatefulWidget {
  const PaymentStepWidget({
    super.key,
    required this.tourId,
    required this.selectedDate,
    required this.bookingTime,
  });

  final String tourId;
  final DateTime selectedDate;
  final String bookingTime;

  @override
  State<PaymentStepWidget> createState() =>
      _PaymentStepWidgetState();
}

class _PaymentStepWidgetState
    extends State<PaymentStepWidget> {

  String paymentMethod = 'Card';

  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(

      child: Container(

        width: double.infinity,

        padding: EdgeInsets.all(16.sp),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(14.r),

          boxShadow: [

            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8.r,
            ),
          ],
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// TITLE
            Center(
              child: Text(

                'Payment Details',

                style:
                    AppTextStyle.black1F2937W500S20,
              ),
            ),

            SizedBox(height: 24.h),

            /// BOOKING SUMMARY
            Container(

              padding: EdgeInsets.all(14.sp),

              decoration: BoxDecoration(

                color: Colors.grey.shade100,

                borderRadius:
                    BorderRadius.circular(
                  12.r,
                ),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    'Booking Summary',

                    style:
                        AppTextStyle.primaryTextW500S17,
                  ),

                  SizedBox(height: 20.h),

                  _buildRow(
                    'Tour',
                    widget.tourId,
                  ),

                  SizedBox(height: 12.h),

                  _buildRow(
                    'Tour Date',

                    '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                  ),

                  SizedBox(height: 12.h),

                  _buildRow(
                    'Time Slot',
                    widget.bookingTime,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            /// PAYMENT METHOD
            Text(
              'Select Payment Method',

              style:
                  AppTextStyle.primaryTextW500S17,
            ),

            SizedBox(height: 16.h),

            _paymentTile(
              title: 'Credit / Debit Card',
              value: 'Card',
              icon: Icons.credit_card,
            ),

            _paymentTile(
              title: 'Cash',
              value: 'Cash',
              icon: Icons.payments,
            ),

            _paymentTile(
              title: 'PayPal',
              value: 'Paypal',
              icon: Icons.account_balance_wallet,
            ),

            SizedBox(height: 24.h),

            /// CARD DETAILS
            if (paymentMethod == 'Card') ...[

              Text(
                'Card Details',

                style:
                    AppTextStyle.primaryTextW500S17,
              ),

              SizedBox(height: 16.h),

              TextFormField(
                decoration: InputDecoration(

                  hintText:
                      'Cardholder Name',

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      10.r,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              TextFormField(

                keyboardType:
                    TextInputType.number,

                decoration: InputDecoration(

                  hintText:
                      '1234 5678 9012 3456',

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      10.r,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Row(

                children: [

                  Expanded(
                    child: TextFormField(

                      decoration:
                          InputDecoration(

                        hintText: 'MM/YY',

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            10.r,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: TextFormField(

                      keyboardType:
                          TextInputType.number,

                      decoration:
                          InputDecoration(

                        hintText: 'CVV',

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            10.r,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 30.h),

            /// CONFIRM BUTTON
            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      AppColors.primaryColor,

                  padding:
                      EdgeInsets.symmetric(
                    vertical: 15.h,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12.r,
                    ),
                  ),
                ),

                onPressed: () {

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(

                    const SnackBar(
                      content: Text(
                        'Booking Completed Successfully',
                      ),
                    ),
                  );
                },

                child: Text(

                  'Confirm Payment',

                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String title,
    String value,
  ) {

    return Row(

      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,

          style:
              AppTextStyle.grey300W400S16,
        ),

        Text(
          value,

          style:
              AppTextStyle.primaryTextW500S17,
        ),
      ],
    );
  }

  Widget _paymentTile({
    required String title,
    required String value,
    required IconData icon,
  }) {

    return RadioListTile(

      value: value,

      groupValue: paymentMethod,

      activeColor:
          AppColors.primaryColor,

      onChanged: (value) {

        setState(() {
          paymentMethod = value!;
        });
      },

      title: Text(title),

      secondary: Icon(
        icon,
        color: AppColors.primaryColor,
      ),
    );
  }
}