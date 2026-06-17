import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/booking_payment/data/model/booking_model.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_cubit.dart';
import 'package:smart_guide/feature/booking_payment/presentation/cubit/booking_payment_states.dart';
import 'package:smart_guide/feature/my_trips/data/enum/trip_type_enum.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/my_trips/my_trip_appbar.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/trip_type/tab_item_widget.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class TripsTypeBody extends StatefulWidget {
  final TripTypeEnum tripType;
  const TripsTypeBody({super.key, required this.tripType});

  @override
  State<TripsTypeBody> createState() => _TripsTypeBodyState();
}

class _TripsTypeBodyState extends State<TripsTypeBody> {
  late TripTypeEnum currentType;

  @override
  void initState() {
    super.initState();
    currentType = widget.tripType;
    context.read<BookingAndPaymentCubit>().fetchTouristActiveBookings();
  }

  Future<void> _refresh() async {
    context.read<BookingAndPaymentCubit>().fetchTouristActiveBookings();
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      color: AppColors.primaryColor,
      child: CustomScrollView(
        slivers: [
          const MyTripAppbar(),

        // Tab Switcher
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
                  onTap: () => setState(() => currentType = TripTypeEnum.upcoming),
                ),
                CustomWidthSpacingWidget(width: 12),
                TabItemWidget(
                  icon: Icons.history,
                  title: LocaleKeys.pastTrips.tr(),
                  isSelected: currentType == TripTypeEnum.past,
                  onTap: () => setState(() => currentType = TripTypeEnum.past),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 24)),

        // Content
        BlocConsumer<BookingAndPaymentCubit, BookingPaymentState>(
          listener: (context, state) {
            if (state is CancelBookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.bookingCancelled.tr()),
                  backgroundColor: AppColors.greenColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            } else if (state is CancelBookingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: AppColors.redAppColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is MyBookingsLoading || state is CancelBookingLoading) {
              return SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    strokeWidth: 2.5,
                  ),
                ),
              );
            }

            if (state is MyBookingsFailure) {
              return SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48.sp,
                          color: Colors.grey.shade400,
                        ),
                        CustomHeightSpacingWidget(height: 16),
                        Text(
                          state.errorMessage,
                          style: AppTextStyle.grey300W400S16,
                          textAlign: TextAlign.center,
                        ),
                        CustomHeightSpacingWidget(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<BookingAndPaymentCubit>()
                                .fetchTouristActiveBookings();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is MyBookingsSuccess) {
              final filteredBookings = currentType == TripTypeEnum.upcoming
                  ? state.bookings.where((b) => b.isUpcoming).toList()
                  : state.bookings.where((b) => b.isPast).toList();

              if (filteredBookings.isEmpty) {
                return SliverFillRemaining(child: _buildEmptyTripsWidget());
              }

              return SliverList.separated(
                separatorBuilder: (context, index) =>
                    CustomHeightSpacingWidget(height: 16),
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  return _BookingCard(
                    booking: filteredBookings[index],
                    isUpcoming: currentType == TripTypeEnum.upcoming,
                  );
                },
              );
            }

            return SliverFillRemaining(child: _buildEmptyTripsWidget());
          },
        ),

        SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 30)),
      ],
      ),
    );
  }

  Widget _buildEmptyTripsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.imagesSvgTravelEmpty,
            width: 250.w,
            height: 250.h,
          ),
          CustomHeightSpacingWidget(height: 20),
          Text(
            LocaleKeys.noBookingsYet.tr(),
            style: AppTextStyle.grey300W400S16,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ================================================================
// Premium Booking Card Widget
// ================================================================

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isUpcoming;

  const _BookingCard({required this.booking, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _statusGradient(booking.status),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _statusIcon(booking.status),
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      CustomWidthSpacingWidget(width: 8),
                      Text(
                        _statusLabel(booking.status),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    booking.paymentMethodLabel,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: [
                  // Date & Time Row
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: booking.slot.date.isNotEmpty
                            ? booking.slot.date
                            : '--',
                      ),
                      CustomWidthSpacingWidget(width: 12),
                      _buildInfoChip(
                        icon: Icons.schedule_rounded,
                        label: booking.slot.displayTime.isNotEmpty
                            ? booking.slot.displayTime
                            : '--',
                      ),
                    ],
                  ),

                  CustomHeightSpacingWidget(height: 14),

                  // Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.totalPrice.tr(),
                        style: AppTextStyle.grey300W400S16,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greenColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '\$${booking.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.greenColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Cancel button for upcoming
                  if (isUpcoming) ...[
                    CustomHeightSpacingWidget(height: 14),
                    Divider(color: Colors.grey.shade200, height: 1),
                    CustomHeightSpacingWidget(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 42.h,
                      child: OutlinedButton.icon(
                        onPressed: () => _showCancelConfirmation(context),
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: 18.sp,
                          color: AppColors.redAppColor,
                        ),
                        label: Text(
                          LocaleKeys.cancelBookingAction.tr(),
                          style: TextStyle(
                            color: AppColors.redAppColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.redAppColor.withValues(alpha: 0.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.sp, color: AppColors.primaryColor),
            CustomWidthSpacingWidget(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          LocaleKeys.cancelBookingAction.tr(),
          style: AppTextStyle.primaryTextW500S17,
        ),
        content: Text(
          LocaleKeys.cancelBookingConfirm.tr(),
          style: AppTextStyle.grey300W400S16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              LocaleKeys.next.tr(),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context
                  .read<BookingAndPaymentCubit>()
                  .cancelExistingBooking(bookingId: booking.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redAppColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(LocaleKeys.cancelBookingAction.tr()),
          ),
        ],
      ),
    );
  }

  List<Color> _statusGradient(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return [const Color(0xFFF59E0B), const Color(0xFFFBBF24)];
      case 'confirmed':
        return [AppColors.greenColor, const Color(0xFF34D399)];
      case 'completed':
        return [AppColors.primaryColor, const Color(0xFF818CF8)];
      case 'cancelled':
        return [AppColors.redAppColor, const Color(0xFFF87171)];
      default:
        return [Colors.grey.shade600, Colors.grey.shade400];
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_top_rounded;
      case 'confirmed':
        return Icons.check_circle_rounded;
      case 'completed':
        return Icons.done_all_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return LocaleKeys.statusPending.tr();
      case 'confirmed':
        return LocaleKeys.statusConfirmed.tr();
      case 'completed':
        return LocaleKeys.statusCompleted.tr();
      case 'cancelled':
        return LocaleKeys.statusCancelled.tr();
      default:
        return status;
    }
  }
}
