import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/settings/data/repo/log_out/log_out_repo_imple.dart';
import 'package:smart_guide/feature/settings/presentation/cubit/log_out/cubit/log_out_cubit.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/log_out_dialog.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: const Color(0xff1F222A),
      child: SafeArea(
        child: Column(
          // Main layout split into scrollable content and fixed footer
          children: [
            // Scrollable section
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomHeightSpacingWidget(height: 30.h),
                      _buildProfileSection(),
                      CustomHeightSpacingWidget(height: 40.h),

                      _buildDrawerItem(
                        onTap: () =>
                            context.pushNamed(AppRoutes.popularPlacesScreen),
                        icon: Icons.local_fire_department_outlined,
                        title: LocaleKeys.popularPlaces.tr(),
                        index: 1,
                      ),
                      _buildDrawerItem(
                        onTap: () =>
                            context.pushNamed(AppRoutes.exploreArSpotsScreen),
                        icon: Icons.view_in_ar_outlined,
                        title: LocaleKeys.arSpots.tr(),
                        index: 2,
                      ),
                      _buildDrawerItem(
                        icon: Icons.map_outlined,
                        title: LocaleKeys.map.tr(),
                        index: 3,
                      ),
                      CustomHeightSpacingWidget(height: 20.h),
                      _buildDrawerItem(
                        icon: Icons.folder_outlined,
                        title: LocaleKeys.myArchives.tr(),
                        index: 4,
                      ),
                      _buildDrawerItem(
                        icon: Icons.person_outline,
                        title: LocaleKeys.myGuides.tr(),
                        index: 5,
                      ),
                      CustomHeightSpacingWidget(height: 20.h),
                      _buildDrawerItem(
                        onTap: () =>
                            context.pushNamed(AppRoutes.settingsScreen),
                        icon: Icons.settings_outlined,
                        title: LocaleKeys.settings.tr(),
                        index: 6,
                      ),
                      _buildDrawerItem(
                        icon: Icons.info_outline,
                        title: LocaleKeys.about_app.tr(),
                        index: 7,
                      ),
                      _buildDrawerItem(
                        icon: Icons.support_agent_outlined,
                        title: LocaleKeys.support.tr(),
                        index: 8,
                      ),
                      _buildDrawerItem(
                        icon: Icons.privacy_tip_outlined,
                        title: LocaleKeys.terms_of_service.tr(),
                        index: 9,
                      ),
                      CustomHeightSpacingWidget(height: 20.h),
                      _buildDrawerItem(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                              value: LogOutCubit(
                                logOutRepo: LogOutRepoImple(
                                  apiConsumer: DioConsumer(dio: Dio()),
                                ),
                              ),
                              child: const LogOutDialog(),
                            ),
                          );
                        },
                        icon: Icons.logout,
                        title: LocaleKeys.logout.tr(),
                        index: 10,
                        isLogout: true,
                      ),
                      CustomHeightSpacingWidget(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),

            // Fixed footer section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white10, width: 0.5),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Smart Guide V1.0.0',
                    style: AppTextStyle.thirdTextW400S17.copyWith(
                      color: Colors.white38,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Developed by Tanta University Team',
                    style: AppTextStyle.thirdTextW400S17.copyWith(
                      color: Colors.white24,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildProfileSection() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryColor, width: 2),
              ),
              child: CircleAvatar(
                radius: 45.r,
                backgroundImage: AssetImage(Assets.imagesPngSphinx),
              ),
            ),
            CustomHeightSpacingWidget(height: 12.h),
            Text(
              'Mostafa Ahmed',
              style: AppTextStyle.thirdTextW900S20.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: child,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          icon,
          color: isLogout ? AppColors.redColor : AppColors.primaryColor,
          size: 22.sp,
        ),
        title: Text(
          title,
          style: AppTextStyle.thirdTextW400S17.copyWith(
            color: isLogout ? AppColors.redColor : AppColors.whiteColor,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
