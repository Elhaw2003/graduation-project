import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/book_now/data/booknow/booknow_cubit.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_cubit.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_states.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

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
  State<PaymentStepWidget> createState() => _PaymentStepWidgetState();
}

class _PaymentStepWidgetState extends State<PaymentStepWidget>
    with SingleTickerProviderStateMixin {
  // 2 = Online Payment (Stripe), 1 = Cash Payment
  int _selectedPaymentMethod = 2;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onConfirmPayment() {
    final cubit = context.read<BookingAndPaymentCubit>();
    final bookNowCubit = context.read<BookNowCubit>();
    final slotId = cubit.selectedSlot?.id ?? '';

    if (slotId.isEmpty) return;

    final tourId = bookNowCubit.selectedTourId ?? '';
    if (tourId.isEmpty) return;

    if (_selectedPaymentMethod == 2) {
      cubit.executeStripePaymentGatewayFlow(tourId: tourId, slotId: slotId);
    } else {
      cubit.executeCashBookingFlow(tourId: tourId, slotId: slotId);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(28.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated check icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.greenColor,
                        AppColors.greenColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.greenColor.withValues(alpha: 0.3),
                        blurRadius: 20.r,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 44.sp,
                  ),
                ),
              ),

              CustomHeightSpacingWidget(height: 24),

              Text(
                LocaleKeys.bookingSuccessTitle.tr(),
                style: AppTextStyle.black1F2937W500S20,
                textAlign: TextAlign.center,
              ),

              CustomHeightSpacingWidget(height: 12),

              Text(
                LocaleKeys.bookingSuccessMessage.tr(),
                style: AppTextStyle.grey300W400S16,
                textAlign: TextAlign.center,
              ),

              CustomHeightSpacingWidget(height: 28),

              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.goNamed(AppRoutes.touristApp);
                  },
                  child: Text(
                    LocaleKeys.goToMyTrips.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingAndPaymentCubit, BookingPaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          _showSuccessDialog();
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.redAppColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        } else if (state is CreateBookingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.redAppColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        }
      },
      child: SliverToBoxAdapter(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.08),
                  blurRadius: 20.r,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    LocaleKeys.paymentDetails.tr(),
                    style: AppTextStyle.black1F2937W500S20,
                  ),
                ),

                CustomHeightSpacingWidget(height: 24),

                // Booking Summary Card
                _buildBookingSummaryCard(),

                CustomHeightSpacingWidget(height: 24),

                // Payment Method Selection
                Text(
                  LocaleKeys.selectPaymentMethod.tr(),
                  style: AppTextStyle.primaryTextW500S17,
                ),
                CustomHeightSpacingWidget(height: 14),

                // Card (Stripe) option
                _buildPaymentMethodTile(
                  title: LocaleKeys.creditDebitCard.tr(),
                  icon: Icons.credit_card_rounded,
                  value: 2,
                  gradientColors: [
                    const Color(0xFF6772E5),
                    const Color(0xFF7B68EE),
                  ],
                ),

                CustomHeightSpacingWidget(height: 10),

                // Cash option
                _buildPaymentMethodTile(
                  title: LocaleKeys.cashPayment.tr(),
                  icon: Icons.payments_rounded,
                  value: 1,
                  gradientColors: [
                    AppColors.greenColor,
                    AppColors.greenColor.withValues(alpha: 0.7),
                  ],
                ),

                CustomHeightSpacingWidget(height: 30),

                // Confirm Button
                BlocBuilder<BookingAndPaymentCubit, BookingPaymentState>(
                  builder: (context, state) {
                    final isLoading =
                        state is CreateBookingLoading ||
                        state is PaymentIntentLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 4,
                          shadowColor: AppColors.primaryColor.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        onPressed: isLoading ? null : _onConfirmPayment,
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20.r,
                                    height: 20.r,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  CustomWidthSpacingWidget(width: 12),
                                  Text(
                                    LocaleKeys.processingPayment.tr(),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _selectedPaymentMethod == 2
                                        ? Icons.lock_rounded
                                        : Icons.payments_rounded,
                                    size: 20.sp,
                                  ),
                                  CustomWidthSpacingWidget(width: 8),
                                  Text(
                                    LocaleKeys.confirmPayment.tr(),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingSummaryCard() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.04),
            AppColors.primaryColor.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
              CustomWidthSpacingWidget(width: 8),
              Text(
                LocaleKeys.bookingSummary.tr(),
                style: AppTextStyle.primaryTextW500S17,
              ),
            ],
          ),
          CustomHeightSpacingWidget(height: 16),
          _buildSummaryRow(
            LocaleKeys.tourName.tr(),
            widget.tourId,
            Icons.tour_rounded,
          ),
          CustomHeightSpacingWidget(height: 12),
          _buildSummaryRow(
            LocaleKeys.tourDate.tr(),
            '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
            Icons.calendar_today_rounded,
          ),
          CustomHeightSpacingWidget(height: 12),
          _buildSummaryRow(
            LocaleKeys.timeSlot.tr(),
            widget.bookingTime,
            Icons.schedule_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey.shade500),
        CustomWidthSpacingWidget(width: 8),
        Text(title, style: AppTextStyle.grey300W400S16),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: AppTextStyle.primaryTextW500S17.copyWith(fontSize: 14.sp),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile({
    required String title,
    required IconData icon,
    required int value,
    required List<Color> gradientColors,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? gradientColors.first.withValues(alpha: 0.06)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? gradientColors.first : Colors.grey.shade300,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: Colors.white, size: 20.sp),
            ),
            CustomWidthSpacingWidget(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.primaryTextW500S17.copyWith(
                  color: isSelected
                      ? gradientColors.first
                      : AppColors.primaryTextColor,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? gradientColors.first : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? gradientColors.first
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
