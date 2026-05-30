import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_wallet_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/monthly_earning_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/wallet_transaction_model.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_states.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/view/widget/financial_transaction_card.dart';

class FinancialLedgerScreen extends StatefulWidget {
  const FinancialLedgerScreen({super.key});

  @override
  State<FinancialLedgerScreen> createState() => _FinancialLedgerScreenState();
}

class _FinancialLedgerScreenState extends State<FinancialLedgerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // خزائن الذاكرة المحلية لحفظ كائنات الداتا ومنع اختفائها عند نداء تابة أخرى
  GuideWalletModel? _cachedWallet;
  List<WalletTransactionModel>? _cachedTransactions;
  List<MonthlyEarningModel>? _cachedEarnings;

  // مؤشرات اللودنج المنفصلة لكل تابة
  bool _isWalletLoading = false;
  bool _isTransactionsLoading = false;
  bool _isEarningsLoading = false;

  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(_handleTabSelection);

    // تحميل داتا التابة الأولى فوراً
    _triggerTabFetch(0);
  }

  void _handleTabSelection() {
    // الشرط ده كدة هيلقط الضغطة (indexIsChanging) وكمان هيلقط السحبة (Swipe) أول ما تستقر على التابة الجديدة
    if (_tabController.index != _currentTabIndex) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
      _triggerTabFetch(_currentTabIndex);
    }
  }

  void _triggerTabFetch(int index) {
    final cubit = context.read<GuideDashboardCubit>();

    if (index == 0 && _cachedWallet == null) {
      setState(() => _isWalletLoading = true);
      cubit.fetchWallet();
    } else if (index == 1 && _cachedTransactions == null) {
      setState(() => _isTransactionsLoading = true);
      cubit.fetchWalletTransactions();
    } else if (index == 2 && _cachedEarnings == null) {
      setState(() => _isEarningsLoading = true);
      cubit.fetchEarnings();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          'Financial Ledger',
          style: AppTextStyle.whitePoppinsW500S20,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(child: Text('Wallet')),
            Tab(child: Text('Transactions')),
            Tab(child: Text('Earnings')),
          ],
        ),
      ),
      body: BlocListener<GuideDashboardCubit, GuideDashboardState>(
        listener: (context, state) {
          // لقط الحالات وتخزينها فوراً في الذاكرة المحلية للشاشة مع إطفاء مؤشر اللودنج
          if (state is GetWalletSuccess) {
            setState(() {
              _cachedWallet = state.walletModel;
              _isWalletLoading = false;
            });
          }
          if (state is GetWalletTransactionsSuccess) {
            setState(() {
              _cachedTransactions = state.transactionsList;
              _isTransactionsLoading = false;
            });
          }
          if (state is GetEarningsSuccess) {
            setState(() {
              _cachedEarnings = state.earningsList;
              _isEarningsLoading = false;
            });
          }

          // إطفاء اللودنج في حالة الفشل
          if (state is GetWalletFailure)
            setState(() => _isWalletLoading = false);
          if (state is GetWalletTransactionsFailure)
            setState(() => _isTransactionsLoading = false);
          if (state is GetEarningsFailure)
            setState(() => _isEarningsLoading = false);
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildWalletTab(),
            _buildTransactionsTab(),
            _buildEarningsTab(),
          ],
        ),
      ),
    );
  }

  // =============================================================================
  // 💰 Wallet View
  // =============================================================================
  Widget _buildWalletTab() {
    if (_isWalletLoading)
      return const Center(child: CircularProgressIndicator());
    if (_cachedWallet != null) {
      final wallet = _cachedWallet!;
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _WalletMetricCard(
              title: 'Current Balance',
              value: '\$${wallet.walletBalance.toStringAsFixed(2)}',
              icon: Icons.account_balance_wallet,
              color: AppColors.greenColor,
            ),
            SizedBox(height: 12.h),
            _WalletMetricCard(
              title: 'Pending Earnings',
              value: '\$${wallet.pendingEarnings.toStringAsFixed(2)}',
              icon: Icons.hourglass_empty,
              color: Colors.orange,
            ),
            SizedBox(height: 12.h),
            _WalletMetricCard(
              title: 'Pending Withdrawals',
              value: '${wallet.pendingWithdrawals}',
              icon: Icons.arrow_downward,
              color: AppColors.primaryColor,
              subtitle: 'Requests in queue',
            ),
            SizedBox(height: 24.h),
            _buildWalletActions(),
          ],
        ),
      );
    }
    return const Center(child: Text('Click to sync wallet core...'));
  }

  Widget _buildWalletActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Withdraw',
                icon: Icons.send,
                onTap: () {},
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ActionButton(
                label: 'History',
                icon: Icons.history,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =============================================================================
  // 📑 Transactions View
  // =============================================================================
  Widget _buildTransactionsTab() {
    if (_isTransactionsLoading)
      return const Center(child: CircularProgressIndicator());
    if (_cachedTransactions != null) {
      final transactions = _cachedTransactions!;
      if (transactions.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 48.sp,
                color: AppColors.grey300Color,
              ),
              SizedBox(height: 16.h),
              Text(
                'No transactions yet',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.grey400Color,
                ),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: transactions.length,
        itemBuilder: (context, index) =>
            FinancialTransactionCard(transaction: transactions[index]),
      );
    }
    return const Center(child: Text('Click to load transactions...'));
  }

  // =============================================================================
  // 📈 Earnings View
  // =============================================================================
  Widget _buildEarningsTab() {
    if (_isEarningsLoading)
      return const Center(child: CircularProgressIndicator());
    if (_cachedEarnings != null) {
      final earnings = _cachedEarnings!;
      if (earnings.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.trending_up_outlined,
                size: 48.sp,
                color: AppColors.grey300Color,
              ),
              SizedBox(height: 16.h),
              Text(
                'No earnings data',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.grey400Color,
                ),
              ),
            ],
          ),
        );
      }

      double totalEarnings = earnings.fold(
        0,
        (sum, item) => sum + item.earnings,
      );

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondaryColor, AppColors.primaryColor],
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Earnings',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '\$${totalEarnings.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Monthly Breakdown',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            ...earnings.map((earning) => _EarningMonthItem(earning: earning)),
          ],
        ),
      );
    }
    return const Center(child: Text('Click to request earnings stream...'));
  }
}

// =============================================================================
// Design Helper Widgets
// =============================================================================
class _WalletMetricCard extends StatelessWidget {
  const _WalletMetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12.r),
        color: color.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.grey400Color,
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 20.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarningMonthItem extends StatelessWidget {
  const _EarningMonthItem({required this.earning});
  final dynamic earning;

  @override
  Widget build(BuildContext context) {
    final monthName = _getMonthName(earning.month);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300Color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$monthName ${earning.year}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            Text(
              '\$${earning.earnings.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.greenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return month > 0 && month <= 12 ? months[month - 1] : 'Unknown';
  }
}
