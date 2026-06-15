import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_booking_model.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_states.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class GuideBookingsLiveFeed extends StatefulWidget {
  const GuideBookingsLiveFeed({super.key});

  @override
  State<GuideBookingsLiveFeed> createState() => _GuideBookingsLiveFeedState();
}

class _GuideBookingsLiveFeedState extends State<GuideBookingsLiveFeed>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    context.read<GuideDashboardCubit>().fetchGuideBookings();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GuideDashboardCubit, GuideDashboardState>(
      listenWhen: (prev, curr) =>
          curr is GetGuideBookingsSuccess || curr is GetGuideBookingsFailure,
      listener: (context, state) {
        if (state is GetGuideBookingsSuccess) {
          _fadeController.forward(from: 0.0);
        }
      },
      buildWhen: (prev, curr) =>
          curr is GetGuideBookingsLoading ||
          curr is GetGuideBookingsSuccess ||
          curr is GetGuideBookingsFailure,
      builder: (context, state) {
        final pendingCount = state is GetGuideBookingsSuccess
            ? state.guideBookingsList
                .where((b) => b.status.toLowerCase() == 'pending')
                .length
            : 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(pendingCount),
            CustomHeightSpacingWidget(height: 14),
            if (state is GetGuideBookingsLoading)
              _buildLoadingShimmer()
            else if (state is GetGuideBookingsFailure)
              _buildErrorCard(state.errorMessage)
            else if (state is GetGuideBookingsSuccess)
              Builder(builder: (context) {
                final pendingBookings = state.guideBookingsList
                    .where((b) => b.status.toLowerCase() == 'pending')
                    .toList();
                return pendingBookings.isEmpty
                    ? _buildEmptyState()
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: pendingBookings
                              .map(
                                (booking) => Padding(
                                  padding: EdgeInsets.only(bottom: 18.h),
                                  child: _GuideBookingCard(booking: booking),
                                ),
                              )
                              .toList(),
                        ),
                      );
              })
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(int pendingCount) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: AppColors.orangeColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.schedule_rounded,
            color: AppColors.orangeColor,
            size: 22.sp,
          ),
        ),
        CustomWidthSpacingWidget(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    LocaleKeys.guideBookingsTitle.tr(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  if (pendingCount > 0) ...[
                    CustomWidthSpacingWidget(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppColors.orangeColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '$pendingCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                LocaleKeys.guideBookingsSubtitle.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(
        2,
        (_) => Padding(
          padding: EdgeInsets.only(bottom: 18.h),
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Center(
              child: SizedBox(
                width: 28.sp,
                height: 28.sp,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.orangeColor.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Decorative icon container
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.orangeColor.withOpacity(0.07),
                ),
              ),
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.orangeColor.withOpacity(0.13),
                ),
              ),
              Icon(
                Icons.event_available_rounded,
                size: 40.sp,
                color: AppColors.orangeColor,
              ),
            ],
          ),
          CustomHeightSpacingWidget(height: 20),
          Text(
            LocaleKeys.noBookings.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          CustomHeightSpacingWidget(height: 8),
          Text(
            'New booking requests will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.secondaryTextColor,
              height: 1.5,
            ),
          ),
          CustomHeightSpacingWidget(height: 24),
          // Decorative dots row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: i == 0 ? 20.w : 8.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: i == 0
                      ? AppColors.orangeColor
                      : AppColors.orangeColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400, size: 22.sp),
          CustomWidthSpacingWidget(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13.sp, color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideBookingCard extends StatelessWidget {
  final GuideBookingModel booking;

  const _GuideBookingCard({required this.booking});

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return '${dt.day.toString().padLeft(2, '0')} / '
          '${dt.month.toString().padLeft(2, '0')} / '
          '${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  String _formatTime(String raw) {
    try {
      final parts = raw.split(':');
      if (parts.length < 2) return raw;
      final h = int.parse(parts[0]);
      final m = parts[1].padLeft(2, '0');
      final period = h >= 12 ? 'PM' : 'AM';
      final hour = h % 12 == 0 ? 12 : h % 12;
      return '$hour:$m $period';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    const pendingColor = Color(0xFFF97316);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: pendingColor.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Hero banner ──────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: icon + status badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                        color: pendingColor.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.pending_actions_rounded,
                        color: pendingColor,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: pendingColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule_rounded,
                              color: Colors.white, size: 13.sp),
                          SizedBox(width: 5.w),
                          Text(
                            'PENDING',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Right: price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.grey400Color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${booking.totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                        color: pendingColor,
                        height: 1,
                      ),
                    ),
                    Text(
                      'EGP',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: pendingColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Divider with icon ─────────────────────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Icon(Icons.more_horiz_rounded,
                    size: 16.sp, color: AppColors.grey300Color),
              ),
            ],
          ),

          // ── Details body ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
            child: Column(
              children: [
                // Slot info
                if (booking.slot != null) ...[
                  _DetailRow(
                    icon: Icons.calendar_month_rounded,
                    iconBg: const Color(0xFFEEF2FF),
                    iconColor: AppColors.primaryColor,
                    label: 'Tour Date',
                    value: _formatDate(booking.slot!.date),
                  ),
                  SizedBox(height: 12.h),
                  _DetailRow(
                    icon: Icons.access_time_filled_rounded,
                    iconBg: const Color(0xFFECFDF5),
                    iconColor: AppColors.greenColor,
                    label: 'Time Slot',
                    value:
                        '${_formatTime(booking.slot!.startTime)}  →  ${_formatTime(booking.slot!.endTime)}',
                  ),
                  SizedBox(height: 12.h),
                ],

                // Payment method
                _DetailRow(
                  icon: Icons.credit_card_rounded,
                  iconBg: const Color(0xFFFFF7ED),
                  iconColor: pendingColor,
                  label: 'Payment',
                  value: booking.paymentMethod,
                ),

                // Booked on
                SizedBox(height: 12.h),
                _DetailRow(
                  icon: Icons.history_rounded,
                  iconBg: const Color(0xFFF9FAFB),
                  iconColor: AppColors.grey400Color,
                  label: 'Booked On',
                  value: _formatDate(booking.createdAtUtc),
                ),

                // Add-ons
                if (booking.selectedAddOns.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Add-ons',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: booking.selectedAddOns.map((addon) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.contanerColore,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_circle_outline_rounded,
                                size: 13.sp,
                                color: AppColors.secondaryColor),
                            SizedBox(width: 5.w),
                            Text(
                              '${addon.title}  +${addon.price.toStringAsFixed(0)} EGP',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(9.sp),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 18.sp, color: iconColor),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.grey400Color,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
