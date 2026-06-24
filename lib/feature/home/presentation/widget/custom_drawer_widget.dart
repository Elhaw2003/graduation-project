import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/di.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_session/tourist_session_cubit.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_session/tourist_session_states.dart';
import 'package:smart_guide/feature/settings/presentation/cubit/log_out/cubit/log_out_cubit.dart';
import 'package:smart_guide/feature/settings/presentation/view/about_app_screen.dart';
import 'package:smart_guide/feature/settings/presentation/view/terms_of_service.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/log_out_dialog.dart';
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
                      // _buildDrawerItem(
                      //   onTap: () =>
                      //       context.pushNamed(AppRoutes.exploreArSpotsScreen),
                      //   icon: Icons.view_in_ar_outlined,
                      //   title: LocaleKeys.arSpots.tr(),
                      //   index: 2,
                      // ),
                      // _buildDrawerItem(
                      //   icon: Icons.map_outlined,
                      //   title: LocaleKeys.map.tr(),
                      //   index: 3,
                      // ),
                      // CustomHeightSpacingWidget(height: 20.h),
                      // _buildDrawerItem(
                      //   icon: Icons.folder_outlined,
                      //   title: LocaleKeys.myArchives.tr(),
                      //   index: 4,
                      // ),
                      // _buildDrawerItem(
                      //   icon: Icons.person_outline,
                      //   title: LocaleKeys.myGuides.tr(),
                      //   index: 5,
                      // ),
                      CustomHeightSpacingWidget(height: 20.h),
                      _buildDrawerItem(
                        onTap: () =>
                            context.pushNamed(AppRoutes.settingsScreen),
                        icon: Icons.settings_outlined,
                        title: LocaleKeys.settings.tr(),
                        index: 6,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle tap event for Help Center
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AboutAppScreen(),
                            ),
                          );
                        },
                        child: _buildDrawerItem(
                          icon: Icons.info_outline,
                          title: LocaleKeys.about_app.tr(),
                          index: 7,
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.support_agent_outlined,
                        title: LocaleKeys.support.tr(),
                        index: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle tap event for Terms of Service
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsOfServiceScreen(),
                            ),
                          );
                        },
                        child: _buildDrawerItem(
                          icon: Icons.privacy_tip_outlined,
                          title: LocaleKeys.terms_of_service.tr(),
                          index: 9,
                        ),
                      ),
                      CustomHeightSpacingWidget(height: 20.h),
                      _buildDrawerItem(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider(
                              create: (_) => sl<LogOutCubit>(),
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
    return BlocBuilder<TouristSessionCubit, TouristSessionState>(
      builder: (context, sessionState) {
        final session = sessionState is TouristSessionLoaded
            ? sessionState
            : const TouristSessionLoaded(
                userName: '',
                profilePic: null,
                userId: '',
              );

        final displayName = session.userName.isNotEmpty
            ? session.userName
            : LocaleKeys.tourist.tr();

        return TweenAnimationBuilder(
          key: ValueKey(
            '${session.userId}_${session.profilePic ?? displayName}',
          ),
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          builder: (context, value, child) =>
              Transform.scale(scale: value, child: child),
          child: Center(
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: Container(
                    key: ValueKey(session.profilePic ?? displayName),
                    padding: EdgeInsets.all(3.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 45.r,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      backgroundImage:
                          session.profilePic != null &&
                              session.profilePic!.isNotEmpty
                          ? CachedNetworkImageProvider(
                              session.profilePic!.toHttps(),
                            )
                          : null,
                      child:
                          session.profilePic == null ||
                              session.profilePic!.isEmpty
                          ? Icon(
                              Icons.person_rounded,
                              size: 40.sp,
                              color: Colors.white.withOpacity(0.4),
                            )
                          : null,
                    ),
                  ),
                ),
                CustomHeightSpacingWidget(height: 12.h),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    displayName,
                    key: ValueKey(displayName),
                    style: AppTextStyle.thirdTextW900S20.copyWith(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
