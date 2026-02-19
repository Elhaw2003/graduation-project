import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/choosingIdentity/presentation/view/choosing_identity_screen.dart';
import 'package:smart_guide/feature/auth/choosingIdentity/presentation/view/widget/animated_slide_item.dart';
import 'package:smart_guide/feature/auth/choosingIdentity/presentation/view/widget/app_logo.dart';
import 'package:smart_guide/feature/auth/choosingIdentity/presentation/view/widget/identity_card.dart';

class ChoosingIdentityBody extends StatelessWidget {
  const ChoosingIdentityBody({
    super.key,
    required List<SlideAnimationConfig> animationConfigs,
  }) : _animationConfigs = animationConfigs;

  final List<SlideAnimationConfig> _animationConfigs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const AppLogo(),
                SizedBox(width: 20.w),
              ],
            ),
            SizedBox(height: 50.h),
            // Tourist Card
            AnimatedSlideItem(
              animation: _animationConfigs[0].animation,
              child: IdentityCard(
                title: 'Tourist',
                icon: Icons.airplanemode_active_outlined,
                backgroundColor: AppColors.primaryColor,
                onTap: () {},
              ),
            ),
            SizedBox(height: 50.h),
            // Guide Card
            AnimatedSlideItem(
              animation: _animationConfigs[1].animation,
              child: IdentityCard(
                title: 'Guide',
                icon: Icons.explore_outlined,
                backgroundColor: AppColors.primaryColor,
                onTap: () {
                  GoRouter.of(context).push(AppRoutes.loginScreen);
                },
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
