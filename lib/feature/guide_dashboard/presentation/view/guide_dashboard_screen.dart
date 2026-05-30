import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_dashboard_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_statistics_model.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_states.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/widget/activity_timeline_item.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/widget/bookings_bar_chart.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/widget/dashboard_stat_card.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/widget/earnings_line_chart.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/widget/tour_performance_card.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class GuideDashboardScreen extends StatefulWidget {
  const GuideDashboardScreen({super.key});

  @override
  State<GuideDashboardScreen> createState() => _GuideDashboardScreenState();
}

class _GuideDashboardScreenState extends State<GuideDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAllData();
  }

  void _initializeAllData() {
    context.read<GuideDashboardCubit>().fetchDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<GuideDashboardCubit, GuideDashboardState>(
        builder: (context, state) {
          if (state is GuideDashboardInitial || state is GetDashboardLoading) {
            return const _DashboardLoadingSkeleton();
          }

          if (state is GetDashboardFailure) {
            return _DashboardErrorView(
              message: state.errorMessage,
              onRetry: () => _initializeAllData(),
            );
          }

          if (state is GetDashboardSuccess) {
            return _DashboardContent(
              dashboard: state.dashboardModel,
              onRetry: () => _initializeAllData(),
            );
          }

          return const _DashboardLoadingSkeleton();
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.dashboard, required this.onRetry});

  final GuideDashboardModel dashboard;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    // مأمنين الـ stats بـ Fallback لو الكائن كله جاء فارغاً
    final stats = dashboard.statistics;

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () async {
        onRetry();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          _buildSliverAppBar(context, stats),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
              child: _WalletHeroCard(stats: stats),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: _buildStatsGrid(context, stats),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
              child: _buildQuickAccessButtons(context),
            ),
          ),

          // عرض الشارتات الحقيقية التابعة للـ API مباشرة
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
              child: EarningsLineChart(earnings: dashboard.monthlyEarnings),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: BookingsBarChart(bookings: dashboard.monthlyBookings),
            ),
          ),

          // الرحلات الأكثر شعبية الحقيقية من السيرفر
          if (dashboard.mostPopularTours.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _SectionHeader(title: LocaleKeys.mostPopularTours.tr()),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => TourPerformanceCard(
                    tour: dashboard.mostPopularTours[index],
                    index: index,
                  ),
                  childCount: dashboard.mostPopularTours.length,
                ),
              ),
            ),
          ],

          // الرحلات الأقل نشاطاً الحقيقية من السيرفر
          if (dashboard.leastActiveTours.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _SectionHeader(title: LocaleKeys.leastActiveTours.tr()),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => TourPerformanceCard(
                    tour: dashboard.leastActiveTours[index],
                    index: index,
                  ),
                  childCount: dashboard.leastActiveTours.length,
                ),
              ),
            ),
          ],

          // النشاطات الأخيرة الحقيقية من السيرفر
          SliverToBoxAdapter(
            child: _SectionHeader(title: LocaleKeys.recentActivities.tr()),
          ),
          if (dashboard.recentActivities.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ActivityTimelineItem(
                    activity: dashboard.recentActivities[index],
                    isLast: index == dashboard.recentActivities.length - 1,
                    index: index,
                  ),
                  childCount: dashboard.recentActivities.length,
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: _EmptyStateWidget(
                icon: Icons.inbox_outlined,
                title: LocaleKeys.dashboardNoActivities.tr(),
              ),
            ),
          SliverToBoxAdapter(child: CustomHeightSpacingWidget(height: 30)),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(
    BuildContext context,
    GuideStatisticsModel stats,
  ) {
    return SliverAppBar(
      expandedHeight: 140.h,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: AppColors.secondaryColor,
      leading: const BackButton(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.secondaryColor,
                AppColors.primaryColor.withOpacity(0.85),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(56.w, 16.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    LocaleKeys.guideDashboard.tr(),
                    style: AppTextStyle.whitePoppinsW500S24,
                  ),
                  CustomHeightSpacingWidget(height: 4),
                  Row(
                    children: [
                      _statusBadge(
                        stats.verificationStatus.isEmpty ||
                                stats.verificationStatus == 'NotVerified'
                            ? 'NotVerified'
                            : stats.verificationStatus,
                        stats.verificationStatus == 'Approved'
                            ? AppColors.greenColor
                            : stats.verificationStatus == 'Pending'
                            ? Colors.orange
                            : Colors.blueGrey,
                      ),
                      CustomWidthSpacingWidget(width: 8),
                      _statusBadge(
                        stats.accountStatus.isEmpty
                            ? 'Pending'
                            : stats.accountStatus,
                        stats.accountStatus == 'Active'
                            ? AppColors.greenColor
                            : Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6.sp, color: color),
          CustomWidthSpacingWidget(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, GuideStatisticsModel stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DashboardStatCard(
                title: LocaleKeys.activeTours.tr(),
                // استخدام الـ Null-Coalescing لضمان عدم ضرب الـ null وعرض الصفر الحقيقي
                value: '${stats.activeTours}',
                icon: Icons.play_circle_outline,
                iconColor: AppColors.greenColor,
                animationDelay: 0,
              ),
            ),
            CustomWidthSpacingWidget(width: 10),
            Expanded(
              child: DashboardStatCard(
                title: 'Unique Tourists',
                value: '${stats.totalUniqueTourists}',
                icon: Icons.person_pin_circle_outlined,
                iconColor: Colors.deepPurple,
                animationDelay: 100,
              ),
            ),
            CustomWidthSpacingWidget(width: 10),
            Expanded(
              child: DashboardStatCard(
                title: LocaleKeys.averageRating.tr(),
                value: '⭐ ${(stats.averageRating).toStringAsFixed(1)}',
                icon: Icons.star_outline_rounded,
                iconColor: AppColors.starColore,
                animationDelay: 200,
              ),
            ),
          ],
        ),
        CustomHeightSpacingWidget(height: 10),
        Row(
          children: [
            Expanded(
              child: DashboardStatCard(
                title: LocaleKeys.completedTours.tr(),
                value: '${stats.completedTours}',
                icon: Icons.check_circle_outline,
                iconColor: const Color(0xFF6C63FF),
                animationDelay: 300,
              ),
            ),
            CustomWidthSpacingWidget(width: 10),
            Expanded(
              child: DashboardStatCard(
                title: 'Inactive Assets',
                value: '${stats.inactiveTours}',
                icon: Icons.pause_circle_outline,
                iconColor: Colors.blueGrey,
                animationDelay: 400,
              ),
            ),
            CustomWidthSpacingWidget(width: 10),
            Expanded(
              child: DashboardStatCard(
                title: 'Cancelled Orders',
                value: '${stats.cancelledTours}',
                icon: Icons.cancel_outlined,
                iconColor: AppColors.redAppColor,
                animationDelay: 500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
          ),
        ),
        CustomHeightSpacingWidget(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickAccessButton(
                label: 'Financial',
                icon: Icons.account_balance_wallet,
                onTap: () => context.pushNamed(
                  AppRoutes.financialLedgerScreen,
                  extra: dashboard,
                ),
              ),
            ),
            CustomWidthSpacingWidget(width: 10),
            Expanded(
              child: _QuickAccessButton(
                label: 'Verification',
                icon: Icons.verified_user,
                onTap: () =>
                    context.pushNamed(AppRoutes.identityVerificationScreen),
              ),
            ),
            CustomWidthSpacingWidget(width: 10),
            Expanded(
              child: _QuickAccessButton(
                label: 'My Tours',
                icon: Icons.tour,
                onTap: () => context.pushNamed(AppRoutes.toursManagementScreen),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WalletHeroCard extends StatelessWidget {
  const _WalletHeroCard({required this.stats});
  final GuideStatisticsModel stats;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.85 + (0.15 * value),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.secondaryColor, AppColors.primaryColor],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.walletBalance.tr(),
                      style: TextStyle(fontSize: 13.sp, color: Colors.white70),
                    ),
                    CustomHeightSpacingWidget(height: 4),
                    Text(
                      '\$${(stats.walletBalance).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
              ],
            ),
            CustomHeightSpacingWidget(height: 20),
            Container(height: 1, color: Colors.white.withOpacity(0.15)),
            CustomHeightSpacingWidget(height: 16),
            Row(
              children: [
                _walletMetric(
                  LocaleKeys.totalEarnings.tr(),
                  '\$${(stats.totalEarnings).toStringAsFixed(0)}',
                  Icons.trending_up_rounded,
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: Colors.white.withOpacity(0.15),
                ),
                _walletMetric(
                  'Pending Payouts',
                  '${stats.pendingWithdrawals}',
                  Icons.payments_outlined,
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: Colors.white.withOpacity(0.15),
                ),
                _walletMetric(
                  LocaleKeys.monthlyRevenue.tr(),
                  '\$${(stats.monthlyRevenue).toStringAsFixed(0)}',
                  Icons.calendar_month_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _walletMetric(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16.sp, color: Colors.white60),
          CustomHeightSpacingWidget(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          CustomHeightSpacingWidget(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 9.sp, color: Colors.white60),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryTextColor,
        ),
      ),
    );
  }
}

class _QuickAccessButton extends StatefulWidget {
  const _QuickAccessButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  State<_QuickAccessButton> createState() => _QuickAccessButtonState();
}

class _QuickAccessButtonState extends State<_QuickAccessButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: AppColors.primaryColor, size: 24.sp),
              CustomHeightSpacingWidget(height: 4),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget({
    required this.icon,
    required this.title,
    this.message,
  });
  final IconData icon;
  final String title;
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48.sp, color: AppColors.grey300Color),
            CustomHeightSpacingWidget(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey400Color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardLoadingSkeleton extends StatelessWidget {
  const _DashboardLoadingSkeleton();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 140.h,
          pinned: true,
          backgroundColor: AppColors.secondaryColor,
          leading: const BackButton(color: Colors.white),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondaryColor,
                    AppColors.primaryColor.withOpacity(0.85),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: [
                  Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  CustomHeightSpacingWidget(height: 16),
                  Row(
                    children: List.generate(
                      3,
                      (_) => Expanded(
                        child: Container(
                          height: 100.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomHeightSpacingWidget(height: 16),
                  Container(
                    height: 240.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardErrorView extends StatelessWidget {
  const _DashboardErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: AppColors.redAppColor.withOpacity(0.6),
            ),
            CustomHeightSpacingWidget(height: 16),
            Text(
              message.isEmpty ? 'An error occurred' : message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.secondaryTextColor,
              ),
            ),
            CustomHeightSpacingWidget(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(LocaleKeys.reset.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
