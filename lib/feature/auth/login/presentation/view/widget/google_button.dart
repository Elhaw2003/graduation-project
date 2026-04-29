import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_loading_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class GoogleSignInButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton>
    with SingleTickerProviderStateMixin {
  // 1. تعريف الأنيكيشن كنترولر
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // 2. إعداد الكنترولر (مدة قصيرة جداً للضغط)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // سرعة الاستجابة
    );

    // 3. تعريف الأنيميشن (من حجم 1.0 لـ 0.95)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose(); // مهم جداً تنظيف الكنترولر
    super.dispose();
  }

  // ميثود بتبدأ الأنيميشن (تصغير)
  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      _controller.forward();
    }
  }

  // ميثود بترجع الزرار لحجمه الطبيعي وتنفذ الأكشن
  void _onTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      _controller.reverse();
      widget.onPressed();
    }
  }

  // ميثود في حاله إن المستخدم حرك صباعه بره الزرار وهو ضاغط
  void _onTapCancel() {
    if (!widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4. استخدام ScaleTransition لعمل الأنيميشن
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            color: AppColors.whiteColor, // خلفية بيضاء
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.grey200Color), // بوردر خفيف
            boxShadow: [
              // ظل خفيف عشان يبان إنه زرار
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: widget.isLoading
              ? const Center(
                  child: CustomLoadingWidget(
                    cicleHeight: 25,
                    cicleWidth: 25,
                    strokeWidth: 2,
                    strokeAlign: -1,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // استبدل هذا المسار بمسار لوجو جوجل الحقيقي عندك
                    SvgPicture.asset(
                      Assets.imagesSvgGoogle, // تأكد من وجود الصورة
                      height: 24.h,
                    ),
                    CustomWidthSpacingWidget(width: 12),
                    Text(
                      LocaleKeys.continueWithGoogle.tr(),
                      style: AppTextStyle.black1F2937W400S17,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
