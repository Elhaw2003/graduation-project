import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/methods/save_place_feedback.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/all_guides/data/model/tour_guide_model.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_cubit.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_states.dart'
    show SavedGuidesState, RemoveGuideSuccess, SaveGuideSuccess;
import 'package:smart_guide/generated/locale_keys.g.dart';

class ActionRowInTourGuideScreen extends StatefulWidget {
  const ActionRowInTourGuideScreen({
    super.key,
    required this.guideId,
    this.guideProfile,
    this.onProfileUpdated,
    this.showTitle = true,
  });

  final String guideId;
  final TourGuideModel? guideProfile;
  final VoidCallback? onProfileUpdated;
  final bool showTitle;

  @override
  State<ActionRowInTourGuideScreen> createState() =>
      _ActionRowInTourGuideScreenState();
}

class _ActionRowInTourGuideScreenState
    extends State<ActionRowInTourGuideScreen> {
  bool _canSaveGuide = false;
  bool _canEditProfile = false;

  @override
  void initState() {
    super.initState();
    _resolveActionVisibility();
  }

  Future<void> _resolveActionVisibility() async {
    final storage = SecureStorageHelper.instance;
    final userType = await storage.getUserTypeEnum();
    final currentUserId = await storage.getUserId();

    if (!mounted) return;

    final bool isTourist = userType == UserTypeEnum.Tourist;
    final bool isGuide = userType == UserTypeEnum.TourGuide;
    final bool isViewingOwnProfile = currentUserId == widget.guideId;

    setState(() {
      _canSaveGuide = isTourist && !isViewingOwnProfile;
      _canEditProfile = isGuide && isViewingOwnProfile;
    });
  }

  Future<void> _openEditProfile() async {
    final result = await context.pushNamed(
      AppRoutes.editGuideProfileScreen,
      pathParameters: {'guideId': widget.guideId},
      extra: widget.guideProfile,
    );

    if (result != null && mounted) {
      widget.onProfileUpdated?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return BlocListener<SavedGuidesCubit, SavedGuidesState>(
      listener: (context, state) {
        if (state is SaveGuideSuccess &&
            state.savedIds.contains(widget.guideId)) {
          SaveFeedback.savedGuide(context);
        } else if (state is RemoveGuideSuccess &&
            !state.savedIds.contains(widget.guideId)) {
          SaveFeedback.removedGuide(context);
        }
      },
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(8.w, topPadding + 6.h, 12.w, 10.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.45),
                  Colors.black.withValues(alpha: 0.18),
                  Colors.transparent,
                ],
              ),
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _GlassIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => context.pop(),
                  tooltip: LocaleKeys.close.tr(),
                ),
                // if (widget.showTitle) ...[
                //   SizedBox(width: 8.w),
                //   Expanded(
                //     child: Text(
                //       widget.guideProfile != null &&
                //               widget.guideProfile!.firstName.isNotEmpty
                //           ? '${widget.guideProfile!.firstName} ${widget.guideProfile!.lastName}'
                //               .trim()
                //           : LocaleKeys.guide.tr(),
                //       style: AppTextStyle.backgroundW500S17.copyWith(
                //         fontSize: 16.sp,
                //         fontWeight: FontWeight.w600,
                //         shadows: [
                //           Shadow(
                //             color: Colors.black.withValues(alpha: 0.35),
                //             blurRadius: 8,
                //           ),
                //         ],
                //       ),
                //       maxLines: 1,
                //       overflow: TextOverflow.ellipsis,
                //     ),
                //   ),
                // ] else
                // const Spacer(),
                if (_canEditProfile)
                  _GlassIconButton(
                    icon: Icons.edit_rounded,
                    onTap: _openEditProfile,
                    tooltip: LocaleKeys.editProfile.tr(),
                    accentColor: AppColors.secondaryColor,
                  ),
                if (_canSaveGuide)
                  BlocBuilder<SavedGuidesCubit, SavedGuidesState>(
                    builder: (context, state) {
                      final savedIds = state.getSavedIds();
                      final isSaved = savedIds.contains(widget.guideId);

                      return Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: _GlassIconButton(
                          icon: isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          onTap: () {
                            if (isSaved) {
                              context.read<SavedGuidesCubit>().removeGuide(
                                guideId: widget.guideId,
                              );
                            } else {
                              context.read<SavedGuidesCubit>().saveGuide(
                                guideId: widget.guideId,
                              );
                            }
                          },
                          tooltip: LocaleKeys.savedForLater.tr(),
                          accentColor: isSaved
                              ? AppColors.primaryColor
                              : Colors.white,
                          filled: isSaved,
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
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.accentColor = Colors.white,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color accentColor;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          splashColor: Colors.white24,
          child: Ink(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: filled
                  ? accentColor.withValues(alpha: 0.22)
                  : Colors.white.withValues(alpha: 0.14),
              border: Border.all(
                color: filled
                    ? accentColor.withValues(alpha: 0.55)
                    : Colors.white.withValues(alpha: 0.28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: accentColor, size: 22.sp),
          ),
        ),
      ),
    );
  }
}

/// Minimal pinned bar with back only — for loading/error states.
class TourGuideProfilePinnedBackBar extends StatelessWidget {
  const TourGuideProfilePinnedBackBar({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(8.w, topPadding + 6.h, 12.w, 10.h),
          color: Colors.black.withValues(alpha: 0.25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: _GlassIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => context.pop(),
              tooltip: LocaleKeys.close.tr(),
            ),
          ),
        ),
      ),
    );
  }
}
