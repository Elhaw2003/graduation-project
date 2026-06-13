import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class TouristProfileHeader extends StatelessWidget {
  const TouristProfileHeader({
    super.key,
    required this.profile,
    required this.isEditMode,
    required this.onToggleEditMode,
    this.localImagePath,
  });

  final TouristProfileModel profile;
  final bool isEditMode;
  final VoidCallback onToggleEditMode;
  final String? localImagePath;

  @override
  Widget build(BuildContext context) {
    final expandedHeight = 264.h;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      stretch: true,
      elevation: 10,
      forceElevated: true,
      automaticallyImplyLeading: false,
      shadowColor: AppColors.blackColor.withOpacity(0.15),
      backgroundColor: AppColors.secondaryColor,
      leading: const BackButton(color: Colors.white),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final topPadding = MediaQuery.of(context).padding.top;
          final minHeight = kToolbarHeight + topPadding;
          final t =
              ((constraints.maxHeight - minHeight) /
                      (expandedHeight - minHeight))
                  .clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Opacity(
              opacity: t,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAvatar(),
                  CustomHeightSpacingWidget(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      profile.fullName.isNotEmpty
                          ? profile.fullName
                          : profile.userName,
                      key: ValueKey(
                        profile.fullName.isNotEmpty
                            ? profile.fullName
                            : profile.userName,
                      ),
                      style: AppTextStyle.whitePoppinsW500S24,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CustomHeightSpacingWidget(height: 8),
                  CustomButtonWidget(
                    buttonHeight: 40,
                    buttonColor: isEditMode
                        ? AppColors.redAppColor
                        : AppColors.secondaryColor,
                    borderSideColor: AppColors.whiteColor,
                    buttonWidth: 180.w,
                    borderRadiusButton: 12,
                    title: isEditMode
                        ? LocaleKeys.cancel.tr()
                        : LocaleKeys.editProfile.tr(),
                    titleStyle: AppTextStyle.whitePoppinsW400S16,
                    prefixIcon: isEditMode ? Icons.close : Icons.edit_outlined,
                    prefixIconColor: AppColors.whiteColor,
                    prefixIconSize: 20.sp,
                    onPressed: onToggleEditMode,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: KeyedSubtree(
        key: ValueKey(localImagePath ?? profile.touristImage),
        child: _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (localImagePath != null && localImagePath!.isNotEmpty) {
      return CircleAvatar(
        radius: 50.r,
        backgroundImage: FileImage(File(localImagePath!)),
      );
    }

    if (profile.touristImage.isNotEmpty) {
      return CircleAvatar(
        radius: 50.r,
        backgroundColor: AppColors.grey200Color,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: profile.touristImage.toHttps(),
            width: 100.r,
            height: 100.r,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildTransparentPlaceholder(),
            errorWidget: (context, url, error) =>
                _buildTransparentPlaceholder(),
          ),
        ),
      );
    }

    return _buildTransparentPlaceholder();
  }

  Widget _buildTransparentPlaceholder() {
    return CircleAvatar(
      radius: 50.r,
      backgroundColor: Colors.white.withOpacity(0.15),
    );
  }
}
