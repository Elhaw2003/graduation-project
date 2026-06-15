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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(),
            CustomHeightSpacingWidget(height: 14),
            if (state is GetGuideBookingsLoading)
              _buildLoadingShimmer()
            else if (state is GetGuideBookingsFailure)
              _buildErrorCard(state.errorMessage)
            else if (state is GetGuideBookingsSuccess)
              state.guideBookingsList.isEmpty
                  ? _buildEmptyState()
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: state.guideBookingsList
                            .map(
                              (booking) => Padding(
                                padding: EdgeInsets.only(bottom: 14.h),
                                child: _GuideBookingCard(booking: booking),
                              ),
                            )
                            .toList(),
                      ),
                    )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.receipt_long_rounded,
            color: Colors.white,
            size: 22.sp,
          ),
        ),
        CustomWidthSpacingWidget(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.guideBookingsTitle.tr(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
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
          padding: EdgeInsets.only(bottom: 12.h),
          child: Container(
            height: 140.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Center(
              child: SizedBox(
                width: 24.sp,
                height: 24.sp,
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
      padding: EdgeInsets.symmetric(vertical: 40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 52.sp,
            color: AppColors.grey300Color,
          ),
          CustomHeightSpacingWidget(height: 12),
          Text(
            LocaleKeys.noBookings.tr(),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.grey400Color,
            ),
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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF10B981);
      case 'pending':
        return AppColors.orangeColor;
      case 'cancelled':
        return AppColors.redAppColor;
      case 'completed':
        return AppColors.primaryColor;
      default:
        return AppColors.grey400Color;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle_rounded;
      case 'pending':
        return Icons.schedule_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'completed':
        return Icons.task_alt_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _formatCreatedAt(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusClr = _statusColor(booking.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: statusClr.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: statusClr.withOpacity(0.25), width: 1.2),
      ),
      child: Column(
        children: [
          // Top gradient header with status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusClr.withOpacity(0.08),
                  statusClr.withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Row(
              children: [
                Icon(
                  _statusIcon(booking.status),
                  color: statusClr,
                  size: 20.sp,
                ),
                CustomWidthSpacingWidget(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusClr.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: TextStyle(
                      color: statusClr,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${booking.totalPrice.toStringAsFixed(0)} EGP',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
            child: Column(
              children: [
                // Date & Time row
                if (booking.slot != null) ...[
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: booking.slot!.date,
                        color: AppColors.primaryColor,
                      ),
                      CustomWidthSpacingWidget(width: 10),
                      _InfoChip(
                        icon: Icons.access_time_rounded,
                        label:
                            '${booking.slot!.startTime} — ${booking.slot!.endTime}',
                        color: AppColors.secondaryColor,
                      ),
                    ],
                  ),
                  CustomHeightSpacingWidget(height: 10),
                ],

                // Payment + Created At row
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.payment_rounded,
                      label: booking.paymentMethod,
                      color: AppColors.greenColor,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.history_rounded,
                      size: 14.sp,
                      color: AppColors.grey400Color,
                    ),
                    CustomWidthSpacingWidget(width: 4),
                    Text(
                      _formatCreatedAt(booking.createdAtUtc),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.grey400Color,
                      ),
                    ),
                  ],
                ),

                // Add-ons
                if (booking.selectedAddOns.isNotEmpty) ...[
                  CustomHeightSpacingWidget(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: booking.selectedAddOns.map((addon) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.contanerColore,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '${addon.title} (+${addon.price.toStringAsFixed(0)})',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: color),
        CustomWidthSpacingWidget(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText400Color,
          ),
        ),
      ],
    );
  }
}
