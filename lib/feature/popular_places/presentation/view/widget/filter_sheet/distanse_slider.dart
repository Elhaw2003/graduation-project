import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class DistanceSlider extends StatefulWidget {
  const DistanceSlider({super.key});

  @override
  State<DistanceSlider> createState() => _DistanceSliderState();
}

class _DistanceSliderState extends State<DistanceSlider> {
  double _currentValue = 25;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.distance.tr(),
          style: AppTextStyle.primaryPoppinsTextW600S18,
        ),
        const CustomHeightSpacingWidget(height: 12),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 12.h, // ارتفاع الـ Track عشان يبان عريض زي الصورة
              activeTrackColor: AppColors.primaryColor,
              inactiveTrackColor: AppColors.whiteColor,
              tickMarkShape: SliderTickMarkShape.noTickMark,

              // 1. شكل الدائرة (Thumb) - بنخليها بيضاء وليها برواز أزرق غامق
              thumbColor: Colors.white,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 12.r,
                elevation: 5,
                pressedElevation: 8,
              ),
              // هنا بنرسم البرواز الأزرق اللي حول الدائرة البيضاء
              overlayColor: AppColors.primaryColor.withOpacity(0.2),

              // 2. شكل الـ Label (الفقاعة اللي فوق)
              // valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
              valueIndicatorColor: AppColors.primaryColor,
              valueIndicatorTextStyle: AppTextStyle.whitePoppinsW500S20
                  .copyWith(fontSize: 16.sp), // استايل الخط جواها
            ),
            child: Slider(
              value: _currentValue,
              max: 700, // حسب الصورة الـ Max واصل لـ 700
              min: 0,
              divisions: 7, // عشان يتحرك خطوات 100، 200...
              label: "${_currentValue.round()} Km",
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
