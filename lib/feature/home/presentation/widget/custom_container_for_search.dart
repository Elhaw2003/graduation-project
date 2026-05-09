import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';

class CustomContainerForSearchOnly extends StatefulWidget {
  // 👈 ضفنا الـ onChanged بتاعة زميلك في الـ StatefulWidget
  final Function(String value) onChanged;

  const CustomContainerForSearchOnly({super.key, required this.onChanged});

  @override
  State<CustomContainerForSearchOnly> createState() =>
      _CustomContainerForSearchOnlyState();
}

class _CustomContainerForSearchOnlyState
    extends State<CustomContainerForSearchOnly> {
  late List<String> _hintTexts;

  String _currentHint = "";
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _hintTexts = [
      LocaleKeys.searchDestinationsAndGuides.tr(),
      "Search for Pyramids...",
      "Find a local guide...",
      "Explore Luxor Temple...",
    ];
    _startAnimation();
  }

  void _startAnimation() {
    Duration duration = _isDeleting
        ? const Duration(milliseconds: 50)
        : const Duration(milliseconds: 100);

    _timer = Timer(duration, () {
      if (mounted) {
        setState(() {
          String fullText = _hintTexts[_textIndex];

          if (!_isDeleting) {
            _currentHint = fullText.substring(0, _charIndex + 1);
            _charIndex++;

            if (_charIndex == fullText.length) {
              _isDeleting = true;
              Future.delayed(const Duration(seconds: 2), _startAnimation);
              return;
            }
          } else {
            _currentHint = fullText.substring(0, _charIndex - 1);
            _charIndex--;

            if (_charIndex == 0) {
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
    _timer?.cancel();
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
        hintText: _currentHint,
        fillColor: AppColors.backgroundColor.withOpacity(0.5),

        // 👈 نادينا على הـ onChanged باستخدام widget.onChanged
        // لأننا جوه الـ State مش الـ StatefulWidget نفسه
        onChanged: widget.onChanged,
      ),
    );
  }
}
