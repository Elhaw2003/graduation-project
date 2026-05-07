import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';

class CustomContainerForSearchOnly extends StatefulWidget {
  const CustomContainerForSearchOnly({super.key});

  @override
  State<CustomContainerForSearchOnly> createState() =>
      _CustomContainerForSearchOnlyState();
}

class _CustomContainerForSearchOnlyState
    extends State<CustomContainerForSearchOnly> {
  // قائمة النصوص اللي هتتبدل (ممكن تضيف أكتر)
  late List<String> _hintTexts;

  String _currentHint = "";
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // بنجهز النصوص من الـ Localization
    _hintTexts = [
      LocaleKeys.searchDestinationsAndGuides.tr(),
      "Search for Pyramids...",
      "Find a local guide...",
      "Explore Luxor Temple...",
    ];
    _startAnimation();
  }

  void _startAnimation() {
    // السرعة: لو بيمسح بيبقى أسرع
    Duration duration = _isDeleting
        ? const Duration(milliseconds: 50)
        : const Duration(milliseconds: 100);

    _timer = Timer(duration, () {
      if (mounted) {
        setState(() {
          String fullText = _hintTexts[_textIndex];

          if (!_isDeleting) {
            // حالة الكتابة: بنزود حرف
            _currentHint = fullText.substring(0, _charIndex + 1);
            _charIndex++;

            if (_charIndex == fullText.length) {
              // خلص كتابة الجملة، يستنى شوية وبعدين يبدأ يمسح
              _isDeleting = true;
              Future.delayed(const Duration(seconds: 2), _startAnimation);
              return;
            }
          } else {
            // حالة المسح: بننقص حرف
            _currentHint = fullText.substring(0, _charIndex - 1);
            _charIndex--;

            if (_charIndex == 0) {
              // خلص مسح، يدخل على الكلمة اللي بعدها
              _isDeleting = false;
              _textIndex = (_textIndex + 1) % _hintTexts.length;
            }
          }
          _startAnimation();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // مهم جداً عشان الميموري
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(10.r),
      child: CustomTextFieldWidget(
        suffixIcon: Icons.search,
        suffixColor: AppColors.primaryColor,
        hintTextStyle: TextStyle(
          color: AppColors.secondaryTextColor,
          fontSize: 14.sp,
        ),
        // بنباصي الـ currentHint اللي بيتغير كل شوية
        hintText: _currentHint,
        fillColor: AppColors.backgroundColor.withOpacity(0.5),
      ),
    );
  }
}
