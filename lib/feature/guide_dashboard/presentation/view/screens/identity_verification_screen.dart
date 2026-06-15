import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_states.dart';

extension ImageUrlFix on String {
  String toHttps() {
    if (startsWith('http://')) {
      return replaceFirst('http://', 'https://');
    }
    return this;
  }
}

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GuideDashboardCubit>().fetchDocuments();
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
          'Identity Verification',
          style: AppTextStyle.whitePoppinsW500S20,
        ),
      ),
      body: BlocBuilder<GuideDashboardCubit, GuideDashboardState>(
        builder: (context, state) {
          if (state is GetDocumentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetDocumentsFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: AppColors.redAppColor,
                  ),
                  SizedBox(height: 16.h),
                  Text(state.errorMessage),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<GuideDashboardCubit>().fetchDocuments(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is GetDocumentsSuccess) {
            final docs = state.documentsModel;
            final verificationStatus = _parseVerificationStatus(
              docs.verificationStatus,
            );

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _VerificationStatusBanner(
                    status: verificationStatus,
                    guideName: docs.fullName.isEmpty
                        ? 'Guide Profile'
                        : docs.fullName,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Documents',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // كارت البطاقة الشخصية باستخدام الكاش والـ Extension
                  _LocalDocumentCard(
                    title: 'National ID',
                    subtitle: 'Government-issued identification',
                    imageUrl: docs.nationalIdImageUrl.toHttps(),
                    icon: Icons.badge,
                  ),
                  SizedBox(height: 12.h),

                  // كارت الرخصة باستخدام الكاش والـ Extension
                  _LocalDocumentCard(
                    title: 'License',
                    subtitle: 'Tour guide license or certification',
                    imageUrl: docs.licenseImageUrl.toHttps(),
                    icon: Icons.card_membership,
                  ),
                  SizedBox(height: 24.h),
                  _DocumentInfoBox(
                    guideId: docs.guideId,
                    rawStatus: docs.verificationStatus,
                  ),
                  SizedBox(height: 24.h),
                  _VerificationRequirements(status: verificationStatus),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  VerificationStatus _parseVerificationStatus(String status) {
    if (status.isEmpty) return VerificationStatus.notVerified;
    if (status.toLowerCase() == 'approved') return VerificationStatus.approved;
    if (status.toLowerCase() == 'rejected') return VerificationStatus.rejected;
    if (status.toLowerCase() == 'notverified')
      return VerificationStatus.notVerified;
    return VerificationStatus.pending;
  }
}

enum VerificationStatus { approved, pending, rejected, notVerified }

// =============================================================================
// كارت التوثيق المطور بـ CachedNetworkImage
// =============================================================================
class _LocalDocumentCard extends StatelessWidget {
  const _LocalDocumentCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 24.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180.h,
                      color: Colors.grey.shade50,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 180.h,
                      color: Colors.grey.shade100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 32.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "SSL or Connection Network Error",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 180.h,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _VerificationStatusBanner extends StatelessWidget {
  const _VerificationStatusBanner({
    required this.status,
    required this.guideName,
  });
  final VerificationStatus status;
  final String guideName;

  @override
  Widget build(BuildContext context) {
    final (color, icon, statusText) = switch (status) {
      VerificationStatus.approved => (
        AppColors.greenColor,
        Icons.check_circle,
        'Verified Holder',
      ),
      VerificationStatus.rejected => (
        AppColors.redAppColor,
        Icons.cancel,
        'Rejected Documents',
      ),
      VerificationStatus.pending => (
        Colors.orange,
        Icons.pending,
        'Pending Review',
      ),
      VerificationStatus.notVerified => (
        Colors.blueGrey,
        Icons.no_accounts_outlined,
        'Not Verified Yet',
      ),
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.04)],
        ),
        border: Border.all(color: color.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      guideName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (status == VerificationStatus.notVerified) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(8.w),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                'Your account profile lacks active identity verifications. Please contact administration support desk.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.blueGrey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          if (status == VerificationStatus.pending) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                'Your documents are under review. This usually takes 3-5 business days.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DocumentInfoBox extends StatelessWidget {
  const _DocumentInfoBox({required this.guideId, required this.rawStatus});
  final String guideId;
  final String rawStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document Information',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 12.h),
          _DocumentInfoRow(
            label: 'Guide ID',
            value: guideId.isEmpty ? 'Not assigned' : guideId,
          ),
          SizedBox(height: 8.h),
          _DocumentInfoRow(
            label: 'Last Synced Audit',
            value: DateTime.now().toString().split(' ')[0],
          ),
          SizedBox(height: 8.h),
          _DocumentInfoRow(label: 'Server Log Status', value: rawStatus),
        ],
      ),
    );
  }
}

class _DocumentInfoRow extends StatelessWidget {
  const _DocumentInfoRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.secondaryTextColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}

class _VerificationRequirements extends StatelessWidget {
  const _VerificationRequirements({required this.status});
  final VerificationStatus status;

  @override
  Widget build(BuildContext context) {
    final checked = status == VerificationStatus.approved;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100Color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verification Checklist',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 12.h),
          _ChecklistItem(
            label: 'Valid National ID Attached',
            isCompleted: checked,
          ),
          SizedBox(height: 8.h),
          _ChecklistItem(
            label: 'Valid Tour Guide License Verified',
            isCompleted: checked,
          ),
          SizedBox(height: 8.h),
          _ChecklistItem(
            label: 'Clear Document Resolution Check',
            isCompleted: checked,
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.label, required this.isCompleted});
  final String label;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 20.sp,
          color: isCompleted ? AppColors.greenColor : AppColors.grey300Color,
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: isCompleted
                ? AppColors.primaryTextColor
                : AppColors.grey400Color,
          ),
        ),
      ],
    );
  }
}
