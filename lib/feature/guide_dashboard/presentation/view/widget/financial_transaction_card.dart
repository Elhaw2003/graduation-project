import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/wallet_transaction_model.dart';

class FinancialTransactionCard extends StatelessWidget {
  const FinancialTransactionCard({required this.transaction});

  final WalletTransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor, actionLabel) = _getTransactionDetails();
    final formattedDate = _formatDate(transaction.parsedDate);
    final statusColor = _getStatusColor();

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.grey300Color.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        actionLabel,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      Text(
                        '${transaction.type.isEmpty ? 'N/A' : transaction.type}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.grey400Color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.grey400Color,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          transaction.status.isEmpty ? 'Unknown' : transaction.status,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '\$${(transaction.amount == 0 ? 0 : transaction.amount).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: transaction.type.toLowerCase().contains('withdrawal') ||
                        transaction.type.toLowerCase().contains('debit')
                    ? AppColors.redAppColor
                    : AppColors.greenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color, String) _getTransactionDetails() {
    if (transaction.type.isEmpty) {
      return (Icons.payment, AppColors.primaryColor, 'Transaction');
    }

    final type = transaction.type.toLowerCase();
    if (type.contains('withdrawal') || type.contains('withdraw')) {
      return (Icons.arrow_downward, AppColors.redAppColor, 'Withdrawal');
    } else if (type.contains('deposit') || type.contains('credit')) {
      return (Icons.arrow_upward, AppColors.greenColor, 'Deposit');
    } else if (type.contains('refund')) {
      return (Icons.undo, Colors.orange, 'Refund');
    } else if (type.contains('earning') || type.contains('earned')) {
      return (Icons.trending_up, AppColors.greenColor, 'Earning');
    } else {
      return (Icons.payment, AppColors.primaryColor, 'Transaction');
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    try {
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return transaction.createdAt.isEmpty ? 'N/A' : transaction.createdAt;
    }
  }

  Color _getStatusColor() {
    if (transaction.status.isEmpty) return AppColors.grey400Color;

    final status = transaction.status.toLowerCase();
    if (status.contains('completed') || status.contains('success')) {
      return AppColors.greenColor;
    } else if (status.contains('pending')) {
      return Colors.orange;
    } else if (status.contains('failed') || status.contains('reject')) {
      return AppColors.redAppColor;
    }
    return AppColors.grey400Color;
  }
}
